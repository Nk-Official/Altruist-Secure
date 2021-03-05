//
//  StoryTableViewCell.swift
//  b03-ios
//
//  Created by Bossly on 9/10/16.
//  Copyright © 2016 Bossly. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import SDWebImage

protocol StoryTableViewCellDelegate {
    func storyAction(_ data: DatabaseReference?)
    func storyDidLike(_ data: DatabaseReference?)
    func storyDidShare(_ data: DatabaseReference?)
    func storyDidComment(_ data: DatabaseReference?)
    func didAction(ref: DatabaseReference?, position: NSInteger)
    func openProfile(_ user: DatabaseReference?)
}

class StoryTableViewCell: UITableViewCell,UIScrollViewDelegate {
    
    static var activePlayer: AVPlayer?
    static let AutoplayMuteKey = Notification.Name("StoryTableViewCell.AutoplayMuteKey")
    let kReadyDisplayKey: String = "readyForDisplay"
    
    @IBOutlet var storyImage: UIImageView?
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var likeButton: UIButton?
    @IBOutlet weak var commentsButton: UIButton?
    @IBOutlet weak var likeView: UIView?
    @IBOutlet weak var playerIconView: UIImageView!
    @IBOutlet weak var videoMute: UIImageView?
    @IBOutlet weak var profileView: UIImageView?
    @IBOutlet weak var profilePanel: UIView?
    @IBOutlet weak var usernameView: UILabel?
    @IBOutlet weak var subtitleView: UILabel?
    @IBOutlet weak var decriptionLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var storyHeightHeightConstraint: NSLayoutConstraint!
    var playerLayer: AVPlayerLayer?
    var delegate: StoryTableViewCellDelegate?
    var descriptionHandle: DatabaseHandle?
    var likesHandle: DatabaseHandle?
    var ref: DatabaseReference?
    var cellIndex: NSInteger = -1
    var isPlaying: Bool = false {
        didSet {
            playbackRefresh()
        }
    }
    
    let scrollView = UIScrollView()
    let pageControl = FlexiblePageControl()
    
    
    private var handler: UInt?
    
    var storyRef: DatabaseReference? {
        willSet {
            resetCell()
            
            // unsubscribe
            if let _handler = handler {
                storyRef?.removeObserver(withHandle: _handler)
                handler = nil
            }
            
            if let story = storyRef, let key = story.key {
                // unbind message
                if let handle = descriptionHandle {
                    Comment.collection.child(key).removeObserver(withHandle: handle)
                    descriptionHandle = nil
                }
                
                // unbind likes
                if let handle = likesHandle {
                    if let userid = Auth.auth().currentUser?.uid {
                        Like.collection.child("\(key)/\(userid)").removeObserver(withHandle: handle)
                        likesHandle = nil
                    }
                }
            }
        }
        didSet {
            // subscribe
            handler = storyRef?.observe(.value, with: { (snapshot) in
                if !snapshot.exists() {
                    // remove blank item
                    DispatchQueue.main.async {
                        self.ref?.removeAllObservers()
                        self.ref?.removeValue()
                    }
                } else {
                    let story = Story(snapshot)
                    self.setupCell(story)
                    self.userRef = story.userRef
                }
            })
            
            if let story = storyRef, let key = story.key {
                // bind message
                descriptionHandle = Comment.collection.child(key).observe(.childAdded) { (snapshot) in
                    self.displayMessage(snapshot)
                }
                
                // bind likes
                if let userid = Auth.auth().currentUser?.uid {
                    likesHandle = Like.collection.child("\(key)/\(userid)")
                        .observe(.value, with: { (snapshot) in
                            self.displayLike(snapshot)
                        })
                }
            }
        }
    }
    
    var userRef: DatabaseReference? {
        willSet {
            
            // unsubscribe
            if let _handler = handler {
                userRef?.removeObserver(withHandle: _handler)
            }
        }
        didSet {
            // subscribe
            handler = userRef?.observe(.value, with: { (snapshot) in
                let user = UserModel(snapshot)
                self.setupUser(user: user)
            })
        }
    }
    
    private func playbackRefresh() {
        
        if self.isPlaying {
            // pause previous player if not
            StoryTableViewCell.activePlayer?.pause()
            StoryTableViewCell.activePlayer = self.playerLayer?.player
            self.playerLayer?.player?.play()
        } else {
            self.playerLayer?.player?.pause()
        }
    }
    
