//
//  DashboardController.swift
//  Mustage
//
//  Created by Oleg Baidalka on 16/03/2018.
//  Copyright © 2018 Bossly. All rights reserved.
//

import UIKit
import Firebase

class DashboardController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        if #available(iOS 13.0, *) {
        //            overrideUserInterfaceStyle = .dark
        //        } else {
        //            // Fallback on earlier versions
        //        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // subcribe for badge updates
        UserModel.current?.ref.observe(.value, with: { (data) in
            // update unread count
            if data.exists(), let number = data.values?["unread"] as? Int {
                self.updateBadge("\(number)")
                UIApplication.shared.applicationIconBadgeNumber = number
            } else {
                self.updateBadge(nil)
            }
        })
    }
    
    func updateBadge(_ badge: String?) {
        
        // update unread count
        if let tabItem = self.tabBar.items?.first(where: {(item) -> Bool in
            return item.tag == 1
        }), tabItem != tabBar.selectedItem { // and not currently selected
            tabItem.badgeValue = badge
        }
    }
    
    func setSelectedIndex(index : Int)
    {
        self.selectedIndex = index
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserModel.current?.ref.removeAllObservers()
    }
}
