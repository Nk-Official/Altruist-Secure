//
//  SecondViewController.swift
//
//  Created by Bossly on 9/10/16.
//  Copyright © 2016 Bossly. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import MessageUI

class ThumbnailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var multipleImageSign: UIButton!
    
}

class ProfileInfoViewCell: UICollectionReusableView {
    @IBOutlet weak var lblFollowingsCount: UILabel?
    @IBOutlet weak var lblFollowersCount: UILabel?
    @IBOutlet weak var lblPostsCount: UILabel?
    @IBOutlet weak var pvPhoto: ProfileView?
    @IBOutlet weak var btnAction: UIButton?
    @IBOutlet weak var bioText: UITextView!
    @IBOutlet var bioLabelHeightConstraint: NSLayoutConstraint!

    var defaultColor = UIColor.darkText
    var currentUser: UserModel?
    var isFollow: Bool = false {
        didSet {
            btnAction?.layer.borderColor = defaultColor.cgColor
            
            if isFollow {
                btnAction?.setTitle(NSLocalizedString("Unfollow", comment: ""), for: .normal)
                btnAction?.backgroundColor = defaultColor
                btnAction?.setTitleColor(.white, for: .normal)
            } else {
                btnAction?.setTitle(NSLocalizedString("Follow", comment: ""), for: .normal)
                btnAction?.setTitleColor(defaultColor, for: .normal)
                btnAction?.backgroundColor = .clear
            }
        }
    }
    var controller: UIViewController?

    @IBAction func actionButton() {
        
        // follow/unfollow user
        if let user = self.currentUser, !user.isCurrent() {
            isFollow = !isFollow

            if user.isFollow {
                user.unfollow()
            } else {
                user.follow()
            }
        } else {
            controller?.performSegue(withIdentifier: "profile.edit", sender: self)
        }
    }
}

class ProfileViewController: UICollectionViewController,ClosePopupDelegate {
    
    var activities: NSMutableArray = []
    var currentUser: UserModel? = UserModel.current
    var bioLabelHeight : CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()

        // hide back button text
        if let collectionWidth = self.collectionView?.bounds.size.width {
            let cellWidth = collectionWidth/kFavoritesColumns - 1 // minus px padding
            let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout
            flowLayout?.itemSize = CGSize(width: cellWidth, height: cellWidth)
        }

        // remove text 'Back'
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // load user profile and keep tracking update
        guard let user = self.currentUser else { return }

        user.ref.observe(.value, with: { (snap) in
            user.followersCount = snap.childSnapshot(forPath: kFollowersKey).childrenCount
            user.followingsCount = snap.childSnapshot(forPath: kFollowinsKey).childrenCount
            user.loadData(snap: snap, with: { (success) in
                self.displayUserInfo()
            })
        })
        
        // load favorites/likes collection
        if let key = user.ref.key {
            loadActivity(key)
        }

        if user.blockedMe() {
            showBlockedMessage()
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

    func displayUserInfo() {
        self.navigationItem.title = self.currentUser?.name
        self.collectionView?.reloadData()
    }
    
    func loadActivity(_ userId: String) {
        
        let favorites = UserModel(userId).uploads
        let ref = favorites.queryOrderedByValue()

        // bind items, and update collection 
        ref.observe(.value, with: { (snapshot) -> Void in
            self.activities = NSMutableArray(array: snapshot.children.allObjects.reversed())
            self.collectionView?.reloadData()
        })
    }

    // MARK: - Table view data source

    // Layout views in kFavoritesColumns columns

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.activities.count
    }
  
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var profileView: ProfileInfoViewCell! = nil
        
