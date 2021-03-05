//
//  CustomUITabbar.swift
//  Mustage
//
//  Created by Oleg Baidalka on 27/09/2017.
//  Copyright © 2017 Bossly. All rights reserved.
//

import UIKit

class CustomUITabBar: UITabBar, UITabBarControllerDelegate {
    
    static let scrollToTopNotification = Notification.Name("CustomUITabBar.scrollToTop")
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if tabBarController.selectedViewController == viewController {
            // scroll to top
            NotificationCenter.default.post(name: CustomUITabBar.scrollToTopNotification, object: nil)
        }
        
        if viewController is CreateViewController {
            // modal storyboard
            let storyboard = UIStoryboard(name: "Create", bundle: Bundle.main)
            
            if let controller = storyboard.instantiateInitialViewController() {
                tabBarController.present(controller, animated: true, completion: {})
            }
            return false
        }
        
        return true
    }
    
    // TODO: uncomment if you wanna change tabbar height, default = 60
//    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        let sizeThatFits = super.sizeThatFits(size)
//        return CGSize(width: sizeThatFits.width, height: 40) // <- TabBar Height in px
//    }
}

extension UITableViewController {
    
    // when view loaded
    func startObserveScrollingTop() {
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTop), name: CustomUITabBar.scrollToTopNotification, object: nil)
    }
    
    func stopObserveScrollingTop() {
        NotificationCenter.default.removeObserver(self, name: CustomUITabBar.scrollToTopNotification, object: nil)
    }
    
    // if need to scroll
    @objc func scrollToTop(notification: NSNotification) {
        if self.numberOfSections(in: self.tableView) > 0 &&
            self.tableView(self.tableView, numberOfRowsInSection: 0) > 0 {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
}
