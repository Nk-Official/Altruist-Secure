//
//  TESTTableViewCell.swift
//  LinkPreview
//
//  Created by Param Goraya on 15/06/20.
//  Copyright © 2020 Giftzoom. All rights reserved.
//

import UIKit
import URLEmbeddedView
import MisterFusion
import SafariServices
import Firebase
import SDWebImage

class LinkPreviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var timeView: UILabel!
    var delegate: UserTableViewCellDelegate?
    fileprivate var user: UserModel?
    fileprivate var commentRef: DatabaseReference?
    @IBOutlet weak var removeCommentButton: UIButton!
    
    @IBOutlet weak var viewReplyBtn: UIButton?
    @IBOutlet weak var replyBtn: UIButton?
    @IBOutlet weak var viewReplyView: UIView?
    @IBOutlet weak var replyCountLbl: UILabel?
    @IBOutlet weak var viewReplyHeight: NSLayoutConstraint?
    @IBOutlet weak var replyTableView: UITableView?
    @IBOutlet weak var replyTableHeight: NSLayoutConstraint?

    var snapshot: DataSnapshot?
    var links = [String]()
    var replies: [NSDictionary] = []
    var repliesToShow: [NSDictionary] = []
    var showReplies: Bool = false
    
    var tableViewHeight: CGFloat {
        tableView.layoutIfNeeded()
        return tableView.contentSize.height
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let profile = self.profileView {
            profile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        }
        self.replyTableView?.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize") , showReplies{
            print("content size",self.replyTableView?.contentSize.height)
            self.replyTableHeight?.constant = self.showReplies ? self.replyTableView?.contentSize.height ?? 0 : 0
            self.delegate?.refreshViewHeight()
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        tableViewHeightConstraint.constant = 0
        replyTableHeight?.constant = 0
        repliesToShow.removeAll()
    }
    deinit {
        self.replyTableView?.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func addObserver(commentRef : DatabaseReference?){
        guard let ref = commentRef else{
            return
        }
        let query = ref.child(kDataReplyKey).queryOrderedByKey()
        query.observe(DataEventType.childAdded) { [weak self] (snapshot) in
            if let value = snapshot.value as? NSDictionary{
                self?.replies.append( value)
                self?.showViewRepliesOption(replies: self?.replies ?? [])
                self?.delegate?.refreshViewHeight()
            }
        }
    }
    
    func displayComment(_ comment: DataSnapshot) {
        snapshot = comment
        tableViewHeightConstraint.constant = 0
        replyTableHeight?.constant = 0
        self.commentRef = comment.ref
        self.addObserver(commentRef: comment.ref)
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
                
                let detectorType: NSTextCheckingResult.CheckingType = [.link]
                do {
                    let detector = try NSDataDetector(types: detectorType.rawValue)
                    let results = detector.matches(in: message, options: [], range: NSRange(location: 0, length: message.utf16.count))
                    var urlArray : [String] = []
                    for result in results {
                        if let range = Range(result.range, in: message) {
                            let matchResult = message[range]
                            print("result: \(matchResult), range: \(result.range)")
                            urlArray.append(String(matchResult))
                        }
                    }
                    if urlArray.count > 0
                    {
                        links = urlArray
                        tableView.delegate = self
                        tableView.dataSource = self
                        tableView.reloadData()
                        tableView.layoutIfNeeded()
                        var tableCellHeight : CGFloat = 0
                        for link in links
                        {
                            if let imageURL = URL(string : link) {
                                debugPrint(imageURL.pathExtension.uppercased())
                                if kImageExtensions.contains(imageURL.pathExtension.uppercased())
                                {
                                    tableCellHeight = tableCellHeight + 200
                                }else
                                {
                                    tableCellHeight = tableCellHeight + 80
                                }
                            }else
                            {
                                tableCellHeight = tableCellHeight + 80
                            }
                        }
                        tableViewHeightConstraint.constant = tableCellHeight
                    }
                } catch {
                    print("handle error")
                }
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
            if let replies = value[kDataReplyKey] as? NSDictionary {
                var repliesArr = [NSDictionary]()
                for (_,value) in replies  {
                    if let commentdata = value as? NSDictionary{
                        repliesArr.append(commentdata)
                    }
                }
                
                showViewRepliesOption(replies: repliesArr)
            }else{
                hideViewRepliesOption()
            }
            label.attributedText = text
            self.updateConstraints()
        } else {
            // error
            self.profileView?.image = nil
            label.attributedText = nil
        }
    }
    
    func displayReplie(replie: NSDictionary){
        
         if let userid = replie["profile_id"] as? String {
               user = UserModel(userid)
           }
           
           let text = NSMutableAttributedString()
           let placeholder = UIImage(named: "avatarPlaceholder")
           
           if let profile = replie["profile_name"] as? String {
               let attrs = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: kCommentFontSize)]
               text.append(NSAttributedString(string: "\(profile) ", attributes: attrs))
           }
           
           if let message = replie["message"] as? String {
               let attrs = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: kCommentFontSize)]
               text.append(NSAttributedString(string: message, attributes: attrs))
               
               let detectorType: NSTextCheckingResult.CheckingType = [.link]
               do {
                   let detector = try NSDataDetector(types: detectorType.rawValue)
                   let results = detector.matches(in: message, options: [], range: NSRange(location: 0, length: message.utf16.count))
                   var urlArray : [String] = []
                   for result in results {
                       if let range = Range(result.range, in: message) {
                           let matchResult = message[range]
                           print("result: \(matchResult), range: \(result.range)")
                           urlArray.append(String(matchResult))
                       }
                   }
                   if urlArray.count > 0
                   {
                       links = urlArray
                       tableView.delegate = self
                       tableView.dataSource = self
                       tableView.reloadData()
                       tableView.layoutIfNeeded()
                       var tableCellHeight : CGFloat = 0
                       for link in links
                       {
                           if let imageURL = URL(string : link) {
                               debugPrint(imageURL.pathExtension.uppercased())
                               if kImageExtensions.contains(imageURL.pathExtension.uppercased())
                               {
                                   tableCellHeight = tableCellHeight + 200
                               }else
                               {
                                   tableCellHeight = tableCellHeight + 80
                               }
                           }else
                           {
                               tableCellHeight = tableCellHeight + 80
                           }
                       }
                       tableViewHeightConstraint.constant = tableCellHeight
                   }else{
                    tableViewHeightConstraint.constant = 0
                }
               } catch {
                   print("handle error")
               }
           }
           
           if let time = replie["created"] as? TimeInterval {
               self.timeView?.text = Date(timeIntervalSince1970: time/1000).shortTimeAgoSinceNow
           } else {
               self.timeView?.text = nil
           }
           
           if let profileImage = replie["profile_image"] as? String, let photoUrl = URL(string: profileImage) {
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
        label.attributedText = text
        self.updateConstraints()
    }
    
    @IBAction func removeComment(_ sender: Any) {
        if let ref = commentRef {
            self.delegate?.didSelected(ref: ref)
        }
    }
    
    @IBAction func replyBtn(_ sender: UIButton){
        self.delegate?.replyToComment(comment: snapshot)
    }
    @IBAction func viewReplyBtn(_ sender: UIButton){
        showReplies = true
        setValueForRepliesToShowUser()
        reloadReplies()
        delegate?.loadRepliesViewTap(comment: snapshot)
    }
    
    //MARK: - View replies View Setup
    func showViewRepliesOption(replies: [NSDictionary]){
        viewReplyView?.isHidden = false
        viewReplyHeight?.constant = 40
        replyCountLbl?.text = replies.count == 1 ? "View 1 reply" : "View \(replies.count) replies"
//        self.replies.removeAll()
//        replyTableHeight?.constant = 0
    }
    func hideViewRepliesOption(){
        viewReplyView?.isHidden = true
        viewReplyHeight?.constant = 0
        replyTableHeight?.constant = 0
    }
    
    //MARK: - LOADING REPLIES
    func reloadReplies(){
        replyTableView?.delegate = self
        replyTableView?.dataSource = self
        replyTableView?.reloadData()
        replyTableHeight?.constant = showReplies ? (replyTableView?.contentSize.height ?? 0) : 0
        self.updateConstraints()
    }
    func setValueForRepliesToShowUser(){
        var reverseReplies = replies
        reverseReplies.reverse()
        if !showReplies{
            repliesToShow.removeAll()
            replyTableHeight?.constant = 0
            replyTableView?.reloadData()
            if reverseReplies.count > 0{showViewRepliesOption(replies: reverseReplies)}
            return
        }
        if repliesToShow.count < reverseReplies.count{
            let slice = reverseReplies.prefix(repliesToShow.count+2)
            repliesToShow  = Array(slice)
            replyCountLbl?.text = "Load more replies"
        }else {
            showReplies = false
            repliesToShow.removeAll()
            replyTableHeight?.constant = 0
            replyCountLbl?.text = reverseReplies.count == 1 ? "View 1 reply" : "View \(reverseReplies.count) replies"
        }
        if repliesToShow.count == reverseReplies.count{
            replyCountLbl?.text = "Hide all replies"
        }
        delegate?.refreshViewHeight()
    }
}