        if kind == UICollectionElementKindSectionHeader {
            profileView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Cell", for: indexPath) as? ProfileInfoViewCell
            let placeholder = UIImage(named: "avatarPlaceholder")!
            profileView.currentUser = self.currentUser
            profileView.controller = self
            
            profileView.lblFollowingsCount?.text = "\(self.currentUser?.followingsCount ?? 0)"
            profileView.lblFollowersCount?.text = "\(self.currentUser?.followersCount ?? 0)"
            profileView.lblPostsCount?.text = "\(self.activities.count)"
                        
            bioLabelHeight = 0.0
            profileView.bioLabelHeightConstraint.constant = 0
            profileView.bioText.text = (currentUser?.bio ?? "").capitalized
            profileView.bioText.selectedTextRange = profileView.bioText.textRange(from: profileView.bioText.beginningOfDocument, to: profileView.bioText.beginningOfDocument)
            profileView.bioText.textContainerInset = UIEdgeInsets.init(top: 5, left: 0, bottom: 0, right: 0)
            profileView.bioText.layoutIfNeeded()
            let bioHeight = "".estimatedHeightOfLabel(text: currentUser?.bio ?? "", label: profileView.bioText, fontSize : 15.0)
            profileView.bioLabelHeightConstraint.constant = (bioHeight < 20 && bioHeight > 10) ? 20 : bioHeight
            bioLabelHeight = profileView.bioLabelHeightConstraint.constant
            profileView.needsUpdateConstraints()
            
            if let photo = URL(string: currentUser!.photo) {
                profileView.pvPhoto?.sd_setImage(with: photo, placeholderImage: placeholder, completed: { (image, error, cache, url) in
                    profileView.pvPhoto?.layoutSubviews()
                })
                profileView.pvPhoto?.addTapGestureRecognizer {
                    profileView.pvPhoto?.enlargeImage(view: self)
                }
            }
            
            if let user = self.currentUser, !user.isCurrent() {
                profileView.btnAction?.setTitle("Follow", for: UIControlState.normal)
                profileView.btnAction?.setTitle("Unfollow", for: UIControlState.selected)
                profileView.isFollow = user.isFollow
            }
            
             let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout
            flowLayout?.headerReferenceSize = CGSize(width: collectionView.frame.size.width, height: CGFloat(150.0 + bioLabelHeight))
        }
        
        return profileView
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            as? ThumbnailCollectionViewCell,
            let r = self.activities.object(at: (indexPath as NSIndexPath).row) as? DataSnapshot else {
                return UICollectionViewCell()
        }
        
        // Configure the cell
        
        let story = Story(r.key)
        cell.imageView?.image = UIImage(named: kDefaultProfilePhoto)
        cell.imageView?.sd_cancelCurrentImageLoad()

