//
//  CommentsTableViewController.swift
//  b03-ios
//
//  Created by Bossly on 9/11/16.
//  Copyright © 2016 Bossly. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class CommentsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UserTableViewCellDelegate {
    
    
    var comments: NSMutableArray! = nil
    var storyId: String! = ""
    
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var replytoUserLbl: UILabel!
    @IBOutlet weak var keyboardConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentText: UITextView! {
        didSet {
            commentText.layer.cornerRadius = commentText.frame.height/2
            commentText.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    var replieToCommentID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replyView.isHidden = true
        self.comments = NSMutableArray()
        let query = Comment.collection.child(self.storyId).queryOrderedByKey()

        // Listen for new posts in the Firebase database
        query.observe(.childAdded, with: { (snapshot) -> Void in
            DispatchQueue.main.async(execute: {
                self.comments.add(snapshot)
                let lastIndex = IndexPath(row: self.comments.count-1, section: 0)
                self.tableView.insertRows(at: [lastIndex], with: .bottom)
                self.tableView.scrollToRow(at: lastIndex, at: .bottom, animated: false)
            })
        })
        
        query.observe(.childRemoved) { (snapshot) in
            DispatchQueue.main.async(execute: {
                
                let index = self.comments.indexOfObject(passingTest: { (obj, idx, stop) -> Bool in
                    if let data = obj as? DataSnapshot, data.key.elementsEqual(snapshot.key) {
                        return true
                    }
                    return false
                })
                
                self.comments.removeObject(at: index)
                let lastIndex = IndexPath(row: index, section: 0)
                self.tableView.deleteRows(at: [lastIndex], with: .automatic)
            })
        }
        
        self.tableView.estimatedRowHeight = 250
        self.tableView.rowHeight = UITableViewAutomaticDimension

        NotificationCenter.default
            .addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

//        let backgroundImage = UIImageView()
//        backgroundImage.frame = self.tableView.frame
//        backgroundImage.backgroundColor = .groupTableViewBackground
//        backgroundImage.contentMode = .scaleToFill
//        if let url : URL = URL(string: UserDefaults.standard.backgroundImage ?? "")
//        {
//            backgroundImage.sd_setImage(with: url)
//        }
//        self.tableView.backgroundView = backgroundImage
        
        loadPostOwner()
    }
    
    func loadPostOwner() {
        Story(storyId).fetchInBackground { (smodel, sloaded) in
            if let story = smodel as? Story {
                UserModel(story.userId).fetchInBackground { (umodel, uloaded) in
                    if let user = umodel as? UserModel, user.blockedMe() {
                        self.showBlockedMessage()
                    }
                }
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

    override func viewWillAppear(_ animated: Bool) {
        self.commentText.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let profileCtrl = segue.destination as? ProfileViewController {
            if let user = sender as? DatabaseReference, let key = user.ref.key {
                profileCtrl.currentUser = UserModel(key)
            }
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let rect: CGRect = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        let duration = ((notification as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue
        let newHeight: CGFloat
        
        if #available(iOS 11.0, *) {
            newHeight = view.safeAreaInsets.bottom - rect.height
        } else {
            newHeight = -rect.height
        }
        self.keyboardConstraint.constant = newHeight
        if replieToCommentID != nil{
//            replyViewBottomConstraint.constant = (newHeight - commentText.frame.height)
        }
        
        UIView.animate(withDuration: duration!, animations: { 
            self.view.layoutSubviews()
        }) 
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let duration = ((notification as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue
        self.keyboardConstraint.constant = 0
        self.replieToCommentID = nil
        replyView.isHidden = true
        UIView.animate(withDuration: duration!, animations: {
            self.view.layoutSubviews()
        }) 
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkPreviewTableViewCell", for: indexPath) as? LinkPreviewTableViewCell

        // Configure the cell...
        if let comment = self.comments.object(at: (indexPath as NSIndexPath).row) as? DataSnapshot {
            cell?.displayComment(comment)
            cell?.delegate = self
            cell?.profileView.addTapGestureRecognizer {
                cell?.profileView.enlargeImage(view: self)
            }
        }
        return cell ?? UITableViewCell()
    }
    fileprivate func hideReplyView() {
        replieToCommentID = nil
        replyView.isHidden = true
    }
    
    @IBAction func onSend(_ sender: AnyObject) {
        if let replyToComment = replieToCommentID, let commentText = self.commentText.text, commentText.count > 0{
            Comment.sendReply(messgae: commentText, toComment: replyToComment, ofstory: storyId)
            hideReplyView()
            view.endEditing(true)
        }
        else if let commentText = self.commentText.text , commentText.count > 0{
            Comment.sendComment(commentText, storyKey: self.storyId)
        }
        self.commentText.text = nil
    }
    
    @IBAction func deletereplyComment(_ sender: UIButton){
        replyView.isHidden = true
        replieToCommentID = nil
    }
    
    /* UserTableViewCellDelegate */
    
    func didSelected(ref: DatabaseReference) {
        // none
        let menuController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        menuController.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
        
        let removeAction = UIAlertAction(title: "comment.remove".localized, style: .destructive) { (action) in
            // remove from my feed
            ref.removeAllObservers()
            ref.removeValue()
        }

        ref.observeSingleEvent(of: .value) { (data) in
            
            if let value = data.value as? [String: Any] {
                // check if I'm allow to remove the comment
                if let userid = value["profile_id"] as? String {
                    if UserModel(userid).isCurrent() {
                        menuController.addAction(removeAction)
                        
                        if let popoverController = menuController.popoverPresentationController {
                            popoverController.sourceView = self.view
                            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                            popoverController.permittedArrowDirections = []
                        }

                        self.present(menuController, animated: true, completion: nil)
                    }
                }
            } else {
                print("Error: Can't load comment data")
            }
        }
    }
    
    func didAction(ref: DatabaseReference?, position: NSInteger) {
        // none
    }
    func replyToComment(comment: DataSnapshot?) {
        if let comment = comment, let value = comment.value as? [String:Any] {
            replieToCommentID = comment.key
            replytoUserLbl.text = "Replying to " + (value["profile_name"] as? String ?? "")
            commentText.becomeFirstResponder()
            replyView.isHidden = false
        }
        return
    }
    func refreshViewHeight() {
        //
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    func loadRepliesViewTap(comment: DataSnapshot?) {
        
    }
}
