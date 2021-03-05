//
//  AuthViewController.swift
//
//  Created by Bossly on 9/10/16.
//  Copyright © 2016 Bossly. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseAuth
import FirebaseMessaging

class WelcomeViewController: UIViewController, FUIAuthDelegate {
    
    @IBOutlet weak var progressView: UIActivityIndicatorView? // view shown while data is loading
    @IBOutlet weak var welcomeView: UIView? // view when data is loaded. like sign-in or intro
    
    var client: AuthClient?

    override func viewDidLoad() {
        self.welcomeView?.isHidden = false
        self.progressView?.isHidden = true
        self.progressView?.stopAnimating()
    }
    
    // FIRAuthUIDelegate
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let errorHandler = error as NSError? {
            self.showError(errorHandler.localizedDescription)
            // print user-info. find more here: https://firebase.google.com/docs/auth/ios/errors
            print(errorHandler.userInfo)
        } else if let currentUser = user {
            // update displayname and photo
            let name = currentUser.displayName ?? kDefaultUsername
            let photo = currentUser.photoURL?.absoluteString ?? kDefaultProfilePhoto
            
            client?.saveUser(userId: currentUser.uid,
                             name: name,
                             photo: photo,
                             override: false)
            // subscribe to receive push notifications
            Messaging.messaging().subscribe(toTopic: "\(kTopicFeed)\(currentUser.uid)")
            // move to next step
            performSegue(withIdentifier: "auth", sender: self)
        } else {
            print("Error occurs while user auth")
        }
    }
    
    // Helpers
    
    func showError(_ error: String) {
        print("Error: \(error)")
        
        let alert = UIAlertController(title: kAlertErrorTitle, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: kAlertErrorDefaultButton, style: .default) { (action) in })
        self.present(alert, animated: true) {}
    }
    
    // Actions
    @IBAction func termsClicked() {
        kEulaUrl.openUrl()
    }

    @IBAction func buttonPressed(_ sender: AnyObject) {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self

        /* 
         * Uncommend this lines to add Google and Facebook authorization. But first 
         * enabled it in Firebase Console. More information you can find here:
         * https://firebase.google.com/docs/auth/ios/google-signin
         * https://firebase.google.com/docs/auth/ios/facebook-login
         */
        var providers: [FUIAuthProvider] = [
            FUIEmailAuth(),
            FUIGoogleAuth(),
            FUIFacebookAuth(),
//            FUITwitterAuth(),
            ]
        
        if #available(iOS 13.0, *) {
            providers.insert(FUIOAuth.appleAuthProvider(), at: 0)
        }

        authUI?.providers = providers

        /*
         kEulaUrl needs to be set in Config.swift file. required for publishing
         */
        authUI?.tosurl = URL(string: kEulaUrl)
        let authViewController = authUI!.authViewController()
        self.present(authViewController, animated: true)
    }
    
}
