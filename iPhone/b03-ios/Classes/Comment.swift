//
//  Comment.swift
//
//  Created by Bossly on 9/11/16.
//  Copyright © 2016 Bossly. All rights reserved.
//

import UIKit
import Firebase

class Comment: ModelBase {

    static var collection: DatabaseReference {
        return Database.database().reference().child(kDataCommentKey)
    }
    
    static func sendComment(_ comment: String!, storyKey: String!) {
        
        let commentsRef: DatabaseReference = Comment.collection.child(storyKey)
        
        if let user = UserModel.current, let userId = user.ref.key,
            let key = commentsRef.childByAutoId().key {
            let username: String = user.name
            let profilePhoto = user.photo
            
            let post: [String: Any] = ["message": comment,
                                     "profile_id": userId,
                                     "profile_name": username,
                                     "profile_image": profilePhoto, ]
            
            let commentValues: [String: Any] = ["/\(key)": post]
            commentsRef.updateChildValues(commentValues)
        }
    }
    
    static func remove(_ uid: String) {
        Comment(uid).fetchInBackground { (data, success) in
            if success {
                data.ref.removeAllObservers()
                data.ref.removeValue()
            }
        }
    }

    override func parent() -> DatabaseReference {
        return Comment.collection
    }

    override func loadData(snap: DataSnapshot, with complete: @escaping (Bool) -> Void) {
        // do nothing
    }
}


extension Comment{
    static func sendReply(messgae: String, toComment key: String, ofstory id: String){
        let commentsRef: DatabaseReference = Comment.collection.child(id).child(key)
        let repliesRef: DatabaseReference = commentsRef.child(kDataReplyKey)
        print("comment refrence", commentsRef)
        if let user = UserModel.current, let userId = user.ref.key,
            let key = repliesRef.childByAutoId().key {
            
            
            let username: String = user.name
            let profilePhoto = user.photo
            
            let post: [String: Any] = ["message": messgae,
                                     "profile_id": userId,
                                     "profile_name": username,
                                     "profile_image": profilePhoto, ]
            
            let commentValues: [String: Any] = ["/\(key)": post]
            repliesRef.updateChildValues(commentValues)
        }

    }
}
