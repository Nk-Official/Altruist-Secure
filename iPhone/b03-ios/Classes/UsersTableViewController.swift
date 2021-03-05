//
//  UsersTableViewController.swift
//  Mustage
//
//  Created by Oleg Baidalka on 09/05/2019.
//  Copyright © 2019 Bossly. All rights reserved.
//

import UIKit
import Firebase

class UsersTableViewController: UITableViewController {
    
    var users: NSMutableArray = []
    var query: DatabaseQuery?
    
    // MARK: - View cycle
    
    override func viewDidLoad() {
        self.clearsSelectionOnViewWillAppear = true
        self.tableView.estimatedRowHeight = 350
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let profileCtrl = segue.destination as? ProfileViewController {
            if let user = sender as? DatabaseReference, let userKey = user.key {
                profileCtrl.currentUser = UserModel(userKey)
            }
        }
    }
    
    // MARK: - Data
    
    func loadData() {
        query?.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let results: NSMutableArray = []
            guard let children = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            // reverse order of the items
            for child in children {
                results.insert(UserModel(child.key), at: 0)
            }
            
            self.users = results
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "User") as? UserTableViewCell else {
            return UITableViewCell()
        }
        cell.profileRecognizer?.isEnabled = false // not allow to select profile
        
        if let userInfo = self.users[indexPath.row] as? UserModel {
            cell.userRef = userInfo.ref
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let userInfo = self.users[indexPath.row] as? UserModel {
            self.performSegue(withIdentifier: "show.profile", sender: userInfo.ref)
        }
    }
    
}
