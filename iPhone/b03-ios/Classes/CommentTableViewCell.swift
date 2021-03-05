//
//  CommentTableViewCell.swift
//  b03-ios
//
//  Created by Bossly on 9/11/16.
//  Copyright © 2016 Bossly. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileView: UIImageView?
    @IBOutlet weak var textView: UITextView? {
        didSet {
            textView?.textContainerInset = .zero
            textView?.contentInset = .zero
        }
    }
    @IBOutlet weak var timeView: UILabel?
    
    var delegate: UserTableViewCellDelegate?
    fileprivate var user: UserModel?
    fileprivate var commentRef: DatabaseReference?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.textView?.textContainerInset = UIEdgeInsets.zero
        
        if let profile = self.profileView {
            profile.sd_imageIndicator = SDWebImageActivityIndicator.gray

            // setup onclick action
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(onDisplayProfile))
            self.textView?.addGestureRecognizer(recognizer)
            self.profileView?.addGestureRecognizer(recognizer)
        }
    }
    
    @objc func onDisplayProfile() {
        if let ref = commentRef {
            self.delegate?.didSelected(ref: ref)
        }
    }
    
    func displayComment(_ comment: DataSnapshot) {
        self.commentRef = comment.ref
        
        if let value = comment.value as? [String: Any] {
            
            if let userid = value["profile_id"] as? String {
                user = UserModel(userid)
            }
            
            let text = NSMutableAttributedString()
            let placeholder = UIImage(named: "avatarPlaceholder")
            
            if let profile = value["profile_name"] as? String {
                let attrs = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: kCommentFontSize)]
                text.append(NSAttributedString(string: "\(profile) ", attributes: attrs))
            }
            
            if let message = value["message"] as? String {
                let attrs = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: kCommentFontSize)]
                text.append(NSAttributedString(string: message, attributes: attrs))
            }
            
            if let time = value["created"] as? TimeInterval {
                self.timeView?.text = Date(timeIntervalSince1970: time/1000).shortTimeAgoSinceNow
            } else {
                self.timeView?.text = nil
            }
            
            if let profileImage = value["profile_image"] as? String, let photoUrl = URL(string: profileImage) {
                self.profileView?.sd_setImage(with: photoUrl, placeholderImage: placeholder, options: [], completed: { (image, error, type, url) in
                    DispatchQueue.main.async(execute: {
                        self.layoutSubviews()
                    })
                })
            } else {
                self.profileView?.image = placeholder
                DispatchQueue.main.async(execute: {
                    self.layoutSubviews()
                })
            }
            
            self.textView?.attributedText = text
            self.updateConstraints()
        } else {
            // error
            self.profileView?.image = nil
            self.textView?.attributedText = nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let profile = self.profileView {
            profile.layer.cornerRadius = profile.frame.width/2
        }
        
    }
    
}
