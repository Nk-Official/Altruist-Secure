//
//  Story.swift
//
//  Created by Bossly on 9/11/16.
//  Copyright © 2016 Bossly. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class Story: ModelBase {

    static var recents: DatabaseReference {
        return Database.database().reference().child(kDataRecentsKey)
    }

    static var collection: DatabaseReference {
        return Database.database().reference().child(kDataPostKey)
    }
    
    static func createStory(_ user: User, url: String, video: String, multiple: [String], comment: String? = nil) {
        
        // Create a reference to the file you want to upload
        let uid = user.uid
        let curUser = UserModel(uid)

        curUser.fetchInBackground { (model, success) in
            
            let post = ["user": uid,"image": url,"multipleImage": multiple,"video": video,"message": comment ?? "", ] as [String : Any]
            debugPrint(post)
            // add to post collection
            let ref = Story.collection
            
            if let key = ref.childByAutoId().key {
                ref.updateChildValues(["/\(key)": post])

                // add comment
                if comment?.isEmpty == false {
                    Comment.sendComment(comment, storyKey: key)
                }
            }
        }
    }
    
    static func removeStory(_ uid: String) {
        Story(uid).fetchInBackground { (data, success) in
            if success, let story = data as? Story {
                let user = UserModel(story.userId)
                story.ref.removeAllObservers()
                story.ref.removeValue()
                
                user.feed.child(uid).removeValue()
                user.uploads.child(uid).removeValue()

                user.followers.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let children = snapshot.children.allObjects as? [DataSnapshot] {
                        for item in children {
                            UserModel(item.key).feed.child(uid).removeValue()
                        }
                    }
                })
            } else { // just remove it because refs are broken
                Story(uid).ref.removeValue()
                UserModel.current?.uploads.child(uid).removeValue()
                UserModel.current?.feed.child(uid).removeValue()
            }
        }
    }
    
    // MARK: - Model
    var userRef: DatabaseReference?
    
    var time: Date?
    var media: String = ""
    var userId: String = ""
    var videoUrl: URL! = nil
    var multipleImage = [String]()

    var userName: String = kDefaultUsername
    var userPhoto: String = kDefaultProfilePhoto

    override func parent() -> DatabaseReference {
        return Story.collection
    }
    
    override func loadData(snap: DataSnapshot, with complete:@escaping (Bool) -> Void) {
        
        if let value = snap.value as? [String: Any],
            let id = value["user"] as? String {
            
            if let imageArr = value["multipleImage"] as? [String]
            {
                for item in imageArr
                {
                    self.multipleImage.append(item)
                }
            }
            
            self.media = value["image"] as? String ?? ""
            self.userId = id
            
            if let time = value["created"] as? TimeInterval {
                self.time = Date(timeIntervalSince1970: time/1000)
            }
            
            if let videoAbsolute = value["video"] as? String {
                if videoAbsolute.count > 0 {
                    self.videoUrl = URL(string: videoAbsolute)
                }
            }
            
            // remove previous observers
            userRef?.removeAllObservers()
            
            // add new observer
            userRef = UserModel.collection.child(self.userId)
            userRef?.keepSynced(true)

            // update user_info and update in realtime
            userRef?.observe(.value, with: { (snap) in
                let user = UserModel(snap)
                self.userName = user.name
                self.userPhoto = user.photo

                complete(true)
            })

        } else {
            complete(false)
        }
    }
    
    deinit {
        userRef?.removeAllObservers()
    }
}
