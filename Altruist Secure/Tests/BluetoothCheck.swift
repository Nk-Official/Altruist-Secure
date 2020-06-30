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
    override init() {
        bluetoothManager = CBCentralManager()
        super.init()
        bluetoothManager.delegate = self
    }
    
    func startTest(_ viewController: UIViewController) {
        
    }
    
}
 
extension BluetoothCheck: CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {//Scanning of devices is only possible when the state changes to poweredOn
        
        switch central.state{
        case .unsupported,.unknown:bluetoothTestFail?()
        default:bluetoothTestSuccess?()
        }
        let options = [
            CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(value: false)
        ]
        
        let batteryServiceCBUUID = CBUUID(string: "0x183B")

        bluetoothManager.scanForPeripherals(withServices: [batteryServiceCBUUID], options: nil)

    }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print(peripheral)
        central.connect(peripheral, options: nil)
        let batteryServiceCBUUID = CBUUID(string: "0x183B")
//        peripheral.discoverServices(batteryServiceCBUUID)
    }
    
}
