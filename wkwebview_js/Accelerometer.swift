//
//  Accelerometer.swift
//  BlackHawk
//
//  Created by leqicheng on 15/8/28.
//  Copyright © 2015年 乐其橙科技（北京）有限公司. All rights reserved.
//
import CoreMotion

class Accelerometer: NativeWebBridgePlugin {
    var motionManager: CMMotionManager!
    
    var isRunning = false
    
    // defaults to 10 msec
    let kAccelerometerInterval: TimeInterval = 10
    // g constant: -9.81 m/s^2
    let kGravitationalConstant = -9.81
    
    func getCurrentAcceleration() {
        if motionManager == nil {
            motionManager = CMMotionManager()
        }
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = self.kAccelerometerInterval / 1000
            motionManager.startAccelerometerUpdates(to: OperationQueue.main, withHandler: { (data, error) -> Void in
                let dic = NSMutableDictionary()
                dic["x"] = data!.acceleration.x * self.kGravitationalConstant
                dic["y"] = data!.acceleration.y * self.kGravitationalConstant
                dic["z"] = data!.acceleration.z * self.kGravitationalConstant
                dic["timestamp"] = NSDate().timeIntervalSince1970
                if self.callback(values: dic) {
                    self.motionManager.stopAccelerometerUpdates()
                }
            })
            if !self.isRunning {
                self.isRunning = true
            }
        } else {
            self.errorCallback(errorMessage: "accelerometer not available!")
        }
    }
}
