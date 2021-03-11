//
//  LocalNotification.swift
//  WebViewLinkGenerator
//
//  Created by user on 18/08/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
// https://medium.com/quick-code/local-notifications-with-swift-4-b32e7ad93c2

import Foundation
import UserNotifications

class LocalNotification: NSObject{
    
    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    func registerForNotification(){
        notificationCenter.requestAuthorization(options: options) { (didAllow, error) in
            if !didAllow{
                print("please enable notifications for ths app in settings")
            }
        }
//        The user can change the notification center settings of your application at any time. You can track these settings with the appropriate getNotificationSettings.
        notificationCenter.getNotificationSettings { (settings) in
          if settings.authorizationStatus != .authorized {
            // Notifications not allowed
          }
        }
        
        notificationCenter.delegate = self
    }
    
    func scheduleNotification(notificationType: String) {
        
        let content = UNMutableNotificationContent()
        
        content.title = notificationType
        content.body = "This is example how to create " + "notificationType Notifications"
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
}


extension LocalNotification: UNUserNotificationCenterDelegate{
    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.

        completionHandler([.alert, .badge, .sound]) 
    }
}
