//
//  DisplayTestViewController.swift
//  Runner
//
//  Created by user on 24/03/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit

class DisplayTestViewController: UIViewController {

    //MARK: - OBJECTS
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
    var testResultHandler: ((Bool)->())?
    var displayTestPass: Bool = false
    var didlayout: Bool = false
    
    //MARK: - IBOUTLET
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var canvasView: UIView!

    //MARK: - IBACTION
    @IBAction func done(_ sender: UIButton){
        dismiss()
    }
    
    //MARK: - INHERITANCE
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didlayout{
            didlayout = true
            directUserWithAlert()
            
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
       
        if solidLineView != nil{
            solidLineView?.removeFromSuperview()
             timerLbl.isHidden = false
        }
        else{
            handleTouches(touches: touches)
            timerLbl.isHidden = true
        }
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        handleTouches(touches: touches)
        timerLbl.isHidden = true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        timerLbl.isHidden = false
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        timerLbl.isHidden = false
    }
    
    //MARK: - CIRCLES
    func addCircle(){
          let positions = getPositions()
          for i in positions{
              let circle = createCircle(of: radius, at: i)
              canvasView.layer.addSublayer(circle)
              dots.append(circle)
          }
      }
    func createCircle(of radius: CGFloat, at position: CGPoint)->CAShapeLayer{
        let circlepath = UIBezierPath(arcCenter: position , radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlepath.cgPath
        shapeLayer.fillColor = UIColor.black.cgColor
        return shapeLayer
    }
    
    //MARK: - HANDLE TOUCHES
    func handleTouches(touches:  Set<UITouch>){
        if solidLineView != nil{
             solidLineView?.removeFromSuperview()
            solidLineView = nil
            timerLbl.isHidden = false
            return
        }
        let touch = touches.first
        guard let touchLocation = touch?.location(in: view) else {return}
        for i in 0..<dots.count{
            let dot = dots[i]
            if dot.path?.contains(touchLocation) ?? false{
                dots.remove(at: i)
                dot.removeFromSuperlayer()
                dots.count == 0 ? dismiss() : nil
                break
            }
        }
        startTimer()
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
        present(alertConroller, animated: true, completion: {
            DispatchQueue.main.async{
                self.addCircle()
            }
//            self.addSolidLines()
        })
    }
    
}

//MARK: - TIMER
extension DisplayTestViewController{
    
    func startTimer()  {
        timerValue = timeStartAt
        timer?.invalidate()
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                self.timeTrigger()
                self.timerValue -= 1
                
            })
        } else {
            
        }
    }
    
    func timeTrigger(){
        if timerValue == 0{
            displayTestPass = allDotsRemoved()
            dismiss()
        }
        if timerValue == 0 && solidLineView != nil{
            solidLineView?.removeFromSuperview()
            displayTestPass = false
            dismiss()
        }
    }
    
    
    func allDotsRemoved()->Bool{
        print("allDotsRemoved",dots.count)
        return dots.count == 0
    }
    
    func updateLblWithTimer(){
        if timerLbl == nil{return}
        if timerValue < 0 {return}
        timerLbl.text = "\(timerValue)"
    }
    func dismiss(){
        displayTestPass = allDotsRemoved()
        print("number of dots left",dots.count)
        dismiss(animated: true, completion: nil)
        testResultHandler?(displayTestPass)
        timer?.invalidate()
        testResultHandler = nil
    }
}
