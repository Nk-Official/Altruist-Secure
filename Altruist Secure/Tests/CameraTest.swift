//
//  CameraTester.swift
//  Altruist Secure
//
//  Created by Namrata Khanduri on 13/03/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import AVFoundation
class CameraTest {
    enum Camera{
        case back
        case front
    }
    
    var camera: Camera = .back
    
    func checkCameraExist()->Bool{
        let position: AVCaptureDevice.Position = (camera == .back ? .back : .front)
        let device = AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera
        ], mediaType: .video, position: position)
        let devices = device.devices
        
        return !devices.isEmpty
    }
    
}
