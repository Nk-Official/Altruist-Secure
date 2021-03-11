//
//  JSONEncryptor.swift
//  Networking
//
//  Created by user on 23/07/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import Foundation

class JSONEncryptor{
    
    func convertToData(dict: Any) throws -> Data{
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            return jsonData
        } catch {
            throw error
        }
    }
    
    func convertToJSON(data: Data)throws -> Any{
        do {
            let decoded = try JSONSerialization.jsonObject(with: data, options: [])
            return decoded
        } catch {
            throw error
        }
    }
    
    func encodeToObject<T: Codable>(data: Data) throws -> T{
        do{
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        }
        catch{
            throw error
        }
        
    }
    
}
