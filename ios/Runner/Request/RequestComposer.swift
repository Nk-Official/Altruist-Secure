//
//  RequestComposer.swift
//  Networking
//
//  Created by user on 23/07/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import Foundation


class RequestComposer: RequestComposerProtocol{
    
    var encryptor: JSONEncryptor =  JSONEncryptor()

    func request(request: Request)
        throws ->URLRequest{
        
            let urlStr = request.url.baseurl + request.url.urlString
            let query = request.query
            let parameters = request.body
            let method = request.method
            let header = request.header
            
        guard let url = getUrl(urlStr: urlStr, queryItems: query) else{
            throw NetworkingError.invalidURL
        }
        var body: Data?
        if parameters != nil{
            do{
                body = try encryptor.convertToData(dict: parameters!)
            }catch{
                throw error
            }
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = body
        urlRequest.allHTTPHeaderFields = header
        
        return urlRequest
    }
    
    //MARK: - getUrl
    private func getUrl(urlStr: String,queryItems: [Query]?)->URL?{
        
        guard var urlComponent = URLComponents(string: urlStr) else{
            return URL(string: urlStr)
        }
        var queryParam = [URLQueryItem]()
        for query in queryItems ?? []{
            let item = URLQueryItem(name: query.key, value: query.value)
            queryParam.append(item)
        }
        urlComponent.queryItems = queryParam
        return urlComponent.url
    }
}
