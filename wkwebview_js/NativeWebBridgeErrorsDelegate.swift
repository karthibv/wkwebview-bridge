//
//  NativeWebBridgeErrorsDelegate.swift
//  wkwebview_js
//
//  Created by Karthik on 28/4/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import Foundation

@objc public protocol NativeWebBridgeErrorsDelegate : NSObjectProtocol {
    @objc optional func NativeWebBridgeErrors (URLError url : String)
    @objc optional func NativeWebBridgeErrors(ReflectionEroor url: String, className: String, functionName: String, message: String)

    
}
