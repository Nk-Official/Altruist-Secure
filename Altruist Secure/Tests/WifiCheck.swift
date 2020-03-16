//
//  WifiCheck.swift
//  Altruist Secure
//
//  Created by Namrata Khanduri on 16/03/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
// https://www.progressioapps.com/get-wifi-information-on-ios-with-swift/

import SystemConfiguration.CaptiveNetwork
class WifiCheck {
    func checkWifi() ->Bool {
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
}
