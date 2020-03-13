//
//  Error.swift
//  Altruist Secure
//
//  Created by Namrata Khanduri on 13/03/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import Foundation
enum CustomError : LocalizedError{
    
    
    case customerror(String)
    
    var errorDescription: String?{
        switch self {
        
        case .customerror(let msg):
            return msg
        }
    }
}
