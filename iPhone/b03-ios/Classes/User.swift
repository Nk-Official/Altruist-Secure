//
//  User.swift
//  Project
//
//  Created by Bossly on 10/13/16.
//  Copyright © 2016 Bossly. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UserModel: ModelBase {

    private static var _current: UserModel?
    
    static var collection: DatabaseReference {
        return Database.database().reference().child(kUsersKey)
    }
    
    static var current: UserModel? {
        if let auth = Auth.auth().currentUser {
            if _current == nil || auth.uid != _current!.ref.key {
                _current = UserModel(auth.uid)
                _current?.fetchInBackground(completed: { (model, success) in
                })
            }
            
            return _current
        } else {
            return nil
        }
    }

    private var _isFollowed: Bool = false
    
    var name: String = kDefaultUsername
    var photo: String = kDefaultProfilePhoto
    var backgroundPhoto: String = ""
    var bio: String = ""
    var token: String?
    var followersCount: UInt = 0
    var followingsCount: UInt = 0
    var postsCount: UInt = 0
    var blockedUsers: [String: Bool] = [:]
    var isFollow: Bool {
        return _isFollowed
    }
    
    // stories I posted
    var feed: DatabaseReference {
        return Database.database().reference().child("\(kUserFeedKey)/\(self.ref.key!)")
    }
    
    var uploads: DatabaseReference {
        return Database.database().reference().child("\(kUploadsKey)/\(self.ref.key!)")
    }

    // posts I liked
    var favorites: DatabaseReference {
        return Database.database().reference().child("\(kDataFavoritesKey)/\(self.ref.key!)")
    }

    // followers - people who follow me
    var followers: DatabaseReference {
        return self.ref.child(kFollowersKey)
    }

    // followigns - people followed by me
    var followings: DatabaseReference {
        return self.ref.child(kFollowinsKey)
    }
    
    func isUnique(username: String, completion: @escaping (Bool) -> Void) {
        UserModel.collection
            .queryOrdered(byChild: "name") // by likes count
            .queryEqual(toValue: username)
            .queryLimited(toLast: 2) // only first user
            .observeSingleEvent(of: .value) { snapshot in
                
                let children = snapshot.children.allObjects as? [DataSnapshot]
                let unique = (children?.first { $0.key != self.snapshot?.key } != nil)
                completion(unique)
        }
    }
    
    func follow() {
        if let current = UserModel.current, self.ref.key != current.ref.key,
            let key = self.ref.key, let currentKey = current.ref.key {
            current.followings.child(key).setValue("true")
            self.followers.child(currentKey).setValue("true")
            _isFollowed = true
            
            fetchInBackground(completed: { (model, success) in
                // update data
            })
        }
    }
    
    func unfollow() {
        if let current = UserModel.current, self.ref.key != current.ref.key,
            let key = self.ref.key, let currentKey = current.ref.key {
            current.followings.child(key).removeValue()
            self.followers.child(currentKey).removeValue()
            _isFollowed = false

            fetchInBackground(completed: { (model, success) in
                // update data
            })
        }
    }
    
    func blockedMe() -> Bool {
        if let current = UserModel.current, !isCurrent() {
            return self.hasBlocked(user: current)
        } else {
            return false
        }
    }
    
    func hasBlocked(user: UserModel) -> Bool {
        if let key = user.ref.key {
            return self.blockedUsers[key] ?? false
        } else {
            return false
        }
    }

    func block(user: UserModel, value: Bool = true) {
        guard let userKey = user.ref.key,
            userKey != self.ref.key else { return }
        
        self.ref.child(kBlockedKey).child(userKey).setValue(value)
        self.blockedUsers[userKey] = value
    }

    func isCurrent() -> Bool {
        if let current = UserModel.current, self.ref.key != current.ref.key {
            return false
        } else {
            return true
        }
    }

    override func parent() -> DatabaseReference {
        return UserModel.collection
    }
    
    override func loadData(snap: DataSnapshot, with complete: @escaping (Bool) -> Void) {
        if let value = snap.value as? [String: Any] {
            self.name = value["name"] as? String ?? kDefaultUsername
            self.photo = value["photo"] as? String ?? kDefaultProfilePhoto
            self.backgroundPhoto = value["backgroundPhoto"] as? String ?? ""
            self.bio = value["bio"] as? String ?? ""

            self.blockedUsers = value[kBlockedKey] as? [String: Bool] ?? [:]
            let followers = value[kFollowersKey] as? [String: Any]
            let current = UserModel.current!.ref.key
            _isFollowed = followers?.first { $0.key == current } != nil
            
            complete(true)
        } else {
            complete(false)
        }
    }
    
    func saveData() {
        self.ref.updateChildValues(["name": self.name,
                                    "bio": self.bio,
                                    "photo": self.photo,"backgroundPhoto": self.backgroundPhoto ])
    }
    
    func save(_ token: String) {
        guard let deviceUid = UIDevice.current.identifierForVendor?.uuidString else {
            return
        }
        
        self.ref.child(kTokensKey).child(deviceUid).setValue(token)
    }
}
