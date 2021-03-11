//
//  Router.swift
//  Networking
//
//  Created by user on 23/07/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import Foundation
public class Router: RouterProtocol{
    
    
    var requestComposer: RequestComposerProtocol = RequestComposer()
    var encryptor = JSONEncryptor()
    var session = URLSession(configuration: .default)
    
    
    
    public func hitServer(reuest: Request, callback: @escaping (Result<Any,Error>)->() ) throws -> URLSessionDataTask{
        do{
            let request = try requestComposer.request(request: reuest)
            
            print("\n\n======")
            debugPrint("URL",request.url)
            debugPrint("Param",request.httpBody)
            debugPrint("Header",request.allHTTPHeaderFields)
            print("======\n\n")

            let task = connectToServer(request: request) { [weak self] (data, _, error) in
                self?.responseHandler(data: data, error: error, callback: { (result) in
                    callback(result)
                })
            }
            return task
        }catch{
            throw error
        }
    }
    public func hitServer<T:Codable>(reuest: Request, callback: @escaping (Result<T,Error>)->() ) throws -> URLSessionDataTask{
        do{
            let request = try requestComposer.request(request: reuest)
            
            print("\n\n======")
            debugPrint("URL",request.url)
            debugPrint("Param",request.httpBody)
            debugPrint("Header",request.allHTTPHeaderFields)
            print("======\n\n")

            let task = connectToServer(request: request) { [weak self] (data, _, error) in
                self?.responseHandler(data: data, error: error, callback: { [weak self] (result) in
                    switch result{
                    case .success( _):
                        do{
                            if let object: T  = try self?.encryptor.encodeToObject(data: data!){
                                callback(.success(object))
                                return
                            }
                            callback(.failure( NetworkingError.unknownError ))
                            return
                        }
                        catch{
                            callback(.failure(error))
                        }
                    case .failure(let error):
                        callback(.failure(error))
                    }
                })
            }
            return task
        }catch{
            throw error
        }
    }
    
    //MARK: - connectToServer
    private func connectToServer(request: URLRequest, callback: @escaping (Data?,URLResponse?,Error?)->() )->URLSessionDataTask{
        let task = session.dataTask(with: request) {  (data, response, error) in
            debugPrint("\n\n======")
            debugPrint("server response",response)
            debugPrint("======\n\n")

            callback(data,response,error)
        }
        task.resume()
        return task
    }
    
    //MARK: - handle server data
    private func responseHandler(data:Data?,error: Error?,callback: @escaping (Result<Any,Error>)->()){
        if error != nil{
             callback(.failure(error!))
             return
         }
         else if data != nil{
             do{
                let jsonData = try encryptor.convertToJSON(data: data!)
                 callback(.success(jsonData))
             }catch{
                 callback(.failure(error))
                 return
             }
         }else{
             callback(.failure(NetworkingError.unknownError))
             return
         }
        
    }
}
