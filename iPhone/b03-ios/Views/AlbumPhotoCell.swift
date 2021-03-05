//
//  AlbumPhotoCell.swift
//  Mustage
//
//  Created by harish on 2020/6/17.
//  Copyright © 2020 harish. All rights reserved.
//

import UIKit

class AlbumPhotoCell: UICollectionViewCell {
    
    let imageView: UIImageView
    let playImageView: UIImageView

    let selectedImage: UIImageView
    var assetIdentifier: String = ""
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? UIColor(white: 1, alpha: 0.7): .clear
            selectedImage.image = isSelected ? UIImage(named: "CircleFilledTick") : UIImage(named: "Circlehollow")
        }
    }
    
    override init(frame: CGRect) {
        
        imageView = UIImageView(frame: CGRect(origin: .zero, size: frame.size))
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFill
        
        let frame = CGRect(x: frame.width-20-5, y: 5, width: 20, height: 20)
        selectedImage = UIImageView(frame: frame)
        selectedImage.contentMode = .scaleAspectFit
        
        playImageView = UIImageView(image: UIImage(named: "yp_play")  )

        super.init(frame: frame)

        backgroundView = imageView
        addSubview(selectedImage)
        addSubview(playImageView)
        
        clipsToBounds = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        playImageView.frame = CGRect(origin: CGPoint(x: (frame.width/2)-10, y: (frame.height/2)-10), size: CGSize(width: 20, height: 20))

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        selectedImage.image = nil
    }
}
