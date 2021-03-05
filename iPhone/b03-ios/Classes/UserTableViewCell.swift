//
//  UserTableViewCell.swift
//  Project
//
//  Created by Bossly on 10/15/16.
//  Copyright © 2016 Bossly. All rights reserved.
//

import UIKit
import Firebase

protocol UserTableViewCellDelegate {
    // required
    func didSelected(ref: DatabaseReference)
    func didAction(ref: DatabaseReference?, position: NSInteger)
    func replyToComment(comment: DataSnapshot?)
    func loadRepliesViewTap(comment: DataSnapshot?)
    func refreshViewHeight()
}

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var profileView: UIImageView?
    @IBOutlet weak var usernameView: UILabel?
    
    var delegate: UserTableViewCellDelegate?
    var linkedStoryRef: DatabaseReference?
    var cellIndex: NSInteger = -1
    var profileRecognizer: UIGestureRecognizer?
    
    private var handler: UInt?
    private var userCache: UserModel?
    
    var userRef: DatabaseReference? {
        willSet {
            resetCell()
            
            // unsubscribe
            if let _handler = handler {
                userRef?.removeObserver(withHandle: _handler)
            }
        }
        didSet {
            // subscribe
            handler = userRef?.observe(.value, with: { (snapshot) in
                let user = UserModel(snapshot)
                self.setupCell(user: user)
            })
        }
    }
    
    private func resetCell() {
        self.usernameView?.text = kDefaultUsername
        self.profileView?.image = #imageLiteral(resourceName: "avatarPlaceholder")
    }
    
    private func setupCell(user: UserModel) {
        self.userCache = user
        let placeholder = UIImage(named: "avatarPlaceholder")!
        
        // user name
        self.usernameView?.text = user.name
        
        // user profile photo
        self.profileView?.sd_cancelCurrentImageLoad()
        self.profileView?.sd_setImage(with: URL(string: user.photo), placeholderImage: placeholder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        resetCell()
        
        // setup onclick action
        profileRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDisplayProfile))
        self.addGestureRecognizer(profileRecognizer!)
        self.selectionStyle = .none
    }
    
    @objc func onDisplayProfile() {
        if let ref = self.userRef {
            self.delegate?.didSelected(ref: ref)
        }
    }

    @IBAction func actionButton(sender: Any) {
        
        if let ref = self.linkedStoryRef {
            self.delegate?.didAction(ref: ref, position: cellIndex)
        } else {
            // follow/unfollow user
            if let user = userCache {
                if user.isFollow {
                    user.unfollow()
                } else {
                    user.follow()
                }
            }
        }
    }
}
