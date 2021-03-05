//
//  NotificationClient.swift
//  Mustage
//
//  Created by Oleg Baidalka on 09/03/2018.
//  Copyright © 2018 Bossly. All rights reserved.
//

import UIKit
import UserNotifications
import FirebaseMessaging
import Firebase

protocol NotificationClient {
    func setupNotification()
}

// register Push Notification
extension NotificationClient {
    
    func setupNotification() {
        let application = UIApplication.shared
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound],
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            if let appDelegate = application.delegate as? AppDelegate {
                UNUserNotificationCenter.current().delegate = appDelegate
                Messaging.messaging().delegate = appDelegate
            }
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
}

// handle Push Notification
extension AppDelegate {
    
    func messageReceived(_ userInfo: [AnyHashable: Any]) {
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        print("%@", userInfo)
        
        guard
            let type = userInfo["type"] as? String,
            let id = userInfo["id"] as? String else { return }
        
        switch type {
        case "story":
            if window?.rootViewController?.navigationController?.visibleViewController is FeedViewController {
                return
            }
            let storyboard = UIStoryboard(name: "Story", bundle: Bundle.main)
            if let controller = storyboard.instantiateInitialViewController() as? FeedViewController {
                controller.singleStoryId = id
                navigateTo(controller)
            }
            
        case "comment":
            if window?.rootViewController?.navigationController?.visibleViewController is CommentsTableViewController {
                return
            }
            let storyboard = UIStoryboard(name: "Story", bundle: Bundle.main)
            if let controller = storyboard.instantiateViewController(withIdentifier: "comments") as? CommentsTableViewController {
                controller.storyId = id
                navigateTo(controller)
            }
        case "chat":
            if let topController = UIApplication.topViewController()
            {
                debugPrint(topController)
                if let recentsViewController = topController as? RecentsViewController
                {
                    recentsViewController.moveToChat(key: id)
                }else
                {
                    if let tabController = self.window?.rootViewController as? DashboardController
                    {
                        let state = UIApplication.shared.applicationState
                        if state != .active {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                tabController.setSelectedIndex(index : 3)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    if let topController = UIApplication.topViewController() as? RecentsViewController
                                    {
                                        topController.moveToChat(key: id)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        default:
            return
        }
    }
    
    func navigateTo(_ controller: UIViewController) {
        // wait when application is opened
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let topController = UIApplication.topViewController()
            {
                topController.navigationController?.pushViewController(controller, animated: true)
            }
            //            let rootController = self.window?.rootViewController as? UINavigationController
            //            let tabController = rootController?.viewControllers.last as? UITabBarController
            //            let navigation = tabController?.selectedViewController as? UINavigationController
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("token == \(token)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        messageReceived(userInfo)
    }
}

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate,MessagingDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        messageReceived(userInfo)
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("fcmToken == \(fcmToken)")
    }
}
