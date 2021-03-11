//
//  RequestComposerProtocol.swift
//  Networking
//
//  Created by user on 23/07/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import Foundation
protocol RequestComposerProtocol {
    var encryptor: JSONEncryptor {get set}
    func request(request: Request) throws ->URLRequest
}
