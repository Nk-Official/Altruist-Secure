//
//  ExploreViewController.swift
//  Mustage
//
//  Created by Oleg Baidalka on 15/03/2018.
//  Copyright © 2018 Bossly. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage
import AVFoundation

class ExploreViewController: UITableViewController, UISearchBarDelegate {
    
    var ranked: NSMutableArray = []
    var searchResults: NSMutableArray = []
    
    // MARK: - View cycle
    
    override func viewDidLoad() {
        self.clearsSelectionOnViewWillAppear = true
        self.tableView.estimatedRowHeight = 350
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        
        // add searchbar to find users to follow
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startObserveScrollingTop()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopObserveScrollingTop()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let profileCtrl = segue.destination as? ProfileViewController {
            if let user = sender as? DatabaseReference, let key = user.key {
                profileCtrl.currentUser = UserModel(key)
            }
        }
    }
    
    // MARK: - Data
    
    func loadData() {
        UserModel.collection
            .queryOrdered(byChild: "liked") // by likes count
            .queryLimited(toLast: 10) // only first 10 users
            .observeSingleEvent(of: .value, with: { (snapshot) in
                
                let results: NSMutableArray = []
                if let children = snapshot.children.allObjects as? [DataSnapshot] {
                    // reverse order of the items
                    for child in children {
                        results.insert(UserModel(child), at: 0)
                    }
                }

                self.ranked = results
                self.searchResults = results
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        UserModel.collection.queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            let results: NSMutableArray = []
            if let children = snapshot.children.allObjects as? [DataSnapshot] {
                
                for child in children {
                    if let value = child.value as? [String: Any], let name = value["name"] as? String {
                        if name.lowercased().contains(searchText.lowercased()) {
                            results.add(UserModel(child))
                        }
                    }
                }
            }
            
            if searchText.isEmpty {
                self.searchResults = self.ranked
            } else {
                self.searchResults = results
            }
            
            self.tableView.reloadData()
        })
    }
    
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        // reload data
        loadData()
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "User") as? UserTableViewCell
        cell?.profileRecognizer?.isEnabled = false // not allow to select profile
        
        if let userInfo = self.searchResults[indexPath.row] as? UserModel {
            cell?.userRef = userInfo.ref
        }
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let userInfo = self.searchResults[indexPath.row] as? UserModel {
            self.performSegue(withIdentifier: "show.profile", sender: userInfo.ref)
        }
    }
}
