//
//  Client.swift
//  Mustage
//
//  Created by Oleg Baidalka on 23/02/2018.
//  Copyright © 2018 Bossly. All rights reserved.
//

import UIKit

protocol Client {
    func setup() -> Self
}

protocol Analytica {
    
    // user properties
    func trackRemoteConfig(loaded: Bool)
    func trackAdmobLoading(appId: String)
    func trackCrashlogEnabled()
    
    // events
    func trackError(message: String)
    func trackOpenCamera()
}

struct Theme {
    static func setup() {
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = UIColor(red: 26/255, green: 188/255.0, blue: 185/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = .white

        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.strokeColor: UIColor.white,
        ], for: UIControlState.normal)
        
        UITabBar.appearance().barTintColor = .primary
        UITabBar.appearance().tintColor = .secondary
        UIButton.appearance().tintColor = .secondary
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func openUrl() {
        if let url = URL(string: self) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
