//
//  VideoTrimmError.swift
//  Mustage
//
//  Created by user on 16/06/20.
//  Copyright © 2020 shuifeng.me. All rights reserved.
//

import Foundation
enum VideoTrimmError: LocalizedError {
    case failure
    case cancelled
}
extension VideoTrimmError{
    var errorDescription: String?{
        switch self{
        case .failure: return "Failed to export the video"
        case .cancelled: return "Cancelled export video"
        }
    }
}
