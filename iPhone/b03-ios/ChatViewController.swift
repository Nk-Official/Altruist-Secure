//
//  ChatContainerViewController.swift
//  Mustage
//
//  Created by Oleg Baidalka on 14/03/2017.
//  Copyright © 2017 Oleg Baidalka. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleMobileAds
import FirebaseMessaging

class ChatViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var keyboardConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView?
    @IBOutlet weak var bannerView: GADBannerView?

    var messagesViewController: MessagesViewController?
    
    var chatRef: DatabaseReference? {
        didSet {
            showTitle()
            showMessages()
            
            // reset unread count
            chatRef?.child("unread").setValue(0)
        }
    }
    var contactRef: DatabaseReference? {
        didSet {
            if let contact = contactRef, let key = contact.key {
                self.openChat(contact)

                // subscribe for notification from that user
                print("subscribe to: chat\(key)")
                Messaging.messaging().subscribe(toTopic: "\(kTopicFeed)\(key)")
            }
        }
    }
    
    override func viewDidLoad() {
        if kAdMobEnabled {
            print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
            
            if let bannerView = self.bannerView {
                bannerView.adUnitID = kAdBanner
                bannerView.rootViewController = self
                
                let request = GADRequest()
                bannerView.load(request)
            }
        } else {
            self.bannerHeightConstraint.constant = 0
            self.view.updateConstraints()
        }
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print(bannerView.debugDescription)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // subscribe for Keyboard move
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keyboardWillShow),
                       name: .UIKeyboardWillChangeFrame, object: nil)
        nc.addObserver(self, selector: #selector(keyboardWillHide),
                       name: .UIKeyboardWillHide, object: nil)

        // pause table animations
        Settings.tableViewAnimation = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // show keyboard
        self.textView?.becomeFirstResponder()
        // clear all unread messages
        self.chatRef?.child("unread").removeValue()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // unsubscribe for Keyboard move
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: .UIKeyboardWillChangeFrame, object: nil)
        nc.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        self.keyboardConstraint.constant = notification.keyboardEndFrame().height

        UIView.animate(withDuration: notification.keyboardDuration(), animations: {
            self.view.layoutSubviews()
            
            // resume table animations
            Settings.tableViewAnimation = .automatic
        })
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.keyboardConstraint.constant = 0
        
        UIView.animate(withDuration: notification.keyboardDuration(), animations: {
            self.view.layoutSubviews()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? MessagesViewController {
            // should be as Embded controller (but could be other way)
            self.messagesViewController = controller
            showMessages()
        }
    }
    
    // MARK: - public
    func showTitle() {
        if let ref = self.chatRef {
            ref.observeSingleEvent(of: .value, with: { (data) in
                self.title = data.stringValue("name")
                
                // subscribe for notification from that user
                if let contact = data.stringValue("contact") {
                    print("subscribe to: chat\(contact)")
                    Messaging.messaging().subscribe(toTopic: "\(kTopicFeed)\(contact)")
                }
            })
        } else {
            self.title = ""
        }
    }
    
    func showMessages() {
        // keep sync
        if let chatKey = self.chatRef?.key {
            self.messagesViewController?.messagesRef = Database.database()
                .reference(withPath: kDataMessagesKey).child(chatKey)            
        } else {
            self.messagesViewController?.messagesRef = nil
        }
    }
    
    func openChat(_ contact: DatabaseReference) {
        guard let user = Auth.auth().currentUser, let key = contact.key else {
            return
        }

        if user.uid == contact.key {
            return
        }
        
        // check if chat is exist
        let chatRef = Database.database().reference(withPath: kDataChatsKey)
        chatRef.child(user.uid).queryOrdered(byChild: "contact").queryEqual(toValue: contact.key)
            .observeSingleEvent(of: .value, with: { (snap) in
                if snap.hasChildren() {
                    print("Used chat: \(chatRef.ref)")
                    let child = snap.children.nextObject() as? DataSnapshot
                    self.chatRef = child?.ref
                } else {
                    contact.observeSingleEvent(of: .value, with: { (data) in
                        self.title = data.values?["name"] as? String ?? ""
                    })
                }
        })
        
        UserModel(key).fetchInBackground { (umodel, uloaded) in
            if let user = umodel as? UserModel, user.blockedMe() {
                self.showBlockedMessage()
            }
        }
    }
    
    func showBlockedMessage() {
        let alert = UIAlertController(title: "blocked".localized, message: "blocked.message".localized, preferredStyle: .alert)
        let action = UIAlertAction(title: "dismiss".localized, style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func createChat(_ contact: DatabaseReference, callback: @escaping (DatabaseReference?) -> Void) {
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        if user.uid == contact.key {
            return
        }
        
        // check if chat is exist
        let chatRef = Database.database().reference(withPath: kDataChatsKey)
        chatRef.child(user.uid).queryOrdered(byChild: "contact").queryEqual(toValue: contact.key)
            .observeSingleEvent(of: .value, with: { (snap) in
                if snap.hasChildren() {
                    print("Used chat: \(chatRef.ref)")
                    let child = snap.children.nextObject() as? DataSnapshot
                    callback(child?.ref)
                    self.chatRef = child?.ref
                } else {
                    print("New chat created: \(chatRef.ref)")
                    // Create new chat
                    contact.observeSingleEvent(of: .value, with: { (data) in
                        if let contactData = data.value as? [String: Any] {
                            // add new chat
                            let chat = chatRef.child(user.uid).childByAutoId()
                            
                            guard let chatKey = chat.key, let contactKey = contact.key
                                else { return }
                            
                            // create group with name and contacts collection
                            let values = [
                                "name": contactData["name"] ?? "",
                                "profile": contactData["photo"] ?? "",
                                "contact": contactKey,
                            ]
                            
                            // current user chat
                            chat.updateChildValues(values, withCompletionBlock: { (error, ref) in
                                callback(ref)
                                self.chatRef = ref
                            })
                            
                            UserModel.collection.child(user.uid).observeSingleEvent(of: .value, with: { (userdata) in
                                var username = user.displayName ?? chatKey
                                var photo = ""
                                
                                if let map = userdata.value as? [String: Any] {
                                    username = map["name"] as? String ?? username
                                    photo = map["photo"] as? String ?? ""
                                }
                                
                                // create recent for other participant
                                chatRef.child(contactKey).child(chatKey).updateChildValues([
                                    "name": username,
                                    "profile": photo,
                                    "contact": user.uid, ])
                            })
                        }
                    })
                }
            })
    }
    
    func sendMessage(chat: DatabaseReference, message: String) {
        if let user = Auth.auth().currentUser?.uid, let chatKey = chat.key {
            let messageRef = Database.database().reference(withPath: kDataMessagesKey)
                .child(chatKey).childByAutoId()
            
            let value: [String: Any] = [
                "message": message,
                "user_id": user,
            ]
            messageRef.updateChildValues(value)
        }
        
        self.textView?.text = nil // set it nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // 0.3 sec later
            self.messagesViewController?.tableView.scrollBottom(true)
        }
    }
}

extension ChatViewController {
    @IBAction func onSendMessage() {
        if let message = self.textView?.text?.trimmingCharacters(in: .whitespacesAndNewlines), !message.isEmpty {
            // create chat if not created
            if let chat = self.chatRef {
                self.sendMessage(chat: chat, message: message)
            } else if let contact = self.contactRef {
                self.createChat(contact, callback: { (chatref) in
                    if let chat = chatref {
                        self.sendMessage(chat: chat, message: message)
                    }
                })
            }
            
        }
    }
}
