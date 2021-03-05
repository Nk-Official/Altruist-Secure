//
//  FirstViewController.swift
//
//  Created by Bossly on 9/10/16.
//  Copyright © 2016 Bossly. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage
import AVFoundation
import DateToolsSwift
import MessageUI

class FeedViewController: UITableViewController, StoryTableViewCellDelegate {
    
    @IBOutlet var emptyView: UIView?
    @IBOutlet var loadingView: UIView?
    
    var tableViewItems = [Any]()
    let numAdsToLoad = 10
    var nativeAds = [GADUnifiedNativeAd]()
    var adLoader: GADAdLoader!
    
    //var posts: [DataSnapshot] = []
    var lastKey: DataSnapshot?
    var collection = Story.recents
    
    var newRef: DatabaseQuery?
    var oldRef: DatabaseQuery?
    var activeCell: StoryTableViewCell? // cell in center
    
    // used to show only one story
    var singleStoryId: String?
    var backgroundImage = UIImageView()

    private var stopPaginationLoading: Bool = false
    private var isLoading: Bool = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View cycle
    
    override func viewDidLoad() {
        self.tableView.estimatedRowHeight = 350
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        
        // show personal feed
        self.stopPaginationLoading = true
        self.isLoading = true
        self.tableViewItems = []
        
        // show personal feed
        self.collection = Story.recents //UserModel.current!.feed
        
        self.loadData()
        loadAds()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        self.tableView.register(UINib(nibName: "UnifiedNativeAdCell", bundle: nil),forCellReuseIdentifier: "UnifiedNativeAdCell")
        backgroundImage.frame = self.tableView.frame
        backgroundImage.backgroundColor = .groupTableViewBackground
        self.tableView.backgroundView = backgroundImage
        backgroundImage.contentMode = .scaleToFill
        self.tableView.reloadData()
    }
    
