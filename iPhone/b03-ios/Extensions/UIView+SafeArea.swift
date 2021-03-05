//
//  UIView+SafeArea.swift
//  Mustage
//
//  Created by xu.shuifeng on 2018/6/15.
//  Copyright © 2020 harish. All rights reserved.
//

import UIKit

extension UIView {
    
    var keyWindowSafeAreaInsets: UIEdgeInsets {
        return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
    }
}
