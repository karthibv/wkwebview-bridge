//
//  NativeWebBridgePlugin.swift
//  wkwebview_js
//
//  Created by Karthik on 28/4/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import WebKit



import UIKit
import WebKit

class NativeWebBridgePlugin: NSObject {
    var viewController: WKWebView!
    var wk: WKWebView!
    var taskId: Int!
    var data: NSDictionary?
    required override init() {
    }
    func callback(values: NSDictionary) -> Bool {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: values, options: JSONSerialization.WritingOptions())
            if let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as String?,
                let tTaskId = self.taskId{
                let js = "fireTask(\(tTaskId), '\(jsonString)');"
                self.wk.evaluateJavaScript(js, completionHandler: nil)
                return true
            }
        } catch let error as NSError{
            NSLog(error.debugDescription)
            return false
        }
        return false
    }
    func errorCallback(errorMessage: String) {
        let js = "onError(\(String(describing: self.taskId)), '\(errorMessage)');"
        self.wk.evaluateJavaScript(js, completionHandler: nil)
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                print(text)
                print(data)
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print("JSON :" + error.localizedDescription)
            }
        }
        return nil
    }
    
}