        story.fetchInBackground { (model, success) in
            cell.imageView?.sd_imageIndicator = SDWebImageActivityIndicator.gray
            if story.multipleImage.count > 1
            {
               cell.imageView?.sd_setImage(with: URL(string: story.multipleImage[0]))
            }
            else
            {
                cell.imageView?.sd_setImage(with: URL(string: story.media))
            }
            cell.multipleImageSign.isHidden = story.multipleImage.count > 1 ? false : true
        }
        return cell
    }
    
    @IBAction func onMoreButtonClicked(_ sender: Any) {
        guard let user = self.currentUser else { return }
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if user.isCurrent() {
            // Log out
            let invite = UIAlertAction(title: "Invite Friends".localized, style: .default) { (action) in
                self.showPopup()
            }
            let actionLogout = UIAlertAction(title: "logout".localized, style: .destructive) { (action) in
                self.logOut()
            }
            actionSheet.addAction(invite)
            actionSheet.addAction(actionLogout)
        } else {
            // Send Direct Message
            let actionMessage = UIAlertAction(title: "message.send".localized, style: .default) { (action) in
                self.sendMessage()
            }
            
            actionSheet.addAction(actionMessage)
            
            // Report the user
            let actionReport = UIAlertAction(title: "user.report".localized, style: .destructive) { (action) in
                self.reportUser()
            }
            actionSheet.addAction(actionReport)

            // Block the user
            if UserModel.current?.hasBlocked(user: user) == true {
                let actionBlock = UIAlertAction(title: "user.unblock".localized, style: .destructive) { (action) in
                    UserModel.current?.block(user: user, value: false)
                }
                actionSheet.addAction(actionBlock)
            } else {
                let actionBlock = UIAlertAction(title: "user.block".localized, style: .destructive) { (action) in
                    self.blockUser()
                }
                actionSheet.addAction(actionBlock)
            }
        }

        // Cancel
        let actionCancel = UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil)
        actionSheet.addAction(actionCancel)
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.barButtonItem = sender as? UIBarButtonItem
        }

        present(actionSheet, animated: true, completion: nil)
    }    
    
    func logOut() {
        let alert = UIAlertController(title: "logout".localized, message: "logout.message".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "logout".localized, style: .destructive, handler: { (action) in
            try? Auth.auth().signOut()
        }))
        present(alert, animated: true, completion: nil)
    }
    
     func showPopup()  {
         let destinationVC : PopupViewController = PopupViewController.initiatefromStoryboard(.Onboarding)
         destinationVC.view.frame = self.view.bounds
         destinationVC.type = "profile"
         destinationVC.popupDelegate = self
         destinationVC.modalTransitionStyle = .crossDissolve
         destinationVC.modalPresentationStyle = .custom
         present(destinationVC, animated: true, completion: {})
     }
     
     func closePopupView()
     {
         self.dismiss(animated: true, completion: nil)
     }

    func sendMessage() {
        if self.currentUser?.isCurrent() ?? true {
            self.performSegue(withIdentifier: "messages.recents", sender: nil)
        } else {
            self.performSegue(withIdentifier: "messages.direct", sender: nil)
        }
    }
    
    func blockUser() {
        guard let user = self.currentUser else { return }

        let msg = "User \(user.name) cannot message you and comment your posts. Continue?"
        let alert = UIAlertController(title: "user.block".localized, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "user.block".localized, style: .destructive, handler: { (action) in
            // add user to block list
            UserModel.current?.block(user: user)
            // move back
            _ = self.navigationController?.popViewController(animated: true)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func reportUser() {
        // 1. stop listening for the notification from that user
        // -
        
        guard let key = self.currentUser?.ref.key else { return }
        let body = "Please block the user with id: \(key), as not appropriate."
        
        // 2. send email with report
        if MFMailComposeViewController.canSendMail() {
            let email = MFMailComposeViewController()
            email.setSubject("user.report".localized)
            email.setMessageBody(body, isHTML: false)
            email.mailComposeDelegate = self
            email.setToRecipients([kReportEmail])
            self.present(email, animated: true, completion: nil)
        } else {
            let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            
            if let mailurl = URL(string: "mailto:\(kReportEmail)?subject=\(encodedBody)") {
                UIApplication.shared.open(mailurl, options: [:], completionHandler: nil)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let feed = segue.destination as? StoryViewController {
            if let indexPath = self.collectionView?.indexPathsForSelectedItems?.first,
                let r = self.activities.object(at: (indexPath as NSIndexPath).row) as? DataSnapshot {
                feed.storyId = r.key
            }
        } else if let messages = segue.destination as? ChatViewController {
            // create new chat or use old one
            messages.contactRef = self.currentUser?.ref
        } else if let users = segue.destination as? UsersTableViewController {
            let gesture = sender as? UITapGestureRecognizer
            let tag = gesture?.view?.tag ?? 0
            
            switch tag {
            case 1:
                users.title = "user.followers".localized
                users.query = currentUser?.followers.queryOrderedByKey()
            case 2:
                users.title = "user.followings".localized
                users.query = currentUser?.followings.queryOrderedByKey()
            default: break
            }
        }
    }
}

extension ProfileViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension String
{
    func estimatedHeightOfLabel(text: String, label: UITextView, fontSize : CGFloat) -> CGFloat {
          label.layoutIfNeeded()
          let size = CGSize(width: label.frame.width, height: .greatestFiniteMagnitude)
          let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
          let attributes = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: fontSize)]
          let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: convertToOptionalNSAttributedStringKeyDictionary(attributes), context: nil).height
          return rectangleHeight
      }
    
    fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
        return input.rawValue
    }
    
    fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
        guard let input = input else { return nil }
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
    }
}
