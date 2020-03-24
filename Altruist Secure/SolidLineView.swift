//
//  SolidLineView.swift
//  Altruist Secure
//
//  Created by user on 23/03/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

class SolidLineView:UIView{
    
    
    //MARK: - constructShape
    func constructShape(){
        
       
        let (topInsect, bottomInsect) = safeAreaInsect()
        let x: CGFloat = 30
        let y = topInsect + 15
        let height = frame.height - bottomInsect - 2*(y)
        let lineWidth: CGFloat = 30
        
        let width = frame.width-2*(x)
        
        backgroundColor = .white
        let shapeframe = CGRect(x: x, y: y, width: width, height: height)

        let bezierpath = UIBezierPath( roundedRect: shapeframe , cornerRadius: 0)
        bezierpath.close()
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierpath.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.white.cgColor
        
        let diagonalPath = UIBezierPath()
        diagonalPath.move(to: CGPoint(x: x, y: y) )
        diagonalPath.addLine(to:  CGPoint(x: width+x, y: height+x))
        let diagonalShape1 = CAShapeLayer()
        diagonalShape1.path = diagonalPath.cgPath
        diagonalShape1.lineWidth = lineWidth
        diagonalShape1.strokeColor = UIColor.black.cgColor
        shapeLayer.addSublayer(diagonalShape1)
        
        let diagonalPath2 = UIBezierPath()
        diagonalPath2.move(to: CGPoint(x: width+x, y: y) )
        diagonalPath2.addLine(to: CGPoint(x: x, y: height+x) )
        let diagonalShape2 = CAShapeLayer()
        diagonalShape2.path = diagonalPath2.cgPath
        diagonalShape2.lineWidth = lineWidth
        diagonalShape2.strokeColor = UIColor.black.cgColor
        shapeLayer.addSublayer(diagonalShape2)
        
        layer.addSublayer(shapeLayer)
        
    }
    
    func safeAreaInsect()->(CGFloat,CGFloat){
        
        guard let viewController = UIApplication.shared.keyWindow?.rootViewController else{
            return (0,0)
        }
        let top = viewController.view.safeAreaInsets.top
        let bottom = viewController.view.safeAreaInsets.bottom
        return (top,bottom)
        
    }
    
}
