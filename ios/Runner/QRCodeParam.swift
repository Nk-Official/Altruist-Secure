//
//  QRCodeParam.swift
//  Runner
//
//  Created by user on 18/08/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
class QRCodeParam: Codable{
    
    let qrCode: String
    let userId: String
//    let user_name: Int
    let userToken: String
    
    enum CodingKeys: String, CodingKey{
        case qrCode = "qr_token"
        case userId = "user_id"
        case userToken = "user_token"
    }
    
}
