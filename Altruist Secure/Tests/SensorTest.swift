//
//  SensorTest.swift
//  Altruist Secure
//
//  Created by Namrata Khanduri on 16/03/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import CoreMotion

class SensorTest {
    
    
    enum Sensor{
        case proximity
        case light
        case gravity
        case magnetic
    }
    
    var sensor: Sensor!
    private var motionManager: CMMotionManager! = CMMotionManager()
    
    init(test sensor : Sensor){
        self.sensor = sensor
    }
    //MARK: - PROXIMITY
    func isProximitySensorAvailable()->Bool{
        
        let device = UIDevice.current
        device.isProximityMonitoringEnabled = true
        return device.isProximityMonitoringEnabled
    }
    //MARK: - GRAVITY
    func isGravitySensorAvailable()->Bool{
        if motionManager.isAccelerometerAvailable{
            if motionManager.isGyroAvailable{
                return true
            }
        }
        return false
    }
    //MARK: - MAGNETIC
    func isMagneticSensorAvailable()->Bool{
        return motionManager.isMagnetometerAvailable
    }
}
