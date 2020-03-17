//
//  ViewController.swift
//  Altruist Secure
//
//  Created by Namrata Khanduri on 13/03/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func flashTest(_ sender: UIButton){
        if flashTest.checkFlash(){
            print("flash is working fine")
        }
        else{
            print("flash not working")
        }
    }
    let flashTest = FlashTest()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

