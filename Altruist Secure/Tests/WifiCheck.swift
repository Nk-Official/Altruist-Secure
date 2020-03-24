//
//  WifiCheck.swift
//  Altruist Secure
//
//  Created by Namrata Khanduri on 16/03/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
// https://www.progressioapps.com/get-wifi-information-on-ios-with-swift/

import SystemConfiguration
import NetworkExtension

class WifiCheck {
    func checkWifi() ->Bool {
//        var avalableWifi = false
//        guard let interfaces = CNCopySupportedInterfaces() as? [CFString] else{return avalableWifi}
//
//        for interface in interfaces{
//            guard let interfaceInfo = CNCopyCurrentNetworkInfo(interface) as NSDictionary?  else{
//                continue
//            }
//
//            guard let ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String else {
//               continue
//            }
//            guard let bssid = interfaceInfo[kCNNetworkInfoKeyBSSID as String] as? String else {
//                continue
//            }
//            print("interface Information",ssid,bssid)
//            avalableWifi = true
//            break
//        }
//        return avalableWifi
        
//        var ssid: String?
//        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
//        for interface in interfaces {
//        if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
//                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
//                    break
//                }
//            }
//        }
//        print(ssid)
//        return false
        
//        var address : String?
//        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
//        if getifaddrs(&ifaddr) == 0 {
//            var ptr = ifaddr
//            while ptr != nil {
//                defer { ptr = ptr!.pointee.ifa_next }
//                let interface = ptr!.pointee
//                let addrFamily = interface.ifa_addr.move().sa_family
//                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
//                     let name = String(cString: interface.ifa_name)
//                    if name == "awdl0" {
//                        if((Int32(interface.ifa_flags) & IFF_UP) == IFF_UP) {
//                            return(true)
//                        }
//                        else {
//                            return(false)
//                        }
//                    }
//                }
//            }
//            freeifaddrs(ifaddr)
//        }
//        return (false)
        
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
            print("connected through wifi")
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return (isReachable && !needsConnection)
        
        return true
    }
}
