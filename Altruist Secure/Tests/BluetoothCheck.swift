//
//  BluethoothCheck.swift
//  Altruist Secure
//
//  Created by Namrata Khanduri on 13/03/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import CoreBluetooth
class BluetoothCheck: NSObject, DeviceTester{
    
    //Right when the CentralManager is initialized, the centralManagerDidUpdateState(_central: CBCentralManager) delegate method is triggered to check the state of the Bluetooth connection.
    //If the bluetooth is turned off, CBCentralManager can’t be instantiated and the system will automatically throw a dialog prompt asking you to enable it.
    var bluetoothManager: CBCentralManager!
    var bluetoothTestSuccess: Closure?
   var bluetoothTestFail: Closure?

    
    func startTest(_ viewController: UIViewController) {
        bluetoothManager = CBCentralManager(delegate: self, queue: nil)
    }
    
}
 
extension BluetoothCheck: CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {//Scanning of devices is only possible when the state changes to poweredOn
        
        switch central.state{
        case .unsupported,.unknown:bluetoothTestFail?()
        default:bluetoothTestSuccess?()
        }
        
    }
    
}
