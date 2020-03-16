//
//  DisplayTestViewController.swift
//  Altruist Secure
//
//  Created by Namrata Khanduri on 16/03/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import UIKit

class DisplayTestViewController: UIViewController {

    
    let displayTester = DisplayTest()
    let radius: CGFloat = 10
    var dots: [CAShapeLayer] = []
    let gapBetweenDots: CGFloat = 20
    
    @IBAction func done(_ sender: UIButton){
        print(dots.count,"\n",dots)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addCircle()
        diagonalPointView()
    }
    func addCircle(){
        let positions = getPositions()
        for i in positions{
            let circle = displayTester.createCircle(of: radius, at: i)
            view.layer.addSublayer(circle)
            dots.append(circle)
        }
    }
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        handleTouches(touches: touches)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        handleTouches(touches: touches)
    }
    
    func handleTouches(touches:  Set<UITouch>){
        let touch = touches.first
        guard let touchLocation = touch?.location(in: view) else {return}
        for i in 0..<dots.count{
            let dot = dots[i]
            if dot.path?.contains(touchLocation) ?? false{
                dots.remove(at: i)
                dot.removeFromSuperlayer()
                break
            }
        }
    }
}

