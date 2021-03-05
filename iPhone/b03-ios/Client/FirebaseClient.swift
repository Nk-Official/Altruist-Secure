//
//  FirebaseClient.swift
//  Mustage
//
//  Created by Oleg Baidalka on 28/02/2018.
//  Copyright © 2018 Bossly. All rights reserved.
//

import Foundation

import Firebase
import FirebaseRemoteConfig
import SDWebImage

class FirebaseClient: Client {

    func setup() -> Self {
        
        // load configs
        FirebaseApp.configure()
        
        // enable notification in application
        setupNotification()
        
        // enable ads
        if kAdMobEnabled {
            GADMobileAds.sharedInstance().start(completionHandler: nil)
            trackAdmobLoading(appId: kAdMobApplicationID)
        }
        
        return self
    }
}

extension FirebaseClient: Analytica {

    // MARK: - User properties
    func trackAdmobLoading(appId: String) {
        Analytics.setUserProperty(appId, forName: "admob_enabled")
    }
    func trackRemoteConfig(loaded: Bool) {
        Analytics.setUserProperty(String(loaded), forName: "remote_config_loading")
    }
    func trackCrashlogEnabled() {
        Analytics.setUserProperty(String(true), forName: "crashlog_enabled")
    }

    // MARK: - Events
    func trackOpenCamera() {
        Analytics.logEvent("camera_opened", parameters: nil)
    }
    func trackError(message: String) {
        Analytics.logEvent("Error", parameters: [AnalyticsParameterValue: message])
    }
}

extension FirebaseClient: NotificationClient { }

extension FirebaseClient: AuthClient {
    
    func saveUser(userId: String, name: String, photo: String, override: Bool = true) {
        
        let ref = Database.database().reference().child(kUsersKey).child(userId)

        if override {
            ref.updateChildValues(["name": name, "photo": photo])
        } else {
            // check if data exist
            ref.observeSingleEvent(of: .value, with: { (data) in
                if data.exists(), let values = data.value as? [String: String] {
                    let newname = values["name"] ?? name
                    let newphoto = values["photo"] ?? photo
                    
                    ref.updateChildValues(["name": newname, "photo": newphoto])
                }
            })
        }
    }
}
