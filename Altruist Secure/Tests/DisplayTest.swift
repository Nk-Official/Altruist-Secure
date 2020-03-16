//
//  DisplayTest.swift
//  Altruist Secure
//
//  Created by Namrata Khanduri on 16/03/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import UIKit
class DisplayTest {
    
    
    
    
    
}

extension DisplayTest {
    
    
    func createCircle(of radius: CGFloat, at position: CGPoint)->CAShapeLayer{
        let circlepath = UIBezierPath(arcCenter: position , radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlepath.cgPath
        shapeLayer.fillColor = UIColor.black.cgColor
        return shapeLayer
    }
    
}
