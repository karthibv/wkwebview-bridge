//
//  NativeWebBridgeController.swift
//  wkwebview_js
//
//  Created by Karthik on 28/4/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import Foundation
import WebKit

class NativeWebBridgeController : UIViewController , WKScriptMessageHandler , WKUIDelegate , WKNavigationDelegate {
    
    public var wk:WKWebView!
    public var delegate: NativeWebBridgeErrorsDelegate?

    
    public var url: String! {
        didSet{
            if let urlString = self.url {
                if let url = NSURL(string: urlString) {
                    let request = NSURLRequest(url: url as URL)
                    self.wk.load(request as URLRequest)
                    NSLog("Load ended: \(String(describing: self.url))")
                } else {
                    NSLog("URL error!")
                    self.delegate?.NativeWebBridgeErrors?(URLError: urlString)
                }
            } else {
                NSLog("ERROR!! Please set self.url before viewDidAppear.")
            }
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let conf = WKWebViewConfiguration()
        conf.userContentController.add(self, name: "NativeWebBridge")
      
        self.wk = WKWebView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), configuration: conf)
        self.wk.uiDelegate = self
        self.wk.navigationDelegate = self
        self.wk.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.wk)
        self.view.sendSubviewToBack(self.wk)
        
        self.runPluginJS(names: ["Base"])
     //   Device.injectValuesInToRuntime(self.wk)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.wk, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.wk, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.wk, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.wk, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    
    

    
}


private typealias wkUIDelegate = NativeWebBridgeController

extension wkUIDelegate {
    
    public func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let ac = UIAlertController(title: webView.title, message: message, preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { (aa) -> Void in
            completionHandler()
        }))
        self.present(ac, animated: true, completion: nil)
    }
}


private typealias wkScriptMessageHandler = NativeWebBridgeController
extension wkScriptMessageHandler {
    
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        if message.name == "NativeWebBridge" {
//            if let dic = message.body as? NSDictionary,
//                let className = (dic["className"] as AnyObject).description,
//                let functionName = (dic["functionName"] as AnyObject).description {
//                if let cls = NSClassFromString((Bundle.main.object(forInfoDictionaryKey: "CFBundleName")! as AnyObject).description + "." + className) as? NativeWebBridgePlugin.Type{
//                    let obj = cls.init()
//                  //  obj.viewController = self
//                    obj.wk = self.wk
//                    obj.taskId = (dic["taskId"] as AnyObject).integerValue
//                    obj.data = (dic["data"] as AnyObject) as? NSDictionary
//                    let functionSelector = Selector(functionName)
//                    if obj.responds(to: functionSelector) {
//                        obj.perform(functionSelector)
//                    } else {
//                        print("Undefined function :\(functionName)")
//                    }
//                } else {
//                    print("Class Not Found: \(className)")
//                }
//            }
//        }
//    }
    
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == "NativeWebBridge") {
            if let dic = message.body as? NSDictionary, let className = (dic["className"] as AnyObject).description, let functionName = (dic["functionName"] as AnyObject).description {
                
                
                if className == "Console" {
                    let consoleObj = Console()
                    consoleObj.wk = self.wk
                    consoleObj.taskId = (dic["taskId"] as AnyObject).integerValue
                    consoleObj.data = (dic["data"] as AnyObject) as? NSDictionary
                    consoleObj.log()
                }
                
                if className == "Currencies" {
                    let accObj = Currencies()
                    accObj.wk = self.wk
                    accObj.taskId = (dic["taskId"] as AnyObject).integerValue
                    accObj.data = (dic["data"] as AnyObject) as? NSDictionary
                    accObj.fetchCurrencyLists()
                }
                
                
//                if let cls = NSClassFromString((Bundle.main.object(forInfoDictionaryKey: "CFBundleName")! as AnyObject).description + "." + className) as? NativeWebBridgePlugin.Type{
////                    let obj = cls.init()
////                    let functionSelector = Selector(functionName)
////                    NSLog(functionSelector.description)
////
////                    if obj.responds(to: functionSelector) {
////                        obj.wk = self.wk
////                        obj.taskId = (dic["taskId"] as AnyObject).integerValue
////                        obj.data = (dic["data"] as AnyObject) as? NSDictionary
////                        obj.perform(functionSelector)
////                    } else {
////                        let errorMessage = "Reflection Failure! Not found \(functionName) in \(className) Class"
////                        NSLog(errorMessage)
////                        self.delegate?.NativeWebBridgeErrors?(ReflectionEroor: self.url, className: functionName, functionName: functionName, message: errorMessage)
////                    }
//                } else {
//                    let errorMessage = "Reflection Failure! Class \(className) Not found"
//                    NSLog(errorMessage)
//                    self.delegate?.NativeWebBridgeErrors?(ReflectionEroor: self.url, className: className, functionName: functionName, message: errorMessage)
//                }
            } else {
                let errorMessage = "Reflection Failure! Data error: \(message.body)"
                NSLog(errorMessage)
                self.delegate?.NativeWebBridgeErrors?(ReflectionEroor: self.url, className: "", functionName: "", message: errorMessage)
            }
        }
    }
}


private typealias wkNavigationDelegate = NativeWebBridgeController
extension wkNavigationDelegate {
    
    public func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        NSLog(error.debugDescription)
    }
    public func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        NSLog(error.debugDescription)
    }
}

private typealias wkRunPluginDelegate = NativeWebBridgeController
extension wkRunPluginDelegate {
    
    public func runPluginJS(names: Array<String>) {
        for name in names {
            if let path = Bundle.main.path(forResource: name, ofType: "js",inDirectory: "www/plugins") {
                do {
                    let js = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
                    self.wk.evaluateJavaScript(js as String, completionHandler: nil)
                } catch let error as NSError {
                    print(error.debugDescription)
                }
            }
        }
    }
    
    
   
}