    private func resetCell() {
        
        self.descriptionView.attributedText = nil
        
        // stop playback and remove old video player
        self.clear()
        
        // remove image
        self.storyImage?.sd_cancelCurrentImageLoad()
        self.storyImage?.image = nil
    }
    
    private func setupUser(user: UserModel) {
        let placeholder = UIImage(named: "avatarPlaceholder")!
        
        // user name
        self.usernameView?.text = user.name
        
        // user profile photo
        self.profileView?.sd_cancelCurrentImageLoad()
        self.profileView?.sd_setImage(with: URL(string: user.photo), placeholderImage: placeholder)
    }
    
    
    private func setupCell(_ story: Story) {
        
        self.subtitleView?.text = story.time?.timeAgoSinceNow
        if story.videoUrl != nil {
            scrollView.isHidden = true
            pageControl.isHidden = true
            
            let mediaUrl = URL(string: story.media)
            self.storyImage?.sd_cancelCurrentImageLoad()
            self.storyImage?.sd_setImage(with: mediaUrl, completed: { (image, error, type, url) in
                DispatchQueue.main.async {
                    self.layoutSubviews()
                    self.updateConstraints()
                }
            })
            
            if self.prepareVideo(url: story.videoUrl) != nil {
                playbackRefresh()
            }
            
        }else if story.multipleImage.count > 1
        {
            scrollView.isHidden = false
            pageControl.isHidden = false
            setContent(images: story.multipleImage)
        }
        else
        {
            scrollView.isHidden = true
            pageControl.isHidden = true
            
            let mediaUrl = URL(string: story.media)
            self.storyImage?.sd_cancelCurrentImageLoad()
            self.storyImage?.sd_setImage(with: mediaUrl, completed: { (image, error, type, url) in
                DispatchQueue.main.async {
                    self.layoutSubviews()
                    self.updateConstraints()
                }
            })
        }
        
        if let likes = story.snapshot?.values?["likes"] as? Int {
            self.likeButton?.setTitle("\(likes)", for: .normal)
        } else {
            self.likeButton?.setTitle("0", for: .normal)
        }
        
        if let comments = story.snapshot?.values?["comments"] as? Int {
            self.commentsButton?.setTitle("\(comments)", for: .normal)
        } else {
            self.commentsButton?.setTitle("0", for: .normal)
        }
        
        self.updateConstraints()
    }
    
    func displayLike(_ story: DataSnapshot) {
        DispatchQueue.main.async {
            self.likeButton?.isSelected = story.exists()
            self.updateConstraints()
        }
    }
    
