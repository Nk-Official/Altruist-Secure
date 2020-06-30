//
//  ViewController.swift
//  Altruist Secure
//
//  Created by Namrata Khanduri on 13/03/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
let locationTest = LocationTest()
    //MARK: -   IBACTION
    @IBAction func vibrateTest(_ sender: UIButton){// turn on vibration from iphone settings
//        vibrateTest.startTest(self)
        locationTest.testResult = {(result) in
            print("location test resut",result)
            
        }
        locationTest.start()
        
    }
    @IBAction func speakerTest(_ sender: UIButton){// turn on sounds from iphone settings
        speakerTest.startTest(self)
        sleep(3)
        do{
            let speakerok = try speakerTest.check(entered: 1)
            print("speaker is fine",speakerok)
        }
        catch{
            print("error while speaker test",error.localizedDescription)
        }
        
    }
    @IBAction func headphoneTest(_ sender: UIButton){// turn on sound from iphone settings
        setHeadPhoneTestCallbacks()
        headPhoneTest.startTest(self)        
    }
    @IBAction func flashTest(_ sender: UIButton){
        if flashTest.checkFlash(){
            print("flash is working fine")
        }
        else{
            print("flash not working")
        }
    }
    @IBAction func backCamTest(_ sender: UIButton){
        cameraTest.camera = .back
        if  cameraTest.checkCameraExist(){
            print("back camera exist")
        }else{
            print("back camera not exist")
        }
    }
    @IBAction func frontCamTest(_ sender: UIButton){
        cameraTest.camera = .front
        if  cameraTest.checkCameraExist(){
            print("front camera exist")
        }else{
            print("front camera not exist")
        }
    }
    @IBAction func bluetothTest(_ sender: UIButton){
        self.bluetoothCheck = BluetoothCheck()
        setBlueToothTestCallback()
        
    }
    @IBAction func proximityTest(_ sender: UIButton){
        let proximityAvailable = sensorTest.isProximitySensorAvailable()
        switch proximityAvailable {
        case true:
            print("have proximity")
        default:
            print("no proximity")
        }
    }
    @IBAction func lighSensorTest(_ sender: UIButton){
        
    }
    @IBAction func gravitySensorTest(_ sender: UIButton){
        let gravitySensorAvailable = sensorTest.isGravitySensorAvailable()
        switch gravitySensorAvailable {
        case true:
            print("have Gravity sensor")
        default:
            print("no Gravity sensor")
        }
    }
    @IBAction func magneticSensorTest(_ sender: UIButton){
        let magneticSensorAvailable = sensorTest.isMagneticSensorAvailable()
        switch magneticSensorAvailable {
        case true:
            print("have magnetic sensor")
        default:
            print("no magnetic sensor")
        }
    }
    @IBAction func displayTest(_ sender: UIButton){
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DisplayTestViewController")
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    @IBAction func simTest(_ sender: UIButton){
        let available = simTest.isSimAvailable()
        switch available {
        case true:print("sim is  available")
        case false:print("no sim found in iPhone")
        }
    }
    @IBAction func wifiTest(_ sender: UIButton){
        let wifiAvailable = wifiCheck.checkWifi()
        switch wifiAvailable {
        case true:print("wifi is connected")
        case false:print("wifi not connected to any network")
        }
    }
    @IBAction func facelockTest(_ sender: UIButton){
        facelockTest.start()
    }
    //MARK: - VARIABLE
    
    let vibrateTest = VibrartionTest()
    let speakerTest = SpeakerTest()
    let headPhoneTest = HeadPhoneTest()
    let flashTest = FlashTest()
    let cameraTest = CameraTest()
    var bluetoothCheck : BluetoothCheck!
    let sensorTest = SensorTest(test: .proximity)
    let simTest = SimTest()
    let wifiCheck = WifiCheck()
    let facelockTest = FaceLockTest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    func setHeadPhoneTestCallbacks(){
        headPhoneTest.headPhoneFoundCallback = {
            print("headphone Found")
        }
        headPhoneTest.headPhoneNotFoundCallback = {
           print("headphone not Found")
       }
    }
    func setBlueToothTestCallback(){
        bluetoothCheck.bluetoothTestSuccess = {
            print("have  bluetooth")
        }
        bluetoothCheck.bluetoothTestFail = {
            print("does not have  bluetooth")
        }
    }
}
