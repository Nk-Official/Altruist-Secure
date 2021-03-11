//
//  ExAppDelegate.swift
//  Runner
//
//  Created by user on 19/03/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit
extension AppDelegate {
    
    func runSimTest(completion: @escaping (Int)->()){
        let available =  self.simTest.isSimAvailable() ? 5 : 1
        completion(available)
    }
    func runWifiTest()->Bool{
        
        let wifiTest = WifiTest()
        let pass = wifiTest.checkInternetWorkingThroghWifi()
        return pass
        
    }
    
    //MARK: - SENSORS TEST
    func runBatteryTest()->Int{
        let batteryLevel = sensorTest.checkBatteryLevel()
        return batteryLevel
    }
    
    func runProximityTest()->Bool{
        return sensorTest.isProximitySensorAvailable()
    }
    
    func runGravityTest()->Bool{
        return sensorTest.checkGyrometer()
    }
    
    func runGPSTest()->Bool{
        return false
    }
    
    
    func runAccelerometerTest()->Bool{
        return sensorTest.checkAccelerometer()
    }
    func runCompassTest()->Bool{
        return sensorTest.checkCompass()
    }
    
    //MARK: - SPEAKER AND HEADPHONES
    
    func speakerTest(text : Int)  {
        let speakercheck = SpeakerTest(value: text)
        speakercheck.playSpeech()
    }
    
    
    
    //MARK: - PRESENT VIEWCONTROLLER
    func presentViewController(viewController: UIViewController){
        guard let rootViewController =  window.rootViewController else{
            return
        }
        viewController.modalPresentationStyle = .fullScreen
        rootViewController.present(viewController, animated: true, completion: nil)

    }
}
