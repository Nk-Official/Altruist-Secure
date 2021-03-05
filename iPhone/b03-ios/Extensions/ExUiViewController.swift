//
//  ExUiViewController.swift
//  Mustage
//
//  Created by user on 16/06/20.
//  Copyright © 2020 shuifeng.me. All rights reserved.
//

import UIKit
extension UIViewController{
    func showAlert(title: String? = nil, message : String? = nil){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
}
