//
//  ContactTableViewCell.swift
//  Mustage
//
//  Created by Oleg Baidalka on 13/03/2017.
//  Copyright © 2017 Oleg Baidalka. All rights reserved.
//

import UIKit
import Firebase

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var profileView: UIImageView?
    @IBOutlet weak var contactName: UILabel?
    
    var handleKey: UInt?
    
    var userRef: DatabaseReference? {
        willSet {
            // clear and stop listening changes
            if let value = self.userRef, let key = handleKey {
                value.removeObserver(withHandle: key)
            }
            
            // stop loading previous image
            self.profileView?.sd_cancelCurrentImageLoad()
            self.profileView?.image = UIImage(named: kDefaultProfilePhoto)
            self.contactName?.text = nil
            self.contactName?.textColor = .black
        }
        didSet {
            // update cell and track for changes
            if let value = self.userRef {
                handleKey = value.ref.observe(.value, with: { (snap) in
                    self.setup(snap)
                })
            }
        }
    }
    
    deinit {
        self.userRef = nil
    }
    
    func setup(_ snap: DataSnapshot) {
        if let value = snap.values {
            
            // name
            self.contactName?.text = value["name"] as? String
            
            // profile picture
            if let image = value["profile"] as? String, let url = URL(string: image) {
                self.profileView?.sd_setImage(with: url)
            } else {
                self.profileView?.image = UIImage(named: kDefaultProfilePhoto)
            }
        }
    }
}
