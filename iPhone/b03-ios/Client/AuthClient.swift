//
//  AuthClient.swift
//  Mustage
//
//  Created by Oleg Baidalka on 09/03/2018.
//  Copyright © 2018 Bossly. All rights reserved.
//

import Foundation
import Firebase
import FirebaseUI

protocol AuthClient {
    func saveUser(userId: String, name: String, photo: String, override: Bool)
}

// extent application to handle authorisation url
extension AppDelegate {
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        
        // other URL handling goes here.
        return false
    }
    
    func application(_ application: UIApplication,
                     open url: URL,
                     sourceApplication: String?,
                     annotation: Any) -> Bool {
        return FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication ?? "") ?? false
    }
}
