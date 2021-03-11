//
//  ServerBridge.swift
//  Runner
//
//  Created by user on 18/08/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
// 

import Foundation
class ServerBridge{
    
    let router = Router()
    
    func checkBarCodeIsScanned(param: QRCodeParam, callback: @escaping (Result<GlassTest,Error>)->()) -> URLSessionDataTask?{
        let api = DamageScreenApi(userId: param.userId, qrToken: param.qrCode)
        let request = Request(url: api, method: .get, body: nil, queryParam: ["jwtToken":param.userToken], header: nil)
        
        do {
            let task = try router.hitServer(reuest: request) { (result : Result<GlassTest,Error>) in
                callback(result)
            }
            return task
        }
        catch{
            callback(.failure(error))
        }
        return nil
    }
    
}
