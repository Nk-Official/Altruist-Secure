//
//  ViewController.swift
//  Altruist Secure
//
//  Created by Namrata Khanduri on 13/03/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: -   IBACTION
    @IBAction func vibrateTest(_ sender: UIButton){// turn on vibration from iphone settings
        vibrateTest.startTest(self)
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
        bluetoothCheck.startTest(self)
    }
    //MARK: - VARIABLE
    
    let vibrateTest = VibrartionTest()
    let speakerTest = SpeakerTest()
    let headPhoneTest = HeadPhoneTest()
    let flashTest = FlashTest()
    let cameraTest = CameraTest()
    let bluetoothCheck = BluetoothCheck()

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
