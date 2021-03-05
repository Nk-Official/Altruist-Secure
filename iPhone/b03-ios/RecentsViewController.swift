//
//  SecondViewController.swift
//  Mustage
//
//  Created by Oleg Baidalka on 13/03/2017.
//  Copyright © 2017 Oleg Baidalka. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class RecentsViewController: UITableViewController {
    
    var dataSource: FUITableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let current = Auth.currentID {
            let ref = Database.database().reference(withPath: kDataChatsKey).child(current)
            
            let array = FUISortedArray(query: ref, delegate: nil) { (snap1, snap2) -> ComparisonResult in
                let upd1 = snap1.intValue("updated") ?? 0
                let upd2 = snap2.intValue("updated") ?? 0
                
                if upd1 > upd2 {
                    return .orderedAscending
                } else if upd1 < upd2 {
                    return .orderedDescending
                } else {
                    return .orderedSame
                }
            }
            
            dataSource = FUITableViewDataSource(collection: array, populateCell: { (tableView, indexPath, chat) -> UITableViewCell in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ChatTableViewCell else {
                    return UITableViewCell()
                }
                cell.chat = chat.ref
                cell.profileView?.addTapGestureRecognizer {
                    cell.profileView?.enlargeImage(view: self)
                }
                return cell
            })
            
            dataSource?.bind(to: self.tableView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserModel.current?.ref.child("unread").removeValue()
        // reset unread count
        self.navigationController?.tabBarItem.badgeValue = nil
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chatController = segue.destination as? ChatViewController,
            let selectedIndex = self.tableView.indexPathForSelectedRow {
            let ref = self.dataSource?.items[selectedIndex.row].ref
            chatController.chatRef = ref
        }
    }
    
    func moveToChat(key :String) {
        if self.dataSource?.items.count ?? 0 > 0
        {
            for user in self.dataSource!.items
            {
                if user.ref.key == key
                {
                    guard let chatController = UIStoryboard(name: "Messages", bundle: nil).instantiateViewController(withIdentifier: "messages.list") as? ChatViewController else {
                        return
                    }
                    chatController.chatRef = user.ref
                    self.navigationController?.pushViewController(chatController, animated: true)
                    break
                }
            }
        }
    }
}
