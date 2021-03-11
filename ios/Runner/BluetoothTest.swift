//
//  BluetoothTest.swift
//  Runner
//
//  Created by user on 08/04/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//BluetoothAvailabilityChangedNotification
//BluetoothConnectabilityChangedNotification
//BluetoothPowerChangedNotification

import UIKit
import CoreBluetooth

class BluetoothTest : NSObject{
    
    
    //Right when the CentralManager is initialized, the centralManagerDidUpdateState(_central: CBCentralManager) delegate method is triggered to check the state of the Bluetooth connection.
    //If the bluetooth is turned off, CBCentralManager can’t be instantiated and the system will automatically throw a dialog prompt asking you to enable it.
    
    var bluetoothManager: CBCentralManager!
    var bluetoothTestResult: ((Bool)->())?
    var bluetoothAvailable: Bool = false
    
    
    //MARK: - CONSTRUCTIR

    func startTest(){
        bluetoothManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey:NSNumber(false)])

        firstCheckBluetoothStatus { (bluetoothAvailable) in
            if bluetoothAvailable{
                print("blutooth avalable in first time check")
                self.setvalue(value: bluetoothAvailable)
            }else{
                print("blutooth not avalable in first time check")
            }
        }
    }
    
    func firstCheckBluetoothStatus(callback : (Bool)->()){
        print("first time check")
        switch bluetoothManager.state{
        case .poweredOff:
            callback(false)
        case .poweredOn:
            callback(true)
        case .unsupported:
            callback(false)
        case .unknown:
            callback(false)
        case .resetting:
            callback(true)
        case .unauthorized:
            callback(false)
        @unknown default:
            fatalError()
        }
    }
    
    func checkBluetoothConnected(callback : (Bool)->()){
        print("checkBluetoothConnected")
        switch bluetoothManager.state{
        case .poweredOff:
            callback(true)
        case .poweredOn:
            callback(true)
        case .unsupported:
            callback(false)
        case .unknown:
            callback(false)
        case .resetting:
            callback(true)
        case .unauthorized:
            callback(false)
        @unknown default:
            fatalError()
        }
    }
    func setvalue(value: Bool){
        bluetoothTestResult?(value)
        bluetoothTestResult = nil
        bluetoothManager.delegate = nil
    }
    
    func checkAuthorization(){
        
        if #available(iOS 13.0, *) {
            switch bluetoothManager.authorization{
            case .allowedAlways: print("allowedAlways")
            case .denied: print("denied")
            case .notDetermined: print("notDetermined")
            case .restricted: print("restricted")
            @unknown default:
                break
            }
        }
        
    }
    
}

//MARK: - CBCentralManagerDelegate
extension BluetoothTest : CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        checkBluetoothConnected { (bluetoothAvailable) in
            self.setvalue(value: bluetoothAvailable)
        }
        
    }
    
}
