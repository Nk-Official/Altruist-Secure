//
//  ChatTableViewCell.swift
//  Mustage
//
//  Created by Oleg Baidalka on 13/03/2017.
//  Copyright © 2017 Oleg Baidalka. All rights reserved.
//

import UIKit
import Firebase

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileView: UIImageView?
    @IBOutlet weak var contactName: UILabel?
    @IBOutlet weak var lastMessage: UILabel?
    
    var chatKey: UInt?    
    var chat: DatabaseReference? {
        willSet {
            // clear and stop listening changes
            if let value = chat, let key = chatKey {
                value.removeObserver(withHandle: key)
            }
        }
        didSet {
            // update cell and track for changes
            if let value = self.chat {
                chatKey = value.observe(.value, with: { (snap) in
                    // show the first contact
                    self.setupChat(snap)
                })
            }
        }
    }
    
    func setupChat(_ snap: DataSnapshot) {
        if let value = snap.values {
            self.contactName?.text = value["name"] as? String
            let placeholder = UIImage(named: "avatarPlaceholder")
            // profile picture
            if let image = value["profile"] as? String, let url = URL(string: image) {
                self.profileView?.sd_setImage(with: url, placeholderImage: placeholder)
            } else {
                self.profileView?.image = placeholder
            }
            
            
            
            if let unread = value["unread"] as? Int, unread > 0 {
                if let subtitle = self.lastMessage {
                    let bold = UIFont.boldSystemFont(ofSize: subtitle.font.pointSize)
                    let attrs = [NSAttributedStringKey.font: bold]
                    subtitle.attributedText = NSAttributedString(string: "\(unread) unread messages", attributes: attrs)
                }
            } else {
                // show last message
                Database.database().reference(withPath: kDataMessagesKey).child(snap.key)
                    .queryOrderedByKey()
                    .queryLimited(toLast: 1)
                    .observeSingleEvent(of: .value, with: { (data) in
                        let message = data.children.allObjects.first as? DataSnapshot
                        self.lastMessage?.text = message?.stringValue("message")
                    })
            }
        }
    }
    
}
