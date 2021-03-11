//
//  GlassIMEITestViewController.swift
//  Runner
//
//  Created by user on 19/08/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//"Dial *#06# click the picture with other phone of IMEI number generated and upload it."

import UIKit

class GlassIMEITestViewController: UIViewController {

    var qrApiParam: QRCodeParam!
    var completion: ((String)->())!
    var glassImeiTest : GlassIMEITest!
    
    @IBOutlet weak var dialogueView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setui()
        runTest()
    }
    
    func setui(){
        dialogueView.layer.cornerRadius = 5
        dialogueView.layer.borderColor = UIColor.blue.cgColor
        dialogueView.layer.borderWidth = 2

    }

   func runTest()
   {
    glassImeiTest = GlassIMEITest(param: qrApiParam, viewcontroller: self, completion: { (success) in
         self.glassImeiTest.removeObservor()
        self.glassImeiTest.completion = {
            (_) in
        }
        self.completion(success)
        self.dismiss(animated: true) {
            self.glassImeiTest = nil
        }
     })
     glassImeiTest.startTest()
}

}
