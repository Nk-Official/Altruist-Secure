//
//  OnboardingViewController.swift
//  Mustage
//
//  Created by Oleg Baidalka on 07.04.2020.
//  Copyright © 2020 Bossly. All rights reserved.
//

import UIKit
import Firebase

class SetupCompleteViewController: GenericViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ClosePopupDelegate {
    
    @IBOutlet weak var usernameField: UITextField?
    @IBOutlet weak var profileImage: ProfileView?
    @IBOutlet weak var uploadActivity: UIActivityIndicatorView?
    
    var user: UserModel?
    var userObject: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = UserModel.current {
            self.user = currentUser
            
            if let _user = self.user {
                _user.fetchInBackground(completed: { (model, success) in
                    self.usernameField?.text = _user.name
                    self.profileImage?.sd_setImage(with: URL(string: _user.photo))
                })
            }
        }
    }
    
    @IBAction func changePhoto(_ sender: Any) {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            picker.dismiss(animated: true, completion: {
                self.profileImage?.image = nil
                self.uploadActivity?.startAnimating()
                
                // resize image
                let newSize = CGSize(width: kProfilePhotoSize, height: kProfilePhotoSize)
                UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
                image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
                let smallImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                
                self.upload(photo: smallImage, with: { (success) in
                    self.profileImage?.image = image
                    self.uploadActivity?.stopAnimating()
                })
            })
        }
    }
    
    func upload(photo: UIImage, with complete:@escaping (Bool) -> Void) {
        
        let storage = Storage.storage().reference()
        let data: Data? = UIImageJPEGRepresentation(photo, kJPEGImageQuality)
        
        guard let userkey = user?.ref.key else {
            return
        }
        
        let imgref = storage.child("\(userkey)-\(NSDate().timeIntervalSince1970).jpg")
        
        // Upload the file to the path "images/"
        imgref.putData(data!, metadata: nil) { metadata, error in
            if error != nil {
                // Uh-oh, an error occurred!
                let alert = UIAlertController(title: kAlertErrorTitle,message: "Can't upload now. Please try later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: kAlertErrorDefaultButton, style: .default) { (action) in })
                self.present(alert, animated: true) {}
                complete(false)
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                imgref.downloadURL(completion: { (url, error) in
                    self.user?.photo = url?.absoluteString ?? ""
                    self.user?.saveData()
                    complete(true)
                })
            }
        }
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: kAlertErrorTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: kAlertErrorDefaultButton, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func completeSetup(with user: User) {
        self.user?.name = self.usernameField?.text ?? kDefaultUsername
        self.user?.saveData()
        userObject = user
        showPopup()
    }
    
    func showPopup()  {
        let destinationVC : PopupViewController = PopupViewController.initiatefromStoryboard(.Onboarding)
        destinationVC.view.frame = self.view.bounds
        destinationVC.type = "register"
        destinationVC.popupDelegate = self
        destinationVC.modalTransitionStyle = .crossDissolve
        destinationVC.modalPresentationStyle = .custom
        present(destinationVC, animated: true, completion: {})
    }
    
    func closePopupView()
    {
        self.dismiss(animated: true, completion: nil)
        AppDelegate.shared.onboardingComplete(with: userObject!)
    }
    
    @IBAction func completeSetup(_ sender: Any) {
        guard
            let user = Auth.auth().currentUser,
            let username = usernameField?.text
            else {
                print("username textfield not set or user not authorized")
                return
        }
        
        if kUniqueUsername {
            self.user?.isUnique(username: username, completion: { (unique) in
                if unique {
                    self.showError(message: "Username is not unique")
                } else {
                    self.completeSetup(with: user)
                }
            })
        } else {
            completeSetup(with: user)
        }
    }
}
