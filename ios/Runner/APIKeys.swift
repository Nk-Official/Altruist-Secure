//
//  APIKeys.swift
//  Runner
//
//  Created by user on 18/08/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation

#if NoonSecure
    var BASEURL = "https://api1.altruistsecure.com/"
#elseif AltruistSecure
    var BASEURL = "https://api1.altruistsecure.com/"
#elseif AltruistSecureR3
    var BASEURL = "https://api1.altruistsecure.com/"
#else
    var BASEURL = "https://api1.altruistsecure.com/"
#endif


struct DamageScreenApi:API{
    var baseurl: String{
        return BASEURL
    }
    
    var urlString: String{
        return createURLStr()
    }
    var userId:String
    var qrToken: String
    let source = "2" // for ios source is 2
    
    init(userId: String, qrToken: String) {
        self.userId = userId
        self.qrToken = qrToken
    }
    
    func createURLStr()->String{
        var str = "api/statusinfo/v1/damagedscreenstatus/"
        str.append("\(userId)/")
        str.append("source/\(source)/")
        str.append("qrcodetoken/\(qrToken)/")
        return str
    }
}

