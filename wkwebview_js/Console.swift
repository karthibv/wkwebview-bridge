//
//  Console.swift
//  BlackHawk
//
//  Created by leqicheng on 15/8/28.
//  Copyright © 2015年 乐其橙科技（北京）有限公司. All rights reserved.
//
import Foundation

class Console: NativeWebBridgePlugin {
    required init() { // class must have an explicit required init()
        NSLog("Console init method >>> ")
    }
    func log() {
        if self.data != nil {
            NSLog("NativeWebBridgePlugin >>> ")
        }
    }
    
    func log(msg : String) {
        if msg != nil {
            NSLog(msg)
        }
    }
}
