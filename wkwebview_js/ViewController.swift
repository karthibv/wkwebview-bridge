//
//  ViewController.swift
//  wkwebview_js
//
//  Created by Karthik on 14/4/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController  , WKScriptMessageHandler{
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("User message got")
        if let theBody = message.body as? [String: Any] {
            if let guid = theBody["guid"] as? String {
                print("guid of the promise is " + guid)
                if let message = theBody["message"] as? String {
                    print("message of the promise is " + message)
                    if message == "getCurrencyList" {
                        fetchCurrencyList(guid: guid)
                    }
                }
            }
        }
    }
    
    var webView : WKWebView!
    
    private func setupWebView(){
        let contentController = WKUserContentController()
        let userScript = WKUserScript(source: "mobileHeader()", injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        
        //contentController.addUserScript(userScript)
        contentController.add(self , name : "nativeProcess")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        self.webView = WKWebView(frame: self.view.bounds, configuration: config)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupWebView()
        self.view.addSubview(self.webView)
        
        let bundleURL = Bundle.main.resourceURL!.absoluteURL
        let html = bundleURL.appendingPathComponent("index.html")
        webView.loadFileURL(html, allowingReadAccessTo: bundleURL)
    }

    
    //API for currency List
    func fetchCurrencyList(guid: String){
        
        let request = NSMutableURLRequest(url : NSURL(string : "https://openexchangerates.org/api/currencies.json")! as URL, cachePolicy :.useProtocolCachePolicy, timeoutInterval : 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask (with : request as URLRequest , completionHandler : {data,response,error -> Void in
            if(error != nil){
                print(error!)
            }else{
                _ = response as? HTTPURLResponse
                let theString = String(data: data!, encoding: .utf8)
                print(theString!)
                DispatchQueue.main.async {
                    self.executeCallBack(guid: guid, data: theString!)
                }
            }
        })
        dataTask.resume()

    }
    
    func executeCallBack(guid: String, data: String) {

        let rsData = data.base64Encoded()
        let js2:String = "executeCallback('\(guid)','\(rsData!)')"

        print(js2)
        
        webView.evaluateJavaScript(js2) {
            (data, err) in
            print("Finished calling......")
        }
    }


}

extension String {
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
}


