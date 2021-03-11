//
//  GlassIMEITest.swift
//  AltruistSecureR3
//
//  Created by user on 17/08/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
// //https://howto.lintel.in/dial-ussd-code-ios/

import UIKit
import CallKit

class GlassIMEITest: NSObject{
    
    let callObserver = CXCallObserver()
    var dialledNumber: Bool = false
    
    var qrApiParam: QRCodeParam
    var completion: (String)->()
    
    var timer: Timer?
    var apiHitCount = 0
    var statusOfTest: String = ""
    var reserveStatusAfterTimeOut = ""
    let bridge = ServerBridge()
    
    let apiHitInterwala: TimeInterval = 10
    let maxApiHitLimit: Int = 3

    var dialogueView: UIView?
    var timercount = 0
    
    var urlsessiontask: URLSessionDataTask?
    var viewcontroller: UIViewController
    
    init(param: QRCodeParam,viewcontroller: UIViewController,completion : @escaping (String)->()) {
        qrApiParam = param
        self.completion = completion
        self.viewcontroller = viewcontroller
        super.init()
    }
    func startTest(){
//        showDialogueToUser()
        dialUSSd()
        //start hitting the api for 30 sec
        hitAPI()
        
    }
    
    func addObserver(){
        let notifc = UIApplication.didBecomeActiveNotification // working when  nootifcation hide
        NotificationCenter.default.addObserver(self, selector: #selector(appBEcomeActive), name: notifc, object: nil)
        
    }
    func removeObservor(){
        let notifc = UIApplication.didBecomeActiveNotification // working when  nootifcation hide
        NotificationCenter.default.removeObserver(self, name: notifc, object: nil)
    }
    @objc private func appBEcomeActive(_ notification: Notification){
        //if user minimize app and come back to app then start the api test from start we assume may be he was uploading picture
        
        removeObservor()
        addObserver()
        
        if dialledNumber{
            // APP CAME TO ACTIVE STATE AFTER CALLING
            removeDialogue()
            apiHitCount = 3 // hit for only one time
            hitAPI()
//            removeObservor()
        }else{
            // check state of app after some time
            // if app is in active state then we assume user click didnt dial the number
            // otherwise he dialled the number
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                let state = UIApplication.shared.applicationState
                print("check state after 1 sec",state.rawValue)
                if state == .inactive{
                    self.dialledNumber = true
                }else { //User Press cancel button -> give option to dial again
                    self.dialledNumber = false
                    if self.apiHitCount >= self.maxApiHitLimit{
                        let status = self.reserveStatusAfterTimeOut == "" ? "3" : self.reserveStatusAfterTimeOut
                        self.sendCallback(status: status)
                    }else{
                         self.dialUSSd()
                    }
                }
            }
        }
        
    }
    
    private func checkStateOfApp(){
        
        let state = UIApplication.shared.applicationState
        switch  state {
        case .active:
            print("active state")
        case .background:
            print("background state")
        case .inactive:
            print("inactivestate")
        default:
            print("default state")
        }
        
    }
    
    
    private func dialUSSd(){
        
        let ussdCode = "tel://"+USSD_IMEI
        let app = UIApplication.shared
        if let encoded = ussdCode.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let u = encoded//"tel://\(encoded)"
            if let url = URL(string:u) {
                if app.canOpenURL(url) {
//                    self.callObserver.setDelegate(self, queue: nil)
                    app.open(url, options: [:], completionHandler: { (finished) in
                        if finished{
                            self.addObserver()
                        }
                    })
                }
                else{
                    self.viewcontroller.showAlert(title: "Oops!", message: "Unknown Error While calling from App.")
                }
            }else{
                self.viewcontroller.showAlert(title: "Oops!", message: "Unknown Error While calling from App.")
            }
        }
    }
    
}

//MARK: - API
extension GlassIMEITest{
    func hitApiAfterSecInterwal(){
        DispatchQueue.main.asyncAfter(deadline: .now()+apiHitInterwala) {
            self.hitAPI()
        }
    }
    func hitAPI(){
        apiHitCount += 1
        urlsessiontask?.cancel()
        urlsessiontask  = bridge.checkBarCodeIsScanned(param: qrApiParam) { (result) in
            self.handleGlassTestApiResponse(response: result)
        }
        
    }
    func handleGlassTestApiResponse(response: (Result<GlassTest,Error>)){
        switch response{
        case .success(let glassTestModel):
            let errorcode = glassTestModel.statusDescription?.errorCode
            print("\n\nerror code",errorcode)
            if errorcode ?? 0 == 200{
                guard let status = glassTestModel.deviceDetailsUploads?.status else{
                    let newStatus = ""
                    if ifapiHitIsaboveLimitAndStatusSameAsLastFetchStatus(newStatus: newStatus){// last status from hitting api is equal to current status from api
                        self.sendCallback(status: "0")
                        return
                    }
                    else{
                        self.hitApiAfterSecInterwal()
                    }
                    self.statusOfTest = newStatus
                    return
                }
                print("\n\n status code",status)
                if status == "1" || status == "2"{
                    self.sendCallback(status: status) // 1- user uploaded the image and approved from panel
//                    2- user uploaded the image and disapproved from panel
                    return
                }
                
                else if /*statusOfTest == status,*/ apiHitCount <= maxApiHitLimit{ // hit api 3 times with the interwal of 10 seconds
                    self.hitApiAfterSecInterwal()
                }
//                else if statusOfTest != status{ // status of API change not reset the 30 sec session and hit api again
////                    apiHitCount = 0
//                    self.hitApiAfterSecInterwal()
//                }
                else if ifapiHitIsaboveLimitAndStatusSameAsLastFetchStatus(newStatus: status){
                    self.sendCallback(status: "0")
                    return
                }
                
                self.statusOfTest = status
            }
            else{
                let newStatus = ""
                if self.ifapiHitIsaboveLimitAndStatusSameAsLastFetchStatus(newStatus: newStatus){
                    self.sendCallback(status: "3")
                    return
                }else if ifApiHitIsLessThanEqualToLimitAndNewStatusIsNotSameAsLastFetchStatus(newStatus: newStatus){
//                    self.apiHitCount = 0
                    self.hitApiAfterSecInterwal()
                }
                else {
                    self.hitApiAfterSecInterwal()
                }
                
                self.statusOfTest = newStatus
            }
        case .failure( _):
            if ifapiHitIsaboveLimitAndStatusSameAsLastFetchStatus(newStatus: ""){
                self.sendCallback(status: "3")
            }else{
                self.hitApiAfterSecInterwal()
            }
        }
    }
    
