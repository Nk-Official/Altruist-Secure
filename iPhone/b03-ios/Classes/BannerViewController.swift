//
//  BannerViewController.swift
//  Project
//
//  Created by Bossly on 10/8/16.
//  Copyright © 2016 Bossly. All rights reserved.
//

import UIKit
import GoogleMobileAds

class BannerViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var bannerView: GADBannerView?
    @IBOutlet weak var bannerHeightConstraints: NSLayoutConstraint!
    
    override func viewDidLoad() {

        if kAdMobEnabled {
            print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
            
            if let bannerView = self.bannerView {
                bannerView.delegate = self
                bannerView.adUnitID = kAdBanner
                bannerView.rootViewController = self
                
                let request = GADRequest()
                bannerView.load(request)
            }
        } else {
            bannerHeightConstraints.constant = 0
        }
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print(bannerView.debugDescription)
        if bannerHeightConstraints.constant == 0
        {
            bannerHeightConstraints.constant = 60
        }
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error.description)
        if bannerHeightConstraints.constant == 60
        {
            bannerHeightConstraints.constant = 0
        }
    }
    
}
