//
//  Like.swift
//
//  Created by Bossly on 9/14/16.
//  Copyright © 2016 Bossly. All rights reserved.
//

import UIKit
import Firebase

class Like: ModelBase {
    
    static var collection: DatabaseReference {
        return Database.database().reference().child(kDataLikeKey)
    }
    
    static func story(_ story: DatabaseReference!) {
        let likesRef = Like.collection
        
        if let key = story.key, let userid = Auth.auth().currentUser?.uid {
            let likeRef = likesRef.child("\(key)/\(userid)")
            
            likeRef.updateChildValues(["liked": true])
            
            // store what I like
            UserModel(userid).favorites.child(key).setValue(true)
        }
    }
    
    static func toggle(_ story: DatabaseReference!) {
        let likesRef = Like.collection
        
        if let key = story.key, let userid = Auth.auth().currentUser?.uid {
            let likeRef = likesRef.child("\(key)/\(userid)")
            
            likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    likeRef.removeValue()
                    UserModel(userid).favorites.child(key).removeValue()
                } else {
                    likeRef.updateChildValues(["liked": true])
                    UserModel(userid).favorites.child(key).setValue(true)
                }
            })
        }
    }
    
    override func parent() -> DatabaseReference {
        return Like.collection
    }
    
    override func loadData(snap: DataSnapshot, with complete: @escaping (Bool) -> Void) {
        
    }    
}