    func sendCallback(status: String){
        print("send callback",status)
        DispatchQueue.main.async {
            let trimmStatus = status.trimmingCharacters(in: .whitespacesAndNewlines)
            let state = UIApplication.shared.applicationState
            switch  state {
            case .active:
                switch trimmStatus {
                case "0":
                    self.completion("in_process")
                case "1":
                    self.completion("true")
                case "2":
                    self.completion("false")
                case "3":
                    self.completion("not_found")
                default:
                    self.completion("unknown")
                }
                self.removeObservor()
            case .inactive:
                print("inacive satte")
            case .background:
                print("background state")
            default:
                self.reserveStatusAfterTimeOut = status
                print("default state")
            }
        }
        
    }
    
    func ifapiHitIsaboveLimitAndStatusSameAsLastFetchStatus(newStatus: String)->Bool{
        if apiHitCount > maxApiHitLimit/*, self.statusOfTest == newStatus*/{ // / status is same after hitting api for 30 sec in 3 interwals
            // last status from hitting api is equal to current status from api
            return true
        }
        return false
    }
    func ifApiHitIsLessThanEqualToLimitAndNewStatusIsNotSameAsLastFetchStatus(newStatus: String)->Bool{
        if apiHitCount <= maxApiHitLimit/*, self.statusOfTest != newStatus*/{//status of APi changed
                return true
        }
        return false
    }
}
//MARK: - TIMER

extension GlassIMEITest{
//    func scheduleTimer(){
//        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { (_) in
//            if self.timercount == self.maxApiHitLimit{
//                self.timer?.invalidate()
//                print("timer Invalidate")
//            }else{
//                print("Timer value",self.timercount+1)
//                self.timercount += 1
//                self.hitAPI()
//            }
//        })
//    }
}

extension GlassIMEITest{
    
    func showDialogueToUser(){
        guard let rooviewC = UIApplication.shared.keyWindow?.rootViewController else{
            print("rootviewcontroller not found")
            return
        }
        
        let frame = CGRect(x: 30, y: 100, width: UIScreen.main.bounds.width-60, height: 150)
        dialogueView = UIView(frame: frame)
        dialogueView?.clipsToBounds = true
        dialogueView?.layer.cornerRadius = 5
        dialogueView?.layer.borderColor = UIColor.blue.cgColor
        dialogueView?.layer.borderWidth = 2
        
        let lblFrame = CGRect(x: 15, y: 15, width: frame.width-30, height: frame.height-30)
        let label = UILabel(frame: lblFrame )
        label.text = "Dial *#06# click the picture with other phone of IMEI number generated and upload it."
        label.textColor = UIColor.blue
        label.numberOfLines = 0
        label.textAlignment = .center
        
        dialogueView?.addSubview(label)
        rooviewC.view.addSubview(dialogueView!)
        print("dialogueView added")
    }
    
    func removeDialogue(){
        dialogueView?.removeFromSuperview()
        print("removed")
    }
    
}

// 200 success case -
//    1 status - true // user uploaded the image and approved from panel
//    2 status - false // user uploaded the image and disapproved from panel
//    0 status -  // user uploaded the image but inprocess
//201 status case -
//    //Not found
//
//if from api response if we got 200 response -> after 10 sec timer -> if we get either true or false close timer
//if inprocess wait cycle complete of 10 sec in 3 times
//
//if from api response if we got 201 response ->


///CXCallObserverDelegate work for GSM number not for USSD codes

//extension GlassIMEITest: CXCallObserverDelegate{
//    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
//        print("call observer status")
//        if call.hasEnded == true {
//            print("CXCallState :Ended")
//        }
//        if call.isOutgoing == true && call.hasConnected == false {
//            print("CXCallState :Dialing")
//        }
//        if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
//            print("CXCallState :Incoming")
//        }
//        if call.hasConnected == true && call.hasEnded == false {
//            print("CXCallState : Connected")
//        }
//
//    }
//}



