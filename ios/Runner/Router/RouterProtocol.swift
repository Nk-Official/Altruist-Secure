//
//  RouterProtocol.swift
//  Networking
//
//  Created by user on 23/07/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import Foundation
protocol RouterProtocol {
    var session: URLSession{get set}
    var encryptor: JSONEncryptor {get set}
    var requestComposer: RequestComposerProtocol {get set}
    
    func hitServer(reuest: Request, callback: @escaping (Result<Any,Error>)->() ) throws ->URLSessionDataTask
    func hitServer<T:Codable>(reuest: Request, callback: @escaping (Result<T,Error>)->() ) throws ->URLSessionDataTask
    
}
