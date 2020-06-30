//
//  FaceLockViewController.swift
//  Altruist Secure
//
//  Created by user on 19/05/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import UIKit
import LocalAuthentication

class FaceLockViewController: UIViewController {
    
    
    enum BioMetricSensor{
        case fingerprint
        case facelock
    }
    
    @IBOutlet weak var resultLabl: UILabel!
    @IBOutlet weak var resultStatusLabl: UILabel!

    var context = LAContext()
    @IBAction func facelockTest(_ sender: UIButton){
        checkBioMetricSensor(sensor: .facelock)
    }
    @IBAction func touchidTest(_ sender: UIButton){
        checkBioMetricSensor(sensor: .fingerprint)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    
    func start(){
        context.localizedCancelTitle = "Cancel"
        var error: NSError?
        
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
//            self.checkBiometicType()
            if error != nil{
                print(error?.localizedDescription)
                self.updateLbl(text: error?.localizedDescription, status: false)
            }else{

                let reason = "Face ID authentication"
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, error) in
                    if success{
                        if self.context.biometryType == .touchID{
                            print("authenticate with faceid success")
                            self.updateLbl(text: "authenticate with faceid success", status: true)
                        }else{
                            self.updateLbl(text:error?.localizedDescription ?? "authenticate with faceid not avaliable", status: false)
                        }
                    }else{
                        self.updateLbl(text: error?.localizedDescription, status: false)
                        print(error?.localizedDescription)
                    }
                }
            }
        }else{
            if error != nil{
                if error!.code == LAError.Code.biometryNotEnrolled.rawValue{
                    self.updateLbl(text: "biometryNotEnrolled", status: false)
                    return
                }
            }
            self.updateLbl(text: "deviceOwnerAuthenticationWithBiometrics not possible", status: false)
        }
        
    }
    
    func updateLbl(text:String?, status: Bool){
        DispatchQueue.main.async {
            self.resultLabl.text = text
            self.resultStatusLabl.text = String(describing: status)
        }
    }
    
    func checkBiometicType(){
     if #available(iOS 11.2, *) {
            if context.biometryType == .faceID{
                self.updateLbl(text: "biometric is faceid", status: true )
                
            }else  if context.biometryType == .touchID{
                self.updateLbl(text: "biometric is touchid", status: true)
                
                
            }
            else if context.biometryType == .none{
                self.updateLbl(text: "biometric is none", status: true)
            }
        } else {
            if context.biometryType == .faceID{
                self.updateLbl(text: "biometric is faceid", status: true)
                
            }else  if context.biometryType == .touchID{
                self.updateLbl(text: "biometric is touchid", status: true)
                
                
            }
            else {
                self.updateLbl(text: "biometric is none", status: true)
            }
        }
    }
    
    
    
    
    func checkBioMetricSensor(sensor: BioMetricSensor){
        
        
        var error:NSError?
        let authenticationContext: LAContext = LAContext()
        let testingSensor: LABiometryType = (sensor == .facelock) ? .faceID : .touchID
        
        if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
             
            let phnContainSensor = authenticationContext.biometryType
            if #available(iOS 11.2, *) {
                if phnContainSensor == .none{
                    print("no bionmetric available")
                    self.updateLbl(text: "no bionmetric available", status: false)
                    return
                }
            }
            if phnContainSensor == .LABiometryNone ||  phnContainSensor != testingSensor{
                print("testing bionmetric not available")
                self.updateLbl(text: "testing bionmetric not available", status: false)
                return
            }
            
            let reason = (sensor == .facelock) ? "Face ID authentication" : "Touch ID authentication"
            authenticationContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {[weak self] (success, error) in
                if success{
                    if authenticationContext.biometryType == testingSensor{
                        print("authenticate with biometric success")
                        self?.updateLbl(text: "authenticate with biometric success", status: true)
                    }else{
                        print(error?.localizedDescription ?? "authenticate with biometric not avaliable")
                        self?.updateLbl(text: error?.localizedDescription ?? "authenticate with biometric not avaliable", status: false)
                    }
                }else{
                    print(error?.localizedDescription)
                    self?.updateLbl(text: error?.localizedDescription, status: false)
                }
            }
            
        }
        else{
            print("biometric Evaluate Policy false")
            self.updateLbl(text: error?.localizedDescription ?? "biometric Evaluate Policy false", status: false)
        }
        
    }
}
