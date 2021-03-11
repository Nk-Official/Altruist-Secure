import UIKit
import Flutter
import Crashlytics
import Firebase
import flutter_downloader

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    //MARK: - PROPERTIES
    let keys : FlutterKeys = FlutterKeys()
    let sensorTest = SensorTest()
    let bluetoothTest = BluetoothTest()
    let headphonetest = HeadphoneTest()
    let wifiTest = WifiTest()
    var glassTestController : GlassIMEITestViewController!
    private var wifiTestCall = 0
    lazy var simTest = SimTest()

    //MARK: - INTITALIZE
    override init() {
        super.init()
        #if NoonSecure
            let firebaseFileName = "NoonSecureGoogleService-Info"
        #elseif AltruistSecure
            let firebaseFileName = "AltuistSecureGoogleService-Info"
        #elseif AltruistSecureR3
            let firebaseFileName = "AltuistSecureR3GoogleService-Info"
        #elseif AltruistSecureBangal
            let firebaseFileName = "GoogleServiceBangla-Info"
        #else
            let firebaseFileName = "AltuistSecureGoogleService-Info"
        #endif
        let filePath = Bundle.main.path(forResource: firebaseFileName, ofType: "plist")!
        let options = FirebaseOptions(contentsOfFile: filePath)
        FirebaseApp.configure(options: options!)
//        print("firebase configure done",firebaseFileName,"/n",filePath)
    }
    
    //MARK: - INHERTANCE
    override func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
      setChannel()
      GeneratedPluginRegistrant.register(with: self)
        FlutterDownloaderPlugin.setPluginRegistrantCallback { (register) in
            FlutterDownloaderPlugin.register(with: register.registrar(forPlugin: "FlutterDownloaderPlugin") as! FlutterPluginRegistrar)
        }
        
