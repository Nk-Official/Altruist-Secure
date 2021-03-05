//
//  Config.swift
//
//  Created by 01eg.me on 9/14/16.
//  Copyright © 2016 01eg.me. All rights reserved.

import AVFoundation
import UIKit
import Firebase

/*
 The video is allowed in feed, but it shows a video player (if the first picture is black
 you will see black. Please use the autoplay (true) to play video on scrolling. The video will
 be streamed from server (not downloaded) so it used less network while scrolling.
 */
let kAutoplayVideo = true

/*
 Scale of video, you can choose one of these recommended:
 AVLayerVideoGravityResizeAspectFill - resize to fill the square
 AVLayerVideoGravityResizeAspect - resize to fit the square
 */
let kVideoScale = AVLayerVideoGravity.resizeAspectFill

extension UIColor {
    static var primary = UIColor(named: "primary") ?? .purple
    static var secondary = UIColor(named: "secondary") ?? .white
}

let kJPEGImageQuality: CGFloat = 0.6 // between 0..1
let kPagination: UInt = 1000
let kMaxConcurrentImageDownloads = 2 // the count of images donloading at the same time

let kLikeTapCount = 2 // you can like the photo by double tap on. number of taps
let kLikeTapAnimationDuration: TimeInterval = 0.3 // seconds
let kLikeTapAnimationScale: CGFloat = 3.0 // the max scale of heart to animate in seconds

let kPhotoShadowRadius: CGFloat = 10.0 // all photos has inner shadow on top and bottom
let kPhotoShadowColor: UIColor = UIColor(white: 0, alpha: 0.1)
let kProfilePhotoSize: CGFloat = 100 // px

let kCommentFontSize: CGFloat = 13.0 // points
let kFavoritesColumns: CGFloat = 3
let kDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

// MARK: Database
/*
 Change this values to set another firebase key path.
 Must be a non-empty string and not contain '.' '#' '$' '[' or ']'
 */

let kUserFeedKey = "user_feed"
let kUsersKey = "users"
let kTokensKey = "tokens"
let kUploadsKey = "uploads"
let kBlockedKey = "blocked"
let kFollowersKey = "followers"
let kFollowinsKey = "followings"
let kDataRecentsKey = "recents"
let kDataPostKey = "posts"
let kDataCommentKey = "comments"
let kDataReplyKey = "Replies"
let kDataLikeKey = "likes"
let kDataFavoritesKey = "activity"
let kTopicFeed = "topic"
let kDataChatsKey = "chats"
let kDataMessagesKey = "messages"

// MARK: Strings
/*
 Localized text displayed to User
 */

let kDefaultProfilePhoto = "avatarPlaceholder" // url to default photo. will be stored in database
let kAlertErrorTitle = NSLocalizedString("Error", comment: "")
let kAlertErrorDefaultButton = NSLocalizedString("OK", comment: "")

let kMessageUploadingDone = NSLocalizedString("Done!", comment: "")
// example: Uploading: 12% (percentage will be added)
let kMessageUploadingProcess = NSLocalizedString("Uploading", comment: "")

let kImageExtensions = ["JPG","PNG","GIF","WEBP","TIFF","PSD","RAW","BMP","HEIF","INDD","JPEG","SVG","EPS","PDF"]

class Settings {
    static var tableViewAnimation: UITableViewRowAnimation = .automatic
}

extension DataSnapshot {
    var values: [String: Any]? {
        return self.value as? [String: Any]
    }
    
    func stringValue(_ name: String) -> String? {
        return self.values?[name] as? String
    }

    func intValue(_ name: String) -> Int? {
        return self.values?[name] as? Int
    }
}

extension Auth {
    static var currentID: String? {
        return Auth.auth().currentUser?.uid
    }
}
