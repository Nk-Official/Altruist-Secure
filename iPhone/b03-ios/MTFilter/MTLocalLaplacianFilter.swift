//
//  MTLocalLaplacianFilter.swift
//  Mustage
//
//  Created by xu.shuifeng on 2018/6/13.
//  Copyright © 2020 harish. All rights reserved.
//

import Foundation

class MTLocalLaplacianFilter: MTFilter {
    
    var filterStrength: Float = 0
    
    override var fragmentName: String {
        return "MTLocalLaplacianFilterFragment"
    }
    
    override var samplers: [String : String] {
        return [:]
    }
    
    override var parameters: [String: Any] {
        return [ "filterStrength" : filterStrength]
    }
}
