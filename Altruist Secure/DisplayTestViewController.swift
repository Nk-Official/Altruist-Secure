//
//  DisplayTestViewController.swift
//  Altruist Secure
//
//  Created by Namrata Khanduri on 16/03/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import UIKit

class DisplayTestViewController: UIViewController {

    //MARK: - OBJECTS
    let displayTester = DisplayTest()
    var solidLineView : SolidLineView?
    
    //MARK: - DOTS HELPER
    let radius: CGFloat = 10
    let gapBetweenDots: CGFloat = 20
    var dots: [CAShapeLayer] = []
    
    //MARK: - TIMER
    var timer: Timer?
    var timerValue: Int = 10{
        didSet{
            updateLblWithTimer()
        }
    }
    let timeStartAt: Int = 10 //seconds
    
    //MARK: - TEST RESULT
    var displayTestPass: Bool = false
    
    //MARK: - IBOUTLET
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var canvasView: UIView!

    //MARK: - IBACTION
    @IBAction func done(_ sender: UIButton){
        print(dots.count,"\n",dots)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - INHERITANCE
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        directUserWithAlert()
        addCircle()
        diagonalPointView()
        addSolidLines()
    }
    func addCircle(){
        let positions = getPositions()
        for i in positions{
            let circle = displayTester.createCircle(of: radius, at: i)
            canvasView.layer.addSublayer(circle)
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
        solidLineView?.removeFromSuperview()
        startTimer()
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
//MARK: - ALERT
extension DisplayTestViewController{

    func directUserWithAlert(){
        let alertConroller = UIAlertController(title: "Screen Test", message: "Draw on the screen to remove all the dots on the screen.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: {
            (_) in
            self.startTimer()
        })
        alertConroller.addAction(okAction)
        present(alertConroller, animated: true, completion: nil)
    }
    
}

//MARK: - TIMER
extension DisplayTestViewController{
    
    func startTimer()  {
        timerValue = timeStartAt
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.timeTrigger()
            self.timerValue -= 1
            
        })
    }
    
    func timeTrigger(){
        if timerValue == 0{
            displayTestPass = allDotsRemoved()
            dismiss(animated: true, completion: nil)
        }
        if timerValue == 0 && solidLineView != nil{
            solidLineView?.removeFromSuperview()
            displayTestPass = false
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    func allDotsRemoved()->Bool{
        return dots.count == 0
    }
    
    func updateLblWithTimer(){
        if timerLbl == nil{return}
        timerLbl.text = "\(timerValue)"
    }
}
