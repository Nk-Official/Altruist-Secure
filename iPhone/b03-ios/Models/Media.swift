    //
//  Media.swift
//  Mustage
//
//  Created by user on 16/06/20.
//  Copyright © 2020 shuifeng.me. All rights reserved.
//

import UIKit
import MetalPetal

class Media {
    
    enum Mediatype{
        case image
        case video
        case none
    }
    
    private var image: UIImage?
    private var videoUrl: URL?
    private var mTImage: MTIImage?

    var uiimage: UIImage?{
        return image
    }
    
    var mtImage: MTIImage?{
        return mTImage
    }
    
    var videourl: URL?{
        return videoUrl
    }
    
    var mediaType: Mediatype{
        
        if image != nil{
            return .image
        }
        else if videoUrl != nil{
            return .video
        }
        return .none
        
    }
    
    init(image: UIImage, mtImage : MTIImage? = nil) {
        self.image = image
        self.mTImage = mtImage
    }
    
    init(videoUrl: URL) {
        self.videoUrl = videoUrl
    }
}
