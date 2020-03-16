//
//  SimTest.swift
//  Altruist Secure
//
//  Created by Namrata Khanduri on 16/03/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import CoreTelephony


class SimTest{
     var info = CTTelephonyNetworkInfo()
    func isSimAvailable()  -> Bool {
        var isSimCardAvailable = false
       
        if #available(iOS 12, *){
            if let carrier = info.serviceSubscriberCellularProviders, carrier.count>0{
                if let firstCarrier = carrier.first?.value, firstCarrier.mobileNetworkCode != nil{// have sim card or not
                    isSimCardAvailable = true
                }
            }
        }else{
            if let carrier = info.subscriberCellularProvider{
                if carrier.mobileNetworkCode != nil{
                    isSimCardAvailable = true
                }
            }
            
        }
        
        return isSimCardAvailable
    }
    
    
}
