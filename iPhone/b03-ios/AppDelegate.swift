//
//  AppDelegate.swift
//
//  Created by Bossly on 9/10/16.
//  Copyright © 2016 Bossly. All rights reserved.
//

import UIKit
import Firebase
import FirebaseRemoteConfig
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var shared: AppDelegate {
        // swiftlint:disable:next force_cast
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var window: UIWindow?
    var client: FirebaseClient?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // initialize client
        client = FirebaseClient().setup()
        // create window
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let config = RemoteConfig.remoteConfig()
        
        config.fetch(withExpirationDuration: 5) { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                config.activate(completionHandler: nil)
                self.client?.trackRemoteConfig(loaded: true)
            } else {
                self.client?.trackRemoteConfig(loaded: false)
                let message = error?.localizedDescription ?? "No error available."
                self.client?.trackError(message: message)
                print("Config not fetched: \(message)")
            }
        }

        // present view for current user
        stateChanged(for: Auth.auth().currentUser, in: window)
        // track for auth change
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user == nil {
                self?.stateChanged(for: user, in: self?.window)
            }
        }

        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    // MARK: - Navigation
    
    public func onboardingComplete(with user: User) {
        stateChanged(for: user, in: window)
    }
    
    private func stateChanged(for user: User?, in window: UIWindow?) {
        if user != nil {
            window?.rootViewController = mainView()
        } else {
            window?.rootViewController = onboardingView()
        }

        window?.makeKeyAndVisible()
    }

    private func mainView() -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateInitialViewController()
    }
    
    private func onboardingView() -> UIViewController? {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: Bundle.main)
        let rootController = storyboard.instantiateInitialViewController() as? UINavigationController
        let controller = rootController?.topViewController as? WelcomeViewController
        controller?.client = client // set the client to use
        return controller
    }
}

extension UIApplication
{
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController?
    {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UIImageView
{
    func enlargeImage(view : UIViewController)
    {
        if self.image == nil{return}
        let imageInfo = JTSImageInfo()
        imageInfo.image = self.image
        imageInfo.referenceRect = self.frame
        imageInfo.referenceView = self.superview
        imageInfo.referenceContentMode = self.contentMode
        imageInfo.referenceCornerRadius = self.layer.cornerRadius
        // Setup view controller
        let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode(rawValue: 0)!, backgroundStyle: JTSImageViewControllerBackgroundOptions(rawValue: 2))
        // Present the view controller.
        imageViewer?.show(from: view, transition: JTSImageViewControllerTransition(rawValue: 0)!)
    }
}


extension UIView {
        
    @IBInspectable var corner :CGFloat {

        set { layer.cornerRadius = newValue }

        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var border :CGFloat {

        set { layer.borderWidth = newValue }

        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var color: UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
}
