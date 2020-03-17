//
//  VibrartionTest.swift
//  Altruist Secure
//
//  Created by Namrata Khanduri on 13/03/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import AudioToolbox.AudioServices
import AVKit

class VibrartionTest: DeviceTester {
    
    
    init() {
        AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, nil, nil, { (_, _) in
            print("iPhone just vibrated")
        }, nil)
    }
    
    
    func startTest(_ viewController: UIViewController) {
        vibrateDevice()
    }
    private func vibrateDevice(){
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        
//        AudioServicesCreateSystemSoundID(kSystemSoundID_Vibrate, UnsafeMutablePointer<SystemSoundID>(kSystemSoundID_Vibrate))
    }
    deinit {
        AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)
    }
}
