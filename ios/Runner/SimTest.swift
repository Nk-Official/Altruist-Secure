//
//  TestKeys.swift
//  Runner
//
//  Created by user on 19/03/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//


import CoreTelephony


class SimTest{
    var info = CTTelephonyNetworkInfo()
    
    func isSimAvailable()  -> Bool {
        var simState: Bool = false
        if #available(iOS 12, *){
            if let carrier = info.serviceSubscriberCellularProviders, carrier.count>0{
                for (_, value) in carrier{
                    if value.mobileCountryCode != nil{
                        simState = true
                        return true
                    }else if value.mobileNetworkCode != nil{
                        simState = true
                        return true
                    }
                }
            }
        }else{
            if let carrier = info.subscriberCellularProvider{
                if carrier.mobileNetworkCode != nil{
                    simState = true
                    return true
                }
            }
        }
        return simState
    }
}
