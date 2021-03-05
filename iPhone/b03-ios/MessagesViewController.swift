//
//  ChatViewController.swift
//  Mustage
//
//  Created by Oleg Baidalka on 14/03/2017.
//  Copyright © 2017 Oleg Baidalka. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class MessagesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!

    var dataSource: FUITableViewDataSource?
    var messagesRef: DatabaseReference? {
        didSet {
            loadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0; // set to whatever your "average" cell height is
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // subscribe for Keyboard move
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keyboardWillShow),
                       name: .UIKeyboardWillChangeFrame, object: nil)

        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // unsubscribe for Keyboard move
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    // MARK: - Helper methods
    
    @objc func keyboardWillShow(_ notification: Notification) {
        self.tableView.scrollBottom()
        
        UIView.animate(withDuration: notification.keyboardDuration(), animations: {
            self.view.layoutSubviews()
        })
    }
    
    func loadData() {
        if let ref = self.messagesRef, self.tableView != nil, self.dataSource == nil {
            ref.observe(.childAdded) { (snap) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                    self.tableView.scrollBottom()
                })
            }
            
            self.dataSource = self.tableView.bind(to: ref.queryOrdered(byChild: "unread"), populateCell: {
                (tableView, indexPath, message) -> UITableViewCell in
                
                let identifier = self.cellIdentifier(message)
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MessageTableViewCell else {
                    return UITableViewCell()
                }
                cell.showMessage(message)
                cell.profileView?.addTapGestureRecognizer {
                    cell.profileView?.enlargeImage(view: self)
                }
                return cell
            })
        }
    }
    
    func cellIdentifier(_ message: DataSnapshot) -> String {
        var identifier: String = "me"
        
        if let user = message.stringValue("user_id"), let current = Auth.currentID {
            if user != current {
                identifier = "other"
            }
        }
        
        return identifier
    }
    
}

extension FUITableViewDataSource {
    
    var animation: UITableViewRowAnimation {
        return Settings.tableViewAnimation
    }
    
    open func array(_ array: FUIArray!, didAdd object: Any!, at index: UInt) {
        self.tableView?.insertRows(at: [IndexPath(row: Int(index), section: 0)], with: animation)
        self.tableView?.scrollBottom()
    }
    
    open func array(_ array: FUIArray!, didChange object: Any!, at index: UInt) {
        self.tableView?.reloadRows(at: [IndexPath(row: Int(index), section: 0)], with: animation)
    }
    
    open func array(_ array: FUIArray!, didRemove object: Any!, at index: UInt) {
        self.tableView?.deleteRows(at: [IndexPath(row: Int(index), section: 0)], with: animation)
    }

    open func array(_ array: FUIArray!, didMove object: Any!, from fromIndex: UInt, to toIndex: UInt) {
        self.tableView?.moveRow(at: IndexPath(row: Int(fromIndex), section: 0), to: IndexPath(row: Int(toIndex), section: 0))
    }
}
