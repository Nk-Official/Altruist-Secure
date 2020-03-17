//
//  ExDisplayTestViewController.swift
//  Altruist Secure
//
//  Created by Namrata Khanduri on 16/03/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import Foundation
extension DisplayTestViewController{

    func getPositions() -> [CGPoint]{
        
        let x: CGFloat = 20
        let y: CGFloat = 30
      
        var topRightEndX: CGFloat = 30
        var bottomLeftEndY: CGFloat = 30
        
        
        let diameter = 2*radius
                

        var positions: [CGPoint] = [CGPoint(x: x, y: y)]
        
        var i = 1
        
        
        // left side points
        while true {
            
            let dY = ((diameter+gapBetweenDots)*CGFloat(i))+y
            if (dY+diameter) >= view.frame.height{// new dot height + gap
                break
            }
            let position = CGPoint(x: x, y: dY)
            positions.append(position)
            i+=1
            bottomLeftEndY = dY
        }
        
        // Top points
        i = 1
        
        while true {

            let pX = (diameter+gapBetweenDots)*CGFloat(i)+x
            if (pX+diameter) >= view.frame.width{// new dot width + gap
                break
            }
            let position = CGPoint(x: pX, y: y)
            positions.append(position)
            i+=1
            topRightEndX = pX
        }
        
        // right side points
        i = 1
       while true {
           let dY = ((diameter+gapBetweenDots)*CGFloat(i))+y
           if (dY+diameter) >= view.frame.height{// new dot height + gap
               break
           }
           let position = CGPoint(x: topRightEndX, y: dY)
           positions.append(position)
           i+=1
           bottomLeftEndY = dY
       }
        // bottom points
        i = 1
       while true {

           let pX = (diameter+gapBetweenDots)*CGFloat(i)+x
           if (pX+diameter) >= view.frame.width{// new dot width + gap
               break
           }
           let position = CGPoint(x: pX, y: bottomLeftEndY)
           positions.append(position)
           i+=1
           topRightEndX = pX
       }
       return positions
        
    
    }
    
    func diagonalPointView(){
        let diameter = 2*radius
        var i = 1
        let x: CGFloat = 0
        let y: CGFloat = 30
        
        // left side points
        while true {
            
            let dY = ((diameter+gapBetweenDots)*CGFloat(i))+y
            
            let position = CGPoint(x: x, y: dY)
            let transformedPosition = position.applying(CGAffineTransform(rotationAngle: -.pi/6))
            if (transformedPosition.y+diameter) >= view.frame.height || (transformedPosition.x+diameter) >= view.frame.width{// new dot height + gap
                break
            }
            let shapeLayer = displayTester.createCircle(of: radius, at: transformedPosition)

            view.layer.addSublayer(shapeLayer)
            
            dots.append(shapeLayer)
            i+=1
        }
        i=1
       // left side points
       while true {
        let x = view.frame.width - diameter - 20
        let dY = ((diameter+gapBetweenDots)*CGFloat(i))
        
        let position = CGPoint(x: x, y: dY)
        let transformedPosition = position.applying(CGAffineTransform(rotationAngle: .pi/6))
        print(position,transformedPosition,"\n\n")
        if transformedPosition.y + diameter > view.frame.height{
            break
        }
        let shapeLayer = displayTester.createCircle(of: radius, at: transformedPosition)

        view.layer.addSublayer(shapeLayer)
        
        dots.append(shapeLayer)

           i+=1
       }
    }
}
