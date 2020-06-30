//
//  LocationTest.swift
//  Runner
//
//  Created by user on 27/03/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
// https://www.tutorialspoint.com/how-to-get-the-current-location-latitude-and-longitude-in-ios
// https://stackoverflow.com/questions/34861941/check-if-location-services-are-enabled
///wifi or cellular needed
// https://developer.apple.com/documentation/corelocation/getting_the_user_s_location/using_the_significant-change_location_service
//https://developer.apple.com/documentation/corelocation/cllocationmanager


import CoreLocation

class LocationTest: NSObject{
    
    //MARK: - PROPERTIES
    let locationManager: CLLocationManager = CLLocationManager()
    
    var testResult: ((Bool)->())?
    var timer: Timer?
    var timePeriod: Double = 0
    var gpsAvailable: Bool = false
    private var comingFromSettings: Bool = false
    
    override init() {
        super.init()
    }
    
    //MARK: - METHODS
    func start(){
        requestForAuthoriztion()
        locationManager.delegate = self
        self.addObserver()
    }
    
    func requestForAuthoriztion(){
        
        
       
        if CLLocationManager.locationServicesEnabled(){
            locationManager.requestAlwaysAuthorization()
            switch  CLLocationManager.authorizationStatus() {
            case .authorizedAlways,.authorizedWhenInUse:
                debugPrint("authorization allowed")
                gpsAvailable = true
                setTimer()
            case .denied,.restricted:
                gpsAvailable = false
                declareResult()
                debugPrint("not authorized for access location")
            case .notDetermined:
                gpsAvailable = false
                setTimer()
                debugPrint("not Determined for access location")
            @unknown default:
                break
            }
        }
        else{
            gpsAvailable = false
            debugPrint("location service not enabled from settings")
            alertForLocation()
        }
    }
    
    
    func setTheAccuracy(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
}

//MARK: - CLLocationManagerDelegate
extension LocationTest: CLLocationManagerDelegate {
 
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location start updating")
        locationManager.startUpdatingLocation()
        if status == .authorizedAlways || status == CLAuthorizationStatus.authorizedWhenInUse{
            checkUserCurrentLocation(clLocation: manager)
        }
        setTimer()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location service fail with error", error.localizedDescription)
        gpsAvailable = false
        declareResult()
    }
    func checkUserCurrentLocation(clLocation manager : CLLocationManager){
        
        if manager.location != nil{ // current location
            debugPrint("GPS test pass")
            gpsAvailable = true
            locationManager.stopUpdatingLocation()
        }else{
//             debugPrint("GPS test fail")
//            gpsAvailable = false
        }
        
    }
}


//MARK: - TIMER
extension LocationTest {
    func setTimer(){
        timer?.invalidate()
        self.timePeriod += 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            print("time period",self.timePeriod)
            self.timePeriod += 1
            self.checkUserCurrentLocation(clLocation: self.locationManager)
            if self.gpsAvailable || self.timePeriod == 15 {
                print("location test",self.gpsAvailable)
                timer.invalidate()
                self.declareResult()
            }
        }
        
    }
    
    func declareResult(){
        self.testResult?(self.gpsAvailable)
        self.testResult = nil
        self.removeObserver()
        self.locationManager.stopUpdatingLocation()
        timer?.invalidate()
    }
    func alertForLocation(){
//        let appname = Bundle.main.displayName ?? "app"
        let appname = "app"
        let alertController = UIAlertController(title: nil, message: "Turn On Location Service to\nAllow\n\(appname) to\nDetermine Your Location", preferredStyle: .alert)
        
        let settingAction = UIAlertAction(title: "Settings", style: .default) { (_) in
            print("settings press")
            alertController.dismiss(animated: true, completion: {
               
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            })
            
            self.comingFromSettings = true
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            print("cancel press")
            self.setTimer()
        }
        alertController.addAction(settingAction)
        alertController.addAction(cancelAction)

        if let rooviewC = UIApplication.shared.keyWindow?.rootViewController {
            rooviewC.present(alertController, animated: true, completion: nil)
        }
    }
    
    func addObserver(){
        NotificationCenter.default.addObserver(self,selector: #selector(notificationAppBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(notificationAppResignActive), name: UIApplication.willResignActiveNotification, object: nil)

    }
    func removeObserver(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)

    }
    @objc func notificationAppBecomeActive(_ notification: Notification){
        print("appcomesToForeGround")
        if CLLocationManager.locationServicesEnabled(){
            locationManager.requestAlwaysAuthorization()
        }
        self.setTimer()
    }
    @objc func notificationAppResignActive(_ notification: Notification){
        timer?.invalidate()
        self.timePeriod = 0
        print("app become resign active")
    }
}
