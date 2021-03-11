//
//  HeadphoneTest.swift
//  Runner
//
//  Created by user on 07/04/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import AVKit
import UIKit
class HeadphoneTest: NSObject {
    
    var headPhoneTestResultCallback: ((Bool)->())?
    var timervaue = 0
    var timer : Timer?
    
    
    func startTest() {
        if isHeadphonesConnected(){
            headPhoneTestResultCallback?(true)
        }else{
            listenForNotifications()
        }
    }
    @objc func handleRouteChange(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let reasonRaw = userInfo[AVAudioSessionRouteChangeReasonKey] as? NSNumber,
            let reason = AVAudioSession.RouteChangeReason(rawValue: reasonRaw.uintValue)
            else {
                headPhoneTestResultCallback?(false)
                fatalError("Strange... could not get routeChange") }

        sendCallback()
    }

    func listenForNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRouteChange), name: AVAudioSession.routeChangeNotification, object: nil)
       
    }
    func sendCallback(){
        if isHeadphonesConnected() {
            headPhoneTestResultCallback?(true)
        }else{
            headPhoneTestResultCallback?(false)
        }
    }
    func isHeadphonesConnected()->Bool{
        let route = AVAudioSession.sharedInstance().currentRoute
        return !route.outputs.filter{$0.portType == AVAudioSession.Port.headphones}.isEmpty
    }
    //https://developer.apple.com/documentation/avfoundation/avaudiosessionportdescription/output_port_types
    
    func setTimer(){
        
        Timer.scheduledTimer(withTimeInterval: 10, repeats: false
        , block: { (_) in
            self.headPhoneTestResultCallback?(true)
        })
        
        
    }
    
}


extension UIViewController{
    
    func showAlert(result: Bool){
        
        let alert = UIAlertController(title: "alert", message: "headphone result \(result)", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
    func showAlert(title: String?, message: String,action:(()->())?=nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            action?()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
