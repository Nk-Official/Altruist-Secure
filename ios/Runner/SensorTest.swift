//
//  SensorTest.swift
//  Runner
//
//  Created by user on 26/03/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

// https://www.quora.com/What-are-the-list-of-sensors-in-each-iPhone-iPad-version
//BAROMETER  https://www.devfright.com/how-to-access-the-iphone-barometer-with-cmaltimeter/
//COMPASS    https://medium.com/swiftly-swift/how-to-build-a-compass-app-in-swift-2b6647ae25e8
//touch id   https://codeburst.io/biometric-authentication-using-swift-bb2a1241f2be
//https://stackoverflow.com/questions/46887547/how-to-programmatically-check-support-of-face-id-and-touch-id
//https://the-nerd.be/2015/10/01/authentication-with-touchid/
//BATTERY https://stackoverflow.com/questions/27475506/check-battery-level-ios-swift
// https://www.quora.com/What-are-the-list-of-sensors-in-each-iPhone-iPad-version
//BAROMETER  https://www.devfright.com/how-to-access-the-iphone-barometer-with-cmaltimeter/
//COMPASS    https://medium.com/swiftly-swift/how-to-build-a-compass-app-in-swift-2b6647ae25e8
//touch id   https://codeburst.io/biometric-authentication-using-swift-bb2a1241f2be
//https://stackoverflow.com/questions/46887547/how-to-programmatically-check-support-of-face-id-and-touch-id
//https://the-nerd.be/2015/10/01/authentication-with-touchid/
//

import CoreMotion
import UIKit
import LocalAuthentication

class SensorTest: NSObject {
    
    typealias Closure = ((Bool)->())
    
    enum BioMetricSensor{
        case fingerprint
        case facelock
    }
    
    
    private var motionManager: CMMotionManager! = CMMotionManager()
    private var locationTest: LocationTest  = LocationTest()
    
    var barometerTestResult: Closure?
    var fingerPrintTestResult: Closure?
    var faceidTestResult: Closure?
    var locationTestResult: Closure?
    var biometricSensor: Closure?
    //MARK: - BATTERY TEST
    func checkBatteryLevel()->Int{
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = UIDevice.current.batteryLevel
        let batteryStatus = UIDevice.current.batteryState
        switch batteryStatus {
        case .charging: print("charging")
        case .full: print("full charged")
        case .unknown: print("unknown battery state")
        case .unplugged: print("unplugged battery state")
        @unknown default:
            break
        }
        UIDevice.current.isBatteryMonitoringEnabled = false
        return Int(batteryLevel * 100)
        
    }
    
    func executeLocationTest(){
        locationTest.testResult = locationTestResult
        locationTest.start()
    }
    
 //MARK: - BAROMETER TEST
    func checkBarometer(){
        
        let altimeter = CMAltimeter()
        
        if CMAltimeter.isRelativeAltitudeAvailable(){//we are checking if the device has a barometer. If it’s a 5s or older, this will return false, and we won’t need to start the updates.
            
            debugPrint("device have barometer")
            barometerTestResult?(true)
//            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main) { (data, error) in
//                if error != nil{
//                    debugPrint("error while getting barometer value",error!.localizedDescription)
//                }else{
//                    let relatedAltitude = String.init(format: "%.1fM", (data?.relativeAltitude.floatValue)!)
//                    let pressure = String.init(format: "%.2f hPA", (data?.pressure.floatValue)!*10)
//                    debugPrint("barometer output",relatedAltitude,pressure)
//                }
//            }
        }
        else{
            debugPrint("device doesnt have barometer")
            barometerTestResult?(false)
        }
        
    }
    
    //MARK: - GYROMETER
    func checkGyrometer()->Bool{

        return motionManager.isGyroAvailable
        
    }
    
    //MARK: - ACCELEROMETER
    
    func checkAccelerometer()->Bool{
        return motionManager.isAccelerometerAvailable
        
    }
    
    //MARK: - COMPASS
    
    func checkCompass()->Bool{
        
        return motionManager.isMagnetometerAvailable
        
    }
    
    //MARK: - PROXIMITY
    func isProximitySensorAvailable()->Bool{
        
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = true
        let proxy = device.isProximityMonitoringEnabled
        device.isProximityMonitoringEnabled = false
        return proxy
    }
    
    //MARK: - LIGHT SENSOR
    func checkLightSensor(){
        ///https://stackoverflow.com/questions/23162386/how-to-check-whether-the-auto-brightness-option-is-enabled-or-not-in-iphone-usin
        ///Apple's official public APIs do not allow an iOS app to access General settings in the Settings app. So it is not possible to change/ detect the toggle button inside the settings app.
        ///you could search for private API but then your app will be rejected by apple appstore as it is sandboxed. still if you create your app then you could upload it on Cydia (app store for jailbroken apple device)
        ///Apple does not expose any direct ambient light sensing API to developers,
        
        
    }
    ///https://developer.apple.com/documentation/localauthentication/logging_a_user_into_your_app_with_face_id_or_touch_id
    //MARK: -FINGERPRINT SENSOR
    func checkWhichBioMetricIsAvailable()->LABiometryType{
        
        var error:NSError?
        let authenticationContext: LAContext = LAContext()
        authenticationContext.localizedFallbackTitle = ""
        // 2. Check if the device has a fingerprint sensor
        // If not, show the user an alert view and bail out!
        authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if #available(iOS 11.0, *), authenticationContext.responds(to: #selector(getter: LAContext.biometryType)){
            return authenticationContext.biometryType
        }else{
            return authenticationContext.biometryType
        }
        
    }
    
   
    
    func checkBioMetricSensor(sensor: BioMetricSensor){
        
        
        
        switch checkWhichBioMetricIsAvailable(){
         case .faceID: print("faceID")
           case .touchID: print("touchid")
           default: print("none")
        }
        
        
        
        var error:NSError?
        let authenticationContext: LAContext = LAContext()
        authenticationContext.localizedFallbackTitle = ""
        let testingSensor: LABiometryType = (sensor == .facelock) ? .faceID : .touchID
        
        if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
             
            let phnContainSensor = authenticationContext.biometryType
            if #available(iOS 11.2, *) {
                if phnContainSensor == .none{
                    biometricSensor?(false)
                    return
                }
            }
            if phnContainSensor == .LABiometryNone || phnContainSensor != testingSensor{
                biometricSensor?(false)
                return
            }
            
            let reason = (sensor == .facelock) ? "Face ID authentication" : "Touch ID authentication"
            authenticationContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {[weak self] (success, error) in
                if success{
                    if authenticationContext.biometryType == testingSensor{
                        print("authenticate with biometric success")
                        self?.biometricSensor?(true)
                    }else{
                        self?.biometricSensor?(false)
                        print(error?.localizedDescription ?? "authenticate with biometric not avaliable")
                    }
                }else{
                    self?.biometricSensor?(false)
                    print(error?.localizedDescription)
                }
            }
            
        }
        else{
            if let laerror = error as? LAError{
                if laerror.code == .biometryNotEnrolled &&  authenticationContext.biometryType == testingSensor{
                    
                }
            }
            switch authenticationContext.biometryType{
            case .faceID: print("faceID")
            case .touchID: print("touchid")
            default: print("none")
            }
            biometricSensor?(false)
        }
        
    }

    
}

