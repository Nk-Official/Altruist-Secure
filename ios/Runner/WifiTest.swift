//
//  WifiTest.swift
//  Runner
//
//  Created by user on 20/03/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.


import Foundation
import SystemConfiguration.CaptiveNetwork

class WifiTest {
    
    //MARK: - PROPERTIES
    var timerCount = 0
    var timer: Timer?
    var wifiCallbackResult: ((Bool)->())?
    
    //MARK: - START
    func start() {
        setTimer()
        addObserver()
    }
    
    //MARK: - METHODS
    func onTheWifiSettings()->Bool{
        if let url = URL(string:"App-Prefs:root=WIFI") {
          if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
              UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
              UIApplication.shared.openURL(url)
            }
            return true
          }
        }
        return false
    }
    
    func checkWifi() ->Bool {
        // below code not work for iOS 13
        var avalableWifi = false
        guard let interfaces = CNCopySupportedInterfaces() as? [CFString] else{return avalableWifi}
        
        for interface in interfaces{
            guard let interfaceInfo = CNCopyCurrentNetworkInfo(interface) as NSDictionary?  else{
                continue
            }
            
            guard let ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String else {
               continue
            }
            guard let bssid = interfaceInfo[kCNNetworkInfoKeyBSSID as String] as? String else {
                continue
            }
            print("interface Information",ssid,bssid)
            avalableWifi = true
            break
        }
        return avalableWifi
    }
    
    func checkInternetWorkingThroghWifi()->Bool{
        //  MARK: - WORKING
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        if flags.isEmpty {
            return false
        }

        if !flags.contains(.isWWAN){
            print("wifi connected")
            return true
        }else{
            print("wifi not connected")
            return false
        }
    }
    
    //MARK: - TIMER
    func setTimer(){
        timer?.invalidate()
        timerCount = 0
        print("timer start")
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
            self?.timerCount += 1
            if self?.timerCount == 15{
                if !(self?.checkConnection() ?? false){
                    self?.wifiCallbackResult?(false)
                    self?.wifiCallbackResult = nil
                    timer.invalidate()
                    self?.removeObserver()
                }
            }else{
                self?.checkConnection()
            }
        }
        
    }
    
    @discardableResult
    func checkConnection()->Bool{
        
        
        if checkInternetWorkingThroghWifi(){
            timer?.invalidate()
            wifiCallbackResult?(true)
            wifiCallbackResult = nil
            removeObserver()
            return true
        }
        return false
    }
    
}


extension WifiTest{
    
    
    func addObserver(){
        NotificationCenter.default.addObserver(self,selector: #selector(notificationAppBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(notificationAppResignActive), name: UIApplication.willResignActiveNotification, object: nil)

    }
    func removeObserver(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }
    @objc func notificationAppBecomeActive(_ notification: Notification){
       print("app become active again")
        setTimer()
    }
    @objc func notificationAppResignActive(_ notification: Notification){
        timer?.invalidate()
        print("app become resign active")

    }
    
}
