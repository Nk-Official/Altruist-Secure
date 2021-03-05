//
//  PopupViewController.swift
//
//  Created by Harish on 16/06/20.
//  Copyright © 2020 Softprodigy. All rights reserved.
//

import UIKit

protocol ClosePopupDelegate {
    func closePopupView()
}

class PopupViewController: UIViewController {
    
    //MARK: - OUTLET
    var popupDelegate:ClosePopupDelegate?
    var type = String()

    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if type == "profile"
        {
            skipButton.setTitle("Later", for: .normal)
        }
        super.viewWillAppear(animated)
    }
    
    @IBAction func continueBtn_Action(_ sender: UIButton){
        
        let text: String = "Tell your friends about the app and have fun together!"
        let appStoreURL = NSURL(string:"https://apps.apple.com/us/app/social-cross/id1469096120?ls=1")

        guard let url = appStoreURL else {
            print("nothing found")
            return
        }
        let shareItems:[Any] = [text, url]
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            self.popupDelegate?.closePopupView()
        }
        self.present(activityViewController, animated: true)
    }
    
    @IBAction func skipBtn_Action(_ sender: UIButton){
        self.popupDelegate?.closePopupView()
    }
    
}
