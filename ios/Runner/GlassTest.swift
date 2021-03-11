//
//  GlassTest.swift
//  Runner
//
//  Created by user on 18/08/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
class GlassTest: Codable{
    
    let statusDescription: Status?
    let deviceDetailsUploads: UploadDetail?

    
    enum CodingKeys: String, CodingKey{
        case statusDescription, deviceDetailsUploads
    }
    
}

class Status: Codable{
    let errorCode: Int?
    enum CodingKeys: String, CodingKey{
        case errorCode
    }
    
}
class UploadDetail: Codable{
    let status: String?
    enum CodingKeys: String, CodingKey{
        case status
    }
}
