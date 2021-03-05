//
//  MessageTableViewCell.swift
//  Mustage
//
//  Created by Oleg Baidalka on 15/03/2017.
//  Copyright © 2017 Oleg Baidalka. All rights reserved.
//

import UIKit
import Firebase

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageView: UITextView?
    @IBOutlet weak var profileView: ProfileView?
    @IBOutlet weak var timeView: UILabel?

    var profileKey: UInt?
    var ref: DatabaseQuery?

    func showMessage(_ snap: DataSnapshot) {
        if let value = snap.values {
            self.messageView?.text = value["message"] as? String
            
            if let time = value["created"] as? TimeInterval {
                self.timeView?.text = Date(timeIntervalSince1970: time/1000).timeAgoSinceNow
            } else {
                self.timeView?.text = nil
            }

            self.messageView?.setNeedsUpdateConstraints()
            
            if let key = self.profileKey {
                self.ref?.removeObserver(withHandle: key)
            }

            if let userid = value["user_id"] as? String {
                self.ref = UserModel(userid).ref
                self.profileKey = ref?.observe(.value, with: { (data) in
                    // profile picture
                    if let image = data.stringValue("photo"), let url = URL(string: image) {
                        self.profileView?.sd_setImage(with: url)
                    } else {
                        self.profileView?.image = UIImage(named: kDefaultProfilePhoto)
                    }
                })
            }
            
            self.setNeedsUpdateConstraints()
        }
    }
    
}
