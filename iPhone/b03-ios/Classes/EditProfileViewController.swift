//
//  EditProfileViewController.swift
//  Project
//
//  Created by Bossly on 10/12/16.
//  Copyright © 2016 Bossly. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileView: UITextField?
    @IBOutlet weak var profileBioView: UITextView?
    @IBOutlet weak var profileImage: ProfileView?
    @IBOutlet weak var uploadActivity: UIActivityIndicatorView?
    
    var user: UserModel?
    var imageChanged: Bool = false
    var isProfileImage: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = UserModel.current {
            self.user = currentUser
            
            if let _user = self.user {
                _user.fetchInBackground(completed: { (model, success) in
                    self.profileView?.text = _user.name
                    self.profileBioView?.text = _user.bio
                    self.profileImage?.sd_setImage(with: URL(string: _user.photo))
                })
            }
        }
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: kAlertErrorTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: kAlertErrorDefaultButton, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func save() {
        guard let username = self.profileView?.text else {
            showError(message: "Username cannot be empty")
            return
        }

        self.uploadActivity?.startAnimating()
        self.user?.name = username
        self.user?.bio = self.profileBioView?.text ?? ""
        self.user?.saveData()

        if let image = profileImage?.image, imageChanged {
            // resize image
            let newSize = CGSize(width: kProfilePhotoSize, height: kProfilePhotoSize)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            let smallImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            self.upload(photo: smallImage, with: { (success) in
                self.uploadActivity?.stopAnimating()
                self.navigationController?.popViewController(animated: true)
            })
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func saveUser(_ sender: Any) {
        guard let username = profileView?.text else {
            print("username textfield not set or user not authorized")
            return
        }
        
        if kUniqueUsername {
            self.user?.isUnique(username: username, completion: { (unique) in
                if unique {
                    self.showError(message: "Username is not unique")
                } else {
                    self.save()
                }
            })
        } else {
            save()
        }
    }
    
    @IBAction func changePhoto(_ sender: UIButton) {
        isProfileImage = sender.tag == 1 ? true : false
        let picker: UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            picker.dismiss(animated: true, completion: {
                self.profileImage?.image = image
                self.imageChanged = true
                self.moveToImageEditor(image: image)
            })
        }
    }
    
    func moveToImageEditor(image: UIImage){
           guard let editorController = UIStoryboard(name: "Editor", bundle: nil).instantiateViewController(withIdentifier: "PhotoEditorViewController") as? PhotoEditorViewController else {
                   return
           }
           editorController.croppedImage = image
           editorController.outputImage = {(image) in
            self.profileImage?.image = image?.uiimage
            self.navigationController?.popViewController(animated: true)
           }
        self.navigationController?.pushViewController(editorController, animated: true)
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
                let alert = UIAlertController(title: kAlertErrorTitle,
                                              message: "Can't upload now. Please try later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: kAlertErrorDefaultButton, style: .default) { (action) in })
                self.present(alert, animated: true) {}
                complete(false)
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                imgref.downloadURL(completion: { (url, error) in
                    if self.isProfileImage
                    {
                        self.user?.photo = url?.absoluteString ?? ""
                    }else
                    {
                        self.user?.backgroundPhoto = url?.absoluteString ?? ""
                        UserDefaults.standard.setBackgroundImage(url?.absoluteString ?? "")
                    }
                    self.user?.saveData()
                    complete(true)
                })
            }
        }
    }
}
