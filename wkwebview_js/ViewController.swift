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
        if message.name == "loginAction" {
            print("Javascript is sending message \(message.body)")
            let alertMsg = UIAlertController(title: "WKWebView Msg", message: message.body as! String, preferredStyle: .alert)
            
            alertMsg.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alertMsg,animated: true)
            
        }
    }
    
    var webView : WKWebView!
    
    private func setupWebView(){
        let contentController = WKUserContentController()
        let userScript = WKUserScript(source: "mobileHeader()", injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        
        contentController.addUserScript(userScript)
        contentController.add(self , name : "loginAction")
        
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


}

