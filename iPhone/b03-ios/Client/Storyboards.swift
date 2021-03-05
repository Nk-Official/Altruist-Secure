//
//  Storyboards.swift
//
//  Created by Harish Garg on 18/06/20.
//  Copyright © 2020 Softprodigy. All rights reserved.
//

import Foundation
import UIKit

enum Storyboards: String {
    
    case Onboarding = "Onboarding"

    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(_ controller: T.Type) -> T {
        let storyBoardId = (controller as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyBoardId) as! T
    }
}

extension UIViewController {
    
    class var storyboardID : String {
        return "\(self)"
    }

    class func initiatefromStoryboard(_ storyboard: Storyboards) -> Self {
        return storyboard.viewController(self)
    }
}