//        print("model of device", UIDevice.current.model, "\(UIDevice.current.type.rawValue)")
//        print("type of device", UIDevice.current.getDeviceIdiom())
//        print("OS of device", UIDevice.current.systemVersion)

      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    //MARK: - METHODS
    func setChannel(){
        let controller = window?.rootViewController as! FlutterViewController

        let channel = FlutterMethodChannel(name: keys.channel, binaryMessenger: controller.binaryMessenger )

        channel.setMethodCallHandler { [weak self] (call, result) in
            self?.performTest(result, channel: channel, method: call)
        }
    }
    
    //MARK: - performTest
    func performTest(_ result: @escaping FlutterResult,channel: FlutterMethodChannel,method call: FlutterMethodCall){
        let key = call.method
        switch key {
        //MARK: - SIM Test
        case keys.simTest:
            runSimTest { (testResult) in
                result( NSNumber(value: testResult) )
            }
        //MARK: - WIFI TEST
        case keys.wifiTest:
            wifiTestCall += 1
            if wifiTestCall == 1{
                let testResult = wifiTest.checkInternetWorkingThroghWifi()
                result(testResult)
            }else if wifiTestCall == 2{
                wifiTest.wifiCallbackResult = {
                   (testResult) in
                   result(testResult)
               }
               wifiTest.start()
                wifiTestCall = 0
            }
        //MARK: - DISPLAY TEST
        case keys.displayTest:
            runDisplayTest(channel)
        //MARK: - BATTERY TEST
        case keys.batteryTest:
            let testResult = runBatteryTest() // return battery level int value
            result(NSNumber(value: testResult ))
        //MARK: - PROXIMITY TEST
        case keys.proximityTest:
            let testResult = runProximityTest() // return bool value
            result(NSNumber(value: testResult ))
        //MARK: - GRAVITY TEST
        case keys.gravityTest:
            let testResult = runGravityTest() // return bool value
            result(NSNumber(value: testResult ))
        //MARK: - GPS TEST
        case keys.gpsTest:
            sensorTest.locationTestResult = {
                (testResult) in
                print("location test result",testResult)
                result(NSNumber(value: (testResult) ))
            }
            sensorTest.executeLocationTest()
        //MARK: - BAROMETER TEST
        case keys.barometerTest:
            sensorTest.barometerTestResult = {
                (testResult) in
                result(NSNumber(value: testResult ))
            }
            sensorTest.checkBarometer()
        //MARK: - ACCELEROMETER
        case keys.accelerometerTest:
            let testResult = runAccelerometerTest()
            result(NSNumber(value: testResult ))
        //MARK: - COMPASSTEST
        case keys.compassTest:
            let testResult = runCompassTest()
            result(NSNumber(value: testResult ))
        //MARK: - SPEAKER TEST
        case keys.speakerTest:
            guard let arguments = call.arguments as? NSDictionary else{
                return
            }
            if let text = arguments.value(forKey: "text") as? Int {
                let speakercheck = SpeakerTest(value: text)
                speakercheck.speakerTestResult = {
                    (testResult) in
                    result(NSNumber(value: testResult) )
                }
                speakercheck.playSpeech()
            }
        //MARK: - HEADPHONE TEST
        case keys.headphoneTest:
            headphonetest.headPhoneTestResultCallback = {
                (testResult) in
                channel.invokeMethod(self.keys.headphoneTest, arguments: testResult)
            }
            headphonetest.startTest()
        //MARK: - BLUETOOTH TEST
        case keys.bluethoothTest:
            
            bluetoothTest.bluetoothTestResult = {
                (testResult) in
                result(NSNumber(value: testResult) )
            }
            bluetoothTest.startTest()
        //MARK: - BIOMETRIC TEST
        case keys.biometricAvailablityTest:
            let biometric = sensorTest.checkWhichBioMetricIsAvailable()
            switch biometric{
             case .touchID: result(NSNumber(value: 1 ))
            case .faceID: result(NSNumber(value: 2 ))
            default: result(NSNumber(value: 3 ))
            }
        //MARK: - FINGERPRINT TEST
        case keys.fingerPrintTest:
        sensorTest.biometricSensor = {
            (testResult) in
            result(NSNumber(value: testResult ))
        }
        sensorTest.checkBioMetricSensor(sensor: .fingerprint)
        //MARK: - FACELOCK
        case keys.facelock:
            sensorTest.biometricSensor = {
                (testResult) in
                result(NSNumber(value: testResult ))
            }
            sensorTest.checkBioMetricSensor(sensor: .facelock)
        //MARK: - DEVICE BRAND
        case keys.deviceBrand:
            let brand = UIDevice.current.getDeviceIdiom()
            result(brand)
        //MARK: - DEVICE MODEL
        case keys.deviceModel:
            let model = UIDevice.current.type.rawValue
            result(model)
        //MARK: - DEVICE OS
        case keys.deviceOS:
            let os = UIDevice.current.systemVersion
            result(os)
        //MARK: - GLASS IMEI TEST
        case keys.glassIMEITest:
            guard let arguments = call.arguments as? NSDictionary else{
                return result("-1")
            }
            runGlassIMEITest(parameters: arguments, channel: channel)
        default:
            print("\(key) method not implemented")
            result( FlutterError(code: "UNAVAILABLE", message: "\(key) method not implemented", details: nil) )
        }
    }
    
    //MARK: - DISPLAY TEST
    func runDisplayTest( _ channel : FlutterMethodChannel ){
        
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var displayTestViewController: DisplayTestViewController!
        if #available(iOS 13.0, *) {
            displayTestViewController = (storyboard.instantiateViewController(identifier: "DisplayTestViewController") as! DisplayTestViewController)
        } else {
            // Fallback on earlier versions
            displayTestViewController = (storyboard.instantiateViewController(withIdentifier: "DisplayTestViewController") as! DisplayTestViewController)
        }
        displayTestViewController.testResultHandler = {
            [weak self] (pass) in
            if let key = self?.keys.displayTest{
                channel.invokeMethod(key, arguments: pass)
            }
            
        }
        presentViewController(viewController: displayTestViewController)
    }
}
//MARK: - FLUTTER DOWNLOADER
extension AppDelegate{
    
//    func runGlassIMEITest(parameters: NSDictionary, channel:  FlutterMethodChannel){
//        let jsonEncrypt = JSONEncryptor()
//        do{
//            let data = try jsonEncrypt.convertToData(dict: parameters)
//            let model: QRCodeParam  = try jsonEncrypt.encodeToObject(data: data)
////            print("model",model.qrCode,model.userId,model.userToken)
//            glassImeiTest = GlassIMEITest(param: model, completion: { (success) in
//                self.glassImeiTest.removeObservor()
//                print("Glass test result,",success)
//                channel.invokeMethod(self.keys.glassIMEITest, arguments: success)
//            })
//            glassImeiTest.startTest()
//        }
//        catch{
//            channel.invokeMethod(self.keys.glassIMEITest, arguments: "Error while fetching user detail")
//        }
//    }
    
    func runGlassIMEITest(parameters: NSDictionary, channel:  FlutterMethodChannel)
    {
        
        glassTestController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GlassIMEITestViewController") as!  GlassIMEITestViewController
        guard let controller = window?.rootViewController  else{
            channel.invokeMethod(self.keys.glassIMEITest, arguments: "Unknown error")
            return
        }
        let jsonEncrypt = JSONEncryptor()
        do{
            let data = try jsonEncrypt.convertToData(dict: parameters)
            let model: QRCodeParam  = try jsonEncrypt.encodeToObject(data: data)
            glassTestController.modalPresentationStyle = .fullScreen
            glassTestController.qrApiParam = model
            glassTestController.completion = { (success) in
                print("Glass test result,",success)
                channel.invokeMethod(self.keys.glassIMEITest, arguments: success)
            }
            controller.present(glassTestController, animated: true, completion: nil)
        }
        catch{
            channel.invokeMethod(self.keys.glassIMEITest, arguments: "Error while fetching user detail")
        }
        
        
    }
    
}
