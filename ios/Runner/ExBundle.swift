//
//  ExBundle.swift
//  Runner
//
//  Created by user on 16/04/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
extension Bundle {
    var displayName: String? {
        return infoDictionary?["CFBundleName"] as? String
    }
}
