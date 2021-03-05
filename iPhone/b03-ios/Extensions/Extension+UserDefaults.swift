//
//  Extension.swift
//  DenNetwork
//
//  Created by Harish on 22/08/19.
//  Copyright © 2019 Harish. All rights reserved.
//

import Foundation

//MARK: Userdefaults
extension UserDefaults {
    
    var backgroundImage: String? {
        return string(forKey: "backgroundImage")
    }
    
    func setBackgroundImage(_ image: String) {
        set(image, forKey: "backgroundImage")
    }
    
    func clearAll() {
        let domain = Bundle.main.bundleIdentifier!
        removePersistentDomain(forName: domain)
        synchronize()
    }
}