    func loadAds()  {
        let options = GADMultipleAdsAdLoaderOptions()
        options.numberOfAds = numAdsToLoad
        
        // Prepare the ad loader and start loading ads.
        adLoader = GADAdLoader(adUnitID: kAdMobUnitID,rootViewController: self,adTypes: [.unifiedNative],options: [options])
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startObserveScrollingTop()
        if let currentUser = UserModel.current {
            if let url : URL = URL(string: currentUser.backgroundPhoto)
            {
                backgroundImage.sd_setImage(with: url)
            }else
            {
                if let url : URL = URL(string: UserDefaults.standard.backgroundImage ?? "")
                {
                    backgroundImage.sd_setImage(with: url)
                }
            }
        }else
        {
            if let url : URL = URL(string: UserDefaults.standard.backgroundImage ?? "")
            {
                backgroundImage.sd_setImage(with: url)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopObserveScrollingTop()
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: StoryTableViewCell.AutoplayMuteKey, object: nil)
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let lastIndex = self.tableView.indexPathsForVisibleRows?.last {
            if lastIndex.row >= self.tableViewItems.count - 2 {
                loadMore()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let commentsCtrl = segue.destination as? CommentsTableViewController {
            let story = sender as? DatabaseReference
            commentsCtrl.storyId = story?.key
        }
        
        if let profileCtrl = segue.destination as? ProfileViewController {
            if let user = sender as? DatabaseReference, let key = user.key {
                profileCtrl.currentUser = UserModel(key)
            }
        }
    }
    
    // MARK: - Data
    
    func observeNewItems(_ firstKey: DataSnapshot?) {
        // Listen for new posts in the Firebase database
        newRef?.removeAllObservers()
        newRef = self.collection.queryOrderedByKey()
        
        if let startKey = firstKey?.key {
            newRef = newRef?.queryStarting(atValue: startKey)
        }
        
        // Listen for new posts in the Firebase database
        newRef?.observe(.childAdded, with: { (snapshot) in
            if snapshot.key != firstKey?.key {
                DispatchQueue.main.async(execute: {
                    self.tableViewItems.insert(snapshot, at: 0)
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    func loadData() {
        if let storyId = singleStoryId {
            let ref = Story.collection.child(storyId)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                DispatchQueue.main.async(execute: {
                    self.tableViewItems.insert(snapshot, at: 0)
                    self.stopPaginationLoading = true
                    print("Loaded \(snapshot.childrenCount) items")
                    self.isLoading = false
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                })
                
            }, withCancel: { error in
                let alert = UIAlertController(title: kAlertErrorTitle, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: kAlertErrorDefaultButton, style: .default) { (action) in })
                self.present(alert, animated: true) {}
            })
            
        } else {
            let ref = self.collection.queryOrderedByKey().queryLimited(toLast: kPagination)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                DispatchQueue.main.async(execute: {
                    for child in snapshot.children {
                        if let item = child as? DataSnapshot {
                            self.tableViewItems.insert(item, at: 0)
                        }
                    }
                    if self.singleStoryId == nil {
                        self.addNativeAds()
                    }
                    self.stopPaginationLoading = false
                    self.lastKey = snapshot.children.allObjects.first as? DataSnapshot
                    
                    let firstKey = snapshot.children.allObjects.last as? DataSnapshot
                    self.observeNewItems(firstKey)
                    
                    print("Loaded \(snapshot.childrenCount) items")
                    self.isLoading = false
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                })
                
            }, withCancel: { error in
                let alert = UIAlertController(title: kAlertErrorTitle, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: kAlertErrorDefaultButton, style: .default) { (action) in })
                self.present(alert, animated: true) {}
            })
            
            // track for remove
            oldRef?.removeAllObservers()
            oldRef = self.collection
            oldRef?.observe(.childRemoved, with: { (snapshot) in
                DispatchQueue.main.async(execute: {
                    for index in 0...self.tableViewItems.count - 1 {
                        let item = self.tableViewItems[index]
                        if let menuItem = item as? DataSnapshot {
                            if menuItem.key == snapshot.key
                            {
                                self.tableViewItems.remove(at: index)
                                break
                            }
                        }
                    }
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    func loadMore() {
        // load more
        if self.stopPaginationLoading == true || singleStoryId != nil {
            return
        }
        
        var refPagination = self.collection.queryOrderedByKey().queryLimited(toLast: kPagination + 1)
        
        if let last = self.lastKey {
            refPagination = refPagination.queryEnding(atValue: last.key)
            
            // load rest feed
            refPagination.observeSingleEvent(of: .value, with: { (snapshot) -> Void in
                
                print("Loaded more \(snapshot.childrenCount) items")
                
                let items = snapshot.children.allObjects
                
                if items.count > 1 {
                    for i in 2...items.count {
                        if let data = items[items.count-i] as? DataSnapshot {
                            self.tableViewItems.append(data)
                        }
                    }
                    
                    self.lastKey = items.first as? DataSnapshot
                    self.tableView.reloadData()
                } else {
                    self.stopPaginationLoading = true
                    print("last item")
                }
            })
        }
    }
    
    func activateCell() {
        let center = CGPoint(x: view.center.x, y: view.frame.height/2 + self.tableView.contentOffset.y)
        guard
            let centeredIndexPath = tableView.indexPathForRow(at: center),
            let storyCell = tableView.cellForRow(at: centeredIndexPath) as? StoryTableViewCell
            else { return }
        
        if activeCell != storyCell {
            activeCell?.isPlaying = false
            activeCell = storyCell
            storyCell.isPlaying = true
        }
    }
    
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        // reset states
        self.lastKey = nil
        self.stopPaginationLoading = true
        self.tableViewItems = []
        
        // reload data
        loadData()
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // update empty view
        if self.tableViewItems.count == 0 {
            //self.tableView.backgroundView = isLoading ? loadingView : emptyView
        }
        
        return self.tableViewItems.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ((tableViewItems[indexPath.row] as? DataSnapshot) != nil) {
            return UITableViewAutomaticDimension
        }
        else
        {
            return 360
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if kAutoplayVideo {
            activateCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menuItem = tableViewItems[indexPath.row] as? DataSnapshot {
            
            let identifier = "Cell"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? StoryTableViewCell else {
                return UITableViewCell()
            }
            cell.ref = menuItem.ref
            cell.storyRef = Story(menuItem.key).ref
            cell.delegate = self
            cell.cellIndex = indexPath.row
            cell.profileView?.addTapGestureRecognizer {
                cell.profileView?.enlargeImage(view: self)
            }
            return cell
        } else {
            
            let nativeAd = tableViewItems[indexPath.row] as! GADUnifiedNativeAd
            nativeAd.rootViewController = self
            
            let nativeAdCell = tableView.dequeueReusableCell(withIdentifier: "UnifiedNativeAdCell", for: indexPath)
            
            let adView : GADUnifiedNativeAdView = nativeAdCell.contentView.subviews.first as! GADUnifiedNativeAdView
            adView.frame =  CGRect(x:0, y: 5, width:UIScreen.main.bounds.size.width, height:355)
            adView.nativeAd = nativeAd
            
            (adView.headlineView as? UILabel)?.text = nativeAd.headline
            adView.mediaView?.mediaContent = nativeAd.mediaContent
            
            let mediaContent = nativeAd.mediaContent
            if mediaContent.hasVideoContent {
                mediaContent.videoController.delegate = self
                //"Ad contains a video asset."
            }
            else {
                //"Ad does not contain a video."
            }
            
            (adView.bodyView as? UILabel)?.text = nativeAd.body
            adView.bodyView?.isHidden = nativeAd.body == nil
            
            (adView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
            adView.callToActionView?.isHidden = nativeAd.callToAction == nil
            
            (adView.iconView as? UIImageView)?.image = nativeAd.icon?.image
            adView.iconView?.isHidden = nativeAd.icon == nil
            
            (adView.starRatingView as? UIImageView)?.image = imageOfStars(from:nativeAd.starRating)
            adView.starRatingView?.isHidden = nativeAd.starRating == nil
            adView.starRatingView?.contentMode = .scaleAspectFit
            
            (adView.storeView as? UILabel)?.text = nativeAd.store
            adView.storeView?.isHidden = nativeAd.store == nil
            
            (adView.priceView as? UILabel)?.text = nativeAd.price
            adView.priceView?.isHidden = nativeAd.price == nil
            
            (adView.advertiserView as? UILabel)?.text = nativeAd.advertiser
            adView.advertiserView?.isHidden = nativeAd.advertiser == nil
            
            adView.callToActionView?.isUserInteractionEnabled = false
            
            return nativeAdCell
        }
    }
    
    // MARK: - Cell delegate
    
    func storyAction(_ data: DatabaseReference?) {
        if let story = data {
            Like.story(story)
        }
    }
    
    func storyDidLike(_ data: DatabaseReference?) {
        if let story = data {
            Like.toggle(story)
        }
    }
    
    func storyDidShare(_ data: DatabaseReference?) {
        
        if let key = data?.key {
            let story = Story(key)
            
            story.fetchInBackground(completed: { (model, success) in
                
                // try to get image first
                var items: [Any] = [
                    "by \(story.userName)",
                ]
                
                if story.videoUrl != nil {
                    items.append(story.videoUrl)
                } else if let imageUrl = URL(string: story.media) {
                    items.append(imageUrl)
                }
            })
        }
    }
    
    func storyDidComment(_ data: DatabaseReference?) {
        self.performSegue(withIdentifier: "feed.comments", sender: data)
    }
    
    func openProfile(_ user: DatabaseReference?) {
        self.performSegue(withIdentifier: "show.profile", sender: user)
    }
    
    /* UserTableViewCellDelegate */
    
    func onStoryRemoved() {
        if let _ = singleStoryId {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func storyMenu(_ story: DatabaseReference?, position: NSInteger) {
        if let menuItem = tableViewItems[position] as? DataSnapshot {
            
            let menuController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let postedStory = Story(menuItem.key)
            
            postedStory.fetchInBackground { (model, success) in
                
                if !success {
                    let removeAction = UIAlertAction(title: "Remove the story", style: .destructive) { (action) in
                        // remove from my feed
                        Story.removeStory(menuItem.key)
                        self.onStoryRemoved()
                    }
                    menuController.addAction(removeAction)
                } else {
                    
                    // delete for own stories
                    if UserModel(postedStory.userId).isCurrent() {
                        let removeAction = UIAlertAction(title: "story.remove".localized, style: .destructive) { (action) in
                            // remove from my feed
                            if let snap = menuItem.ref.key {
                                Story.removeStory(snap)
                            }
                            self.onStoryRemoved()
                        }
                        menuController.addAction(removeAction)
                    }
                        // hide or report for others
                    else {
                        let reportAction = UIAlertAction(title: "report".localized, style: .destructive) { (action) in
                            // 1. remove from my feed
                            let snap = menuItem
                            snap.ref.removeAllObservers()
                            snap.ref.removeValue()
                            
                            let body = "Please remove the story with id: \(snap.key), as not appropriate."
                            
                            // 2. send email with report
                            if (MFMailComposeViewController.canSendMail()) {
                                let email = MFMailComposeViewController()
                                email.setSubject("Report a content")
                                email.setMessageBody(body, isHTML: false)
                                email.mailComposeDelegate = self
                                email.setToRecipients([kReportEmail])
                                self.present(email, animated: true, completion: nil)
                            } else {
                                let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
                                
                                if let mailurl = URL(string: "mailto:\(kReportEmail)?subject=\(encodedBody)") {
                                    UIApplication.shared.open(mailurl, options: [:], completionHandler: nil)
                                }
                                
                                self.onStoryRemoved()
                            }
                        }
                        
                        menuController.addAction(reportAction)
                        
                        let hideAction = UIAlertAction(title: "story.hide".localized, style: .default) { (action) in
                            // remove from my feed
                            let snap = menuItem
                            snap.ref.removeAllObservers()
                            snap.ref.removeValue()
                            self.onStoryRemoved()
                        }
                        menuController.addAction(hideAction)
                    }
                }
                
                let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil)
                menuController.addAction(cancelAction)
                
                if let popoverController = menuController.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                
                self.present(menuController, animated: true)
            }
        }
    }
}

extension FeedViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        self.onStoryRemoved()
    }
}

extension FeedViewController: UserTableViewCellDelegate {
    func loadRepliesViewTap(comment: DataSnapshot?) {
        
    }
    
    func refreshViewHeight() {
        fatalError()
    }
    
    func replyToComment(comment: DataSnapshot?) {
        fatalError()
    }
    func didSelected(ref: DatabaseReference) {
        self.performSegue(withIdentifier: "show.profile", sender: ref)
    }
    func didAction(ref: DatabaseReference?, position: NSInteger) {
        storyMenu(ref, position: position)
    }
}

extension FeedViewController: GADUnifiedNativeAdLoaderDelegate
{
    // MARK: - GADAdLoaderDelegate
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        print("Received native ad: \(nativeAd)")
        
        // Add the native ad to the list of native ads.
        nativeAds.append(nativeAd)
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        if singleStoryId == nil {
            addNativeAds()
        }
    }
    
    /// Add native ads to the tableViewItems list.
    func addNativeAds() {
        
        if nativeAds.count <= 0 {
            return
        }
        
        let adInterval = 6
        let expectedAdInterval = Int((tableViewItems.count/5)+2)
        if nativeAds.count < expectedAdInterval
        {
            for _ in 0...expectedAdInterval
            {
                if nativeAds.count >= expectedAdInterval
                {
                    break
                }
                else
                {
                    fillAdsArray(interval : expectedAdInterval)
                }
            }
        }
        var index = adInterval
        for nativeAd in nativeAds {
            if index < tableViewItems.count {
                tableViewItems.insert(nativeAd, at: index)
                index += adInterval
            } else {
                break
            }
        }
        self.tableView.reloadData()

    }
    
    func fillAdsArray(interval : Int) {
        for ad in nativeAds
        {
            nativeAds.append(ad)
            if nativeAds.count >= interval
            {
                break
            }
        }
    }
    
    
    func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
        guard let rating = starRating?.doubleValue else {
            return nil
        }
        if rating >= 5 {
            return UIImage(named: "stars_5")
        } else if rating >= 4.5 {
            return UIImage(named: "stars_4_5")
        } else if rating >= 4 {
            return UIImage(named: "stars_4")
        } else if rating >= 3.5 {
            return UIImage(named: "stars_3_5")
        } else {
            return nil
        }
    }
    
}


extension FeedViewController : GADVideoControllerDelegate {
    
    func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
        //videoStatusLabel.text = "Video playback has ended."
    }
}


// MARK: - GADUnifiedNativeAdDelegate implementation
extension FeedViewController : GADUnifiedNativeAdDelegate {
    
    func nativeAdDidRecordClick(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillLeaveApplication(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
}
