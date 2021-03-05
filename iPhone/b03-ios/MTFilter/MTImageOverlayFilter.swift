//
//  MTImageOverlayFilter.swift
//  Mustage
//
//  Created by xu.shuifeng on 2018/6/15.
//  Copyright © 2020 harish. All rights reserved.
//

import Foundation
import MetalPetal

class MTImageOverlayFilter: MTFilter {
    
    override var fragmentName: String {
        return "MTImageOverlayFilterFragment"
    }
    
    override func modifySamplersIfNeeded(_ samplers: [MTIImage]) -> [MTIImage] {
        return samplers
    }
}
