//
//  ExDisplayTestViewController.swift
//  Runner
//
//  Created by user on 24/03/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit
extension DisplayTestViewController{

    //MARK: - DRAWING SOLID LINES
    
    func addSolidLines(){
        solidLineView = SolidLineView(frame: self.view.frame)
        solidLineView!.constructShape()
        canvasView.addSubview(solidLineView!)
    }
    
    
    //MARK: - DOTES AT STRAIGHT LINES
    func getPositions() -> [CGPoint]{
        
        let (topInsect, _) = safeAreaInsect()
        let bottomInsect: CGFloat = 10
        
        let x: CGFloat = 20
        let y: CGFloat = topInsect+15
      
        var topRightEndX: CGFloat = 30
        var bottomLeftEndY: CGFloat = 30
        
        
        let diameter = 2*radius
                

        var positions: [CGPoint] = [CGPoint(x: x, y: y)]
        
        var i = 1
        
        
        // left side points
        while true {
            
            let dY = ((diameter+gapBetweenDots)*CGFloat(i))+y
            if (dY+diameter) >= view.frame.height-bottomInsect{// new dot height + gap
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
           if (dY+diameter) >= view.frame.height-bottomInsect{// new dot height + gap
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
        
        diagonalPointView(startPointX: x, endPointX: topRightEndX, startPointY: y, endPointY: bottomLeftEndY)
        
       return positions
        
    
    }
    //MARK: - DIAGONAL POINT VIEW
    func diagonalPointView(startPointX: CGFloat, endPointX: CGFloat, startPointY: CGFloat, endPointY: CGFloat){
        let (topInsect, _) = safeAreaInsect()
        let bottomInsect: CGFloat = 10
        let diameter = 2*radius
        var i = 1
        let y: CGFloat = topInsect+15
        
        i=1
       // left side points
       while true {
        /// top right position p1    bottom left position
        let diagonalLine1P1 = CGPoint(x: endPointX-10, y: startPointY)//constants are just for margin
        let diagonalLine1P2 = CGPoint(x: startPointX+15, y: endPointY-(diameter))//constants are just for margin
        
        /// top right position p1    bottom left position
        let diagonalLine2P1 = CGPoint(x: startPointX+10, y: startPointY)//constants are just for margin
        let diagonalLine2P2 = CGPoint(x: endPointX-15, y: endPointY-(diameter))//constants are just for margin
        
        
        let dY = ((diameter+gapBetweenDots)*CGFloat(i))+y
        let customLineP1 = CGPoint(x: 0, y: dY)
        let customLineP2 = CGPoint(x: view.frame.width, y: dY)
        if let position = getIntersectionOfLines(line1: (a: diagonalLine1P1, b: diagonalLine1P2), line2: (a: customLineP1, b: customLineP2))  {
            if  position.y > view.frame.height-diameter-bottomInsect || i > 20{
                break
            }
            let shapeLayer = createCircle(of: radius, at: position)
            
            canvasView.layer.addSublayer(shapeLayer)
            
            dots.append(shapeLayer)
            
        }else{
            return
        }
       
        if let position = getIntersectionOfLines(line1: (a: diagonalLine2P1, b: diagonalLine2P2), line2: (a: customLineP1, b: customLineP2))  {
            if  position.y > view.frame.height-diameter-bottomInsect || i > 20{
                break
            }
            let shapeLayer = createCircle(of: radius, at: position)

            canvasView.layer.addSublayer(shapeLayer)

            dots.append(shapeLayer)

        }else{
            return
        }
        i+=1
       }
    }
    
    //MARK: - INTERSACTION POINT OF TWO LINES
    func getIntersectionOfLines(line1: (a: CGPoint, b: CGPoint), line2: (a: CGPoint, b: CGPoint)) -> CGPoint? {

        let distance = (line1.b.x - line1.a.x) * (line2.b.y - line2.a.y) - (line1.b.y - line1.a.y) * (line2.b.x - line2.a.x)
        if distance == 0 {
            print("error, parallel lines")
            return nil
        }

        let u = ((line2.a.x - line1.a.x) * (line2.b.y - line2.a.y) - (line2.a.y - line1.a.y) * (line2.b.x - line2.a.x)) / distance
        let v = ((line2.a.x - line1.a.x) * (line1.b.y - line1.a.y) - (line2.a.y - line1.a.y) * (line1.b.x - line1.a.x)) / distance

        if (u < 0.0 || u > 1.0) {
            print("error, intersection not inside line1")
            return nil
        }
        if (v < 0.0 || v > 1.0) {
            print("error, intersection not inside line2")
            return nil
        }

        return CGPoint(x: line1.a.x + u * (line1.b.x - line1.a.x), y: line1.a.y + u * (line1.b.y - line1.a.y))
    }
    
    func safeAreaInsect()->(CGFloat,CGFloat){
        
//        guard let viewController = UIApplication.shared.keyWindow?.rootViewController else{
//            return (0,0)
//        }
        
        let top = view.safeAreaInsets.top
        let bottom = view.safeAreaInsets.bottom
        return (top,bottom)
        
    }
    
}
