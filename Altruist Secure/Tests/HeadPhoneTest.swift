//
//  HeadPhoneTest.swift
//  Altruist Secure
//
//  Created by Namrata Khanduri on 13/03/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//
import AVFoundation

class HeadPhoneTest : DeviceTester{
    
    
    var headPhoneFoundCallback: Closure?
    var headPhoneNotFoundCallback: Closure?

    
    func startTest(_ viewController: UIViewController) {
        if isHeadphonesConnected(){
            headPhoneFoundCallback?()
        }else{
            listenForNotifications()
        }
    }
    @objc func handleRouteChange(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let reasonRaw = userInfo[AVAudioSessionRouteChangeReasonKey] as? NSNumber,
            let reason = AVAudioSession.RouteChangeReason(rawValue: reasonRaw.uintValue)
            else { fatalError("Strange... could not get routeChange") }
        switch reason {
        case .oldDeviceUnavailable:
            print("oldDeviceUnavailable")
        case .newDeviceAvailable:
            print("newDeviceAvailable")
            if isHeadphonesConnected() {
                headPhoneFoundCallback?()
            }else{
                headPhoneNotFoundCallback?()
            }
        case .routeConfigurationChange:
            print("routeConfigurationChange")
        case .categoryChange:
            print("categoryChange")
        default:
            print("not handling reason")
        }
    }

    func listenForNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRouteChange), name: AVAudioSession.routeChangeNotification, object: nil)
       
    }
    func isHeadphonesConnected()->Bool{
        let route = AVAudioSession.sharedInstance().currentRoute
        return !route.outputs.filter{$0.portType == AVAudioSession.Port.headphones}.isEmpty
    }
}