extension LinkPreviewTableViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         if tableView == self.tableView{
            let url = links[indexPath.row]
            guard let imageURL = URL(string : url) else {
                return UITableViewCell()
            }
            if  kImageExtensions.contains(imageURL.pathExtension.uppercased())
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewImageCell") as! TableViewCell
                cell.imageLinkView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imageLinkView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "avatarPlaceholder"), options: [], completed: { (image, error, type, url) in
                    DispatchQueue.main.async(execute: {
                        cell.imageLinkView.sd_imageIndicator = nil
                    })
                })
                cell.imageLinkView.addTapGestureRecognizer {
                    if let topController = UIApplication.topViewController()
                    {
                        cell.imageLinkView.enlargeImage(view: topController)
                    }
                }
                return cell
            }else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
                cell.embeddedView.load(urlString: url)
                cell.selectionStyle = .none
                cell.embeddedView.didTapHandler = { embeddedView, URL in
                    guard let URL = URL else { return }
                    if let topController = UIApplication.topViewController()
                    {
                        topController.present(SFSafariViewController(url: URL), animated: true, completion: nil)
                    }
                }
                return cell
            }
         }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LinkPreviewTableViewCell", for: indexPath) as? LinkPreviewTableViewCell
            cell?.displayReplie(replie: repliesToShow[indexPath.row])
            return cell ?? UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            return links.count
        }
        return repliesToShow.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView{
            let url = links[indexPath.row]
            guard let imageURL = URL(string : url) else {
                return 80
            }
            if kImageExtensions.contains(imageURL.pathExtension.uppercased())
            {
                return 200
            }
            return 80
        }
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
}

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    let embeddedView = URLEmbeddedView()
    @IBOutlet weak var imageLinkView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if containerView != nil
        {
            containerView.addLayoutSubview(embeddedView, andConstraints:
                embeddedView.top ,embeddedView.right ,embeddedView.left ,embeddedView.bottom
            )
            containerView.addSubview(embeddedView)
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        embeddedView.prepareViewsForReuse()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
