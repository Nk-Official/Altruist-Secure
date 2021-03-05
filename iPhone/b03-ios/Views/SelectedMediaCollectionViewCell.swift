//
//  SelectedMediaCollectionViewCell.swift
//  Mustage
//
//  Created by user on 16/06/20.
//  Copyright © 2020 shuifeng.me. All rights reserved.
//

import UIKit

class SelectedMediaCollectionViewCell: UICollectionViewCell{
    
    var imageView: UIImageView
    var cancelBtn: UIButton
    var cancelBtnAction: ((SelectedMediaCollectionViewCell)->())?
    var assetIdentifier: String = ""
    var playImageView: UIImageView

    override init(frame: CGRect) {
        imageView = UIImageView(frame: CGRect(origin: .zero, size: frame.size))
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        
        let frame = CGRect(x: frame.width-40-5, y: 5, width: 40, height: 40)
        cancelBtn = UIButton(frame: frame)
        cancelBtn.setImage(UIImage(named: "yp_remove") , for: .normal)
        
        playImageView = UIImageView(image: UIImage(named: "yp_play"))
        super.init(frame: frame)
        
        backgroundView = imageView
        addSubview(cancelBtn)
        cancelBtn.addTarget(self, action: #selector(cancel) , for: .touchUpInside)

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let playframe = CGRect(origin: CGPoint(x: frame.width/2-10, y: frame.height/2-10) , size: CGSize(width: 20, height: 20) )
        playImageView.frame = playframe
        
    }
    
    @objc func cancel(_ sender: UIButton){
        cancelBtnAction?(self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setImage(image: UIImage?){
        imageView.image = image
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
