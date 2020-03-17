//
//  FlashTest.swift
//  Altruist Secure
//
//  Created by Namrata Khanduri on 13/03/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import AVFoundation

class FlashTest : DeviceTester{
    
    private var avDevice = AVCaptureDevice.default(for: .video)
    
    func startTest(_ viewController: UIViewController) {
        
    }
    
    
    func checkFlash()->Bool{
        guard let device = avDevice else{return false}
        if !device.hasTorch{return false}
        if device.isTorchAvailable {
            do {
                _ = try device.lockForConfiguration()
                device.torchMode = .on
                if  device.torchMode == .on{
                    device.torchMode = .off
                    device.unlockForConfiguration()
                    return true
                }
                device.unlockForConfiguration()
                return false
            } catch {
                print("error while flash test",error.localizedDescription)
            }
        }
        return true
    }
    
}
