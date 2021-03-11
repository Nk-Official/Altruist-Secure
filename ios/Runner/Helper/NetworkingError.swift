//
//  NetworkingError.swift
//  Networking
//
//  Created by user on 23/07/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import Foundation
public enum NetworkingError: Error {
    case invalidURL
    case unknownError
}

extension NetworkingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("URL is not valid", comment: "NetworkingError")
        case .unknownError:
            return NSLocalizedString("Unknown Server Error", comment: "NetworkingError")
        }
    }
}