    func displayMessage(_ story: DataSnapshot) {
        let comment = NSMutableAttributedString()
        
        if let value = story.value as? [String: Any] {
            if let profile = value["profile_name"] as? String {
                let attrs = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: kCommentFontSize)]
                comment.append(NSAttributedString(string: "\(profile) ", attributes: attrs))
            }
            if let message = value["message"] as? String {
                let attrs = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: kCommentFontSize)]
                comment.append(NSAttributedString(string: message, attributes: attrs))
            }
        }
        //        self.decriptionLabelHeightConstraint.constant = 0
        self.descriptionView.attributedText = comment
        self.descriptionView.layoutIfNeeded()
        //        self.decriptionLabelHeightConstraint.constant = "".estimatedHeightOfLabel(text: comment.string , label: self.descriptionView, fontSize : 13.0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.storyImage?.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        let gestureOne = UITapGestureRecognizer(target: self, action: #selector(oneActionClicked))
        gestureOne.numberOfTapsRequired = 1
        self.storyImage?.addGestureRecognizer(gestureOne)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(actionClicked))
        gesture.numberOfTapsRequired = kLikeTapCount
        self.storyImage?.addGestureRecognizer(gesture)
        
        gestureOne.require(toFail: gesture)
        
        
        self.storyImage?.isUserInteractionEnabled = true
        self.likeView?.alpha = 0
        
        let gestureProfile = UITapGestureRecognizer(target: self, action: #selector(profileClicked))
        gestureProfile.numberOfTapsRequired = 1
        self.profilePanel?.addGestureRecognizer(gestureProfile)
        
        DispatchQueue.main.async(execute: {
            self.storyImage!.updateConstraints()
        })
        
        scrollView.delegate = self
        scrollView.frame =  CGRect(x:20, y: storyImage!.frame.origin.y, width:UIScreen.main.bounds.size.width-40, height:storyImage!.frame.size.height)
        //scrollView.center = storyImage!.center
        scrollView.isPagingEnabled = true
        pageControl.center = CGPoint(x: scrollView.center.x, y: scrollView.frame.maxY + 16)
        self.addSubview(scrollView)
        self.addSubview(pageControl)
        
    }
    
    func setContent(images: [String]) {
        
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        
        scrollView.contentSize = CGSize(width: (UIScreen.main.bounds.width - 40) * CGFloat(images.count), height: storyImage!.frame.size.height)
        pageControl.numberOfPages = images.count
        
        for index in  0..<images.count {
            
            let view = UIImageView(
                frame: .init(
                    x: CGFloat(index) * UIScreen.main.bounds.width-40,
                    y: 0,
                    width: UIScreen.main.bounds.width-40,
                    height: storyImage!.frame.size.height
                )
            )
            view.contentMode = .scaleAspectFill
            view.sd_cancelCurrentImageLoad()
            let urlString : String = images[index]
            let mediaUrl = URL(string: urlString)
            let gestureOne = UITapGestureRecognizer(target: self, action: #selector(oneActionClicked))
            gestureOne.numberOfTapsRequired = 1
            view.addGestureRecognizer(gestureOne)
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(actionClicked))
            gesture.numberOfTapsRequired = kLikeTapCount
            view.addGestureRecognizer(gesture)
            
            gestureOne.require(toFail: gesture)
            
            view.sd_setImage(with: mediaUrl, completed: { (image, error, type, url) in
                DispatchQueue.main.async {
                    self.layoutSubviews()
                    self.updateConstraints()
                }
            })
            scrollView.addSubview(view)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.setProgress(contentOffsetX: scrollView.contentOffset.x, pageWidth: scrollView.bounds.width)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Add a shadow to the top and bottom of the view
        let direction: NLInnerShadowDirection = [.Top, .Bottom]
        self.storyImage?.addInnerShadowWithRadius(kPhotoShadowRadius, color: kPhotoShadowColor, inDirection: direction)
    }
    
    @IBAction func likeClicked(_ sender: AnyObject) {
        
        // only if not selected
        if let button = sender as? UIButton, button.isSelected == false {
            // play animation
            UIView.animate(
                withDuration: kLikeTapAnimationDuration,
                delay: 0.1,
                usingSpringWithDamping: 0.6,
                initialSpringVelocity: 0,
                options: .beginFromCurrentState,
                animations: {
                    button.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: { _ in
                button.transform = CGAffineTransform.identity
            })
        }
        
        self.delegate?.storyDidLike(self.storyRef)
    }
    
    @IBAction func shareClicked(_ sender: AnyObject) {
        
        if let key = storyRef?.key {
            let story = Story(key)
            story.fetchInBackground(completed: { (model, success) in
                
                // try to get image first
                var items: [Any] = [
                    "By \(story.userName)",
                ]
                
                if story.videoUrl != nil {
                    items.append(story.videoUrl)
                }else if story.multipleImage.count > 1 {
                    let myViews = self.scrollView.subviews
                    for image in myViews
                    {
                        if image.isKind(of: UIImageView.self){
                            guard let imageview = image as? UIImageView else {
                                return
                            }
                            items.append(imageview.image ?? "")
                        }
                    }
                } else if let image = self.storyImage?.image {
                    items.append(image)
                }
                if let topController = UIApplication.topViewController()
                {
                    let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
                    topController.present(activityViewController, animated: true) {}
                }
            })
        }
    }
    
    @IBAction func commentClicked(_ sender: AnyObject) {
        self.delegate?.storyDidComment(self.storyRef)
    }
    
    @IBAction func actionButton(sender: Any) {
        DispatchQueue.main.async {
            self.delegate?.didAction(ref: self.userRef, position: self.cellIndex)
        }
    }
    
    @IBAction func profileClicked(_ sender: Any) {
        self.delegate?.openProfile(self.userRef)
    }
    
    @objc func oneActionClicked(_ sender: AnyObject) {
        if let localPlayer = self.playerLayer?.player {
            
            if kAutoplayVideo {
                if localPlayer.volume == 0 {
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: StoryTableViewCell.AutoplayMuteKey, object: nil)
                        
                        localPlayer.volume = 1 // play sound
                        self.videoMute?.isHighlighted = true
                    }
                } else {
                    localPlayer.volume = 0 // mute sound
                    self.videoMute?.isHighlighted = false
                }
            } else {
                var paused: Bool = false
                
                if #available(iOS 10.0, *) {
                    paused = localPlayer.timeControlStatus == .paused
                } else {
                    paused = self.playerIconView!.isHighlighted == true
                }
                
                if paused {
                    localPlayer.play()
                    self.playerIconView?.isHighlighted = false
                    popupIconView(self.playerIconView)
                } else {
                    self.playerIconView?.isHighlighted = true
                    popupIconView(self.playerIconView)
                    localPlayer.pause()
                }
            }
        }else
        {
            if let topController = UIApplication.topViewController()
            {
                self.storyImage?.enlargeImage(view: topController)
            }
        }
    }
    
    @objc func actionClicked(_ sender: AnyObject) {
        if self.playerLayer == nil {
            
            UIView.animate(withDuration: kLikeTapAnimationDuration,
                           delay: 0.1,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.0,
                           options: .beginFromCurrentState,
                           animations: {
                            self.likeView?.transform = CGAffineTransform(scaleX: kLikeTapAnimationScale, y: kLikeTapAnimationScale)
                            self.likeView?.alpha = 1
            }, completion: { _ in
                self.likeView?.transform = CGAffineTransform.identity
                self.likeView?.alpha = 0
                self.delegate?.storyAction(self.storyRef)
            })
        }
    }
    
    func popupIconView(_ sender: UIView) {
        UIView.animate(withDuration: kLikeTapAnimationDuration,
                       delay: 0.1,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.0,
                       options: .beginFromCurrentState,
                       animations: {
                        self.playerIconView?.transform = CGAffineTransform(scaleX: kLikeTapAnimationScale, y: kLikeTapAnimationScale)
                        self.playerIconView?.alpha = 1
        }, completion: { _ in
            self.playerIconView?.transform = CGAffineTransform.identity
            self.playerIconView?.alpha = 0
        })
    }
    
    // MARK: - Video Player
    
    func clear() {
        self.videoMute?.isHidden = true
        
        if let layer = self.playerLayer {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
            NotificationCenter.default.removeObserver(self, name: StoryTableViewCell.AutoplayMuteKey, object: nil)
            self.playerLayer = nil
            
            if let player = layer.player {
                player.pause()
            }
            
            deallocObservers(layer: layer)
            layer.removeFromSuperlayer()
        }
    }
    
    func prepareVideo(url: URL) -> AVPlayer? {
        if let urlCopy = URL(string: url.absoluteString) {
            self.videoMute?.isHidden = false
            let player = AVPlayer(url: urlCopy)
            
            if kAutoplayVideo {
                // for autoplay button will change a sound
                player.volume = 0
                self.videoMute?.isHighlighted = false
            }
            
            let layer = AVPlayerLayer(player: player)
            
            layer.backgroundColor = UIColor.white.cgColor
            layer.frame = CGRect(x: 0, y: 0, width: self.storyImage!.frame.width, height: self.storyImage!.frame.height)
            layer.videoGravity = kVideoScale
            layer.opacity = 0 // hide before load
            layer.addObserver(self, forKeyPath: kReadyDisplayKey, options: NSKeyValueObservingOptions(), context: nil)
            
            self.storyImage?.layer.addSublayer(layer)
            self.playerLayer = layer
            
            player.actionAtItemEnd = .none
            
            NotificationCenter.default.addObserver(self, selector: #selector(autoplayMute),
                                                   name: StoryTableViewCell.AutoplayMuteKey, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd),
                                                   name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
            
            return player
        }
        
        return nil
    }
    
    // observer for av play
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {
        if let layer = playerLayer {
            if keyPath == kReadyDisplayKey && layer.isReadyForDisplay {
                layer.frame = CGRect(x: 0, y: 0, width: self.storyImage!.frame.width, height: self.storyImage!.frame.height)
                layer.opacity = 1
            }
        }
    }
    
    private func deallocObservers(layer: AVPlayerLayer) {
        layer.removeObserver(self, forKeyPath: kReadyDisplayKey)
    }
    
    @objc func autoplayMute(notification: NSNotification) {
        self.playerLayer?.player?.volume = 0
        self.videoMute?.isHighlighted = false
    }
    
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: kCMTimeZero)
        }
    }
}
