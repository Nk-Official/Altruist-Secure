//
//  FaceLockTest.swift
//  Altruist Secure
//
//  Created by user on 19/05/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import LocalAuthentication

class FaceLockTest{
    
    
    var context = LAContext()

    func start(){
        context.localizedCancelTitle = "Cancel"
        var error: NSError?
        
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            if error != nil{
                print(error?.localizedDescription)
            }else{
                let reason = "Face ID authentication"
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, error) in
                    if success{
                        if self.context.biometryType == .faceID{
                            print("authenticate with faceid success")
                        }else{
                            print("authenticate with faceid fail")
                        }
                    }else{
                        print(error?.localizedDescription)
                    }
                }
            }
        }else{
            
        }
        
    }
    
}
