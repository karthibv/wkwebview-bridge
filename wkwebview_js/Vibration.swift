//
//  Vibration.swift
//  BlackHawkExample
//
//  Created by leqicheng on 15/8/30.
//  Copyright © 2015年 乐其橙科技（北京）有限公司. All rights reserved.
//

import AudioToolbox

class Vibration: NativeWebBridgePlugin {
    func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}

