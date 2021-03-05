//
//  StartViewController.swift
//  Mustage
//
//  Created by user on 16/06/20.
//  Copyright © 2020 shuifeng.me. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

class StartViewController: UIViewController {

    let mainStoryBoard = UIStoryboard(name: "Editor", bundle: nil)

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func button(_ sender: UIButton){
        presentActionSheet()
    }

    func presentActionSheet(){
        let vc = UIImagePickerController()
        vc.delegate = self

        let alertController = UIAlertController(title: nil  , message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            vc.sourceType = .camera
            self.present(vc, animated: true)
        }
        let recorderAction = UIAlertAction(title: "Recorder", style: .default) { (action) in
            vc.sourceType = .camera
            vc.mediaTypes = [kUTTypeMovie as String]
            vc.allowsEditing = true
            self.present(vc, animated: true, completion: nil)
        }
        let libraryAction = UIAlertAction(title: "Library", style: .default) { (action) in
            self.moveToLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        alertController.addAction(cameraAction)
        alertController.addAction(recorderAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

}


extension StartViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage  {
            self.moveToImageEditor(image: image)
        }
        else if let mediaType = info[UIImagePickerControllerMediaType] as? String,
          mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerControllerMediaURL] as? URL,
          UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
           { // Handle a movie capture
            
            let media = Media(videoUrl: url)
            // got the media
            
//            let asset = AVAsset(url: url)
//            moveToVideoTrimmer(asset: asset)
//           UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
            }
    }
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
      let title = (error == nil) ? "Success" : "Error"
      let message = (error == nil) ? "Video was saved" : "Video failed to save"
      showAlert(title: title, message: message)
      
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


extension StartViewController {
    
    func moveToImageEditor(image: UIImage){
        guard let editorController = mainStoryBoard.instantiateViewController(withIdentifier: "PhotoEditorViewController") as? PhotoEditorViewController else {
                return
        }
        editorController.croppedImage = image
        editorController.outputImage = {
            (image) in
            self.navigationController?.popViewController(animated: true)
            //DO WITH IMAGE
            self.label.text = "One image selected"
        }
         navigationController?.pushViewController(editorController, animated: true)
    }
    
    func moveToVideoTrimmer(asset:  AVAsset){
        guard let editorController = mainStoryBoard.instantiateViewController(withIdentifier: "VideoTrimmerViewController") as? VideoTrimmerViewController else {
            return
        }
        editorController.asset = asset
        editorController.clippedVideo = {
            (media) in
            //do something with video url
            //editorController.saveVideoToCameraRoll(at: url)
            
            self.label.text = "One Video selected"
            self.navigationController?.popViewController(animated: true)
        }
        navigationController?.pushViewController(editorController, animated: true)
    }
    
    func moveToLibrary(){
        guard let libraryController = self.mainStoryBoard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {
            return
        }
        // set selection limit
        libraryController.selectionLimit = 0
        libraryController.selectedMedia = {
            (assets) in
            self.navigationController?.popViewController(animated: false)
            self.label.text = "multiple selected"
            // do something with selected items
        }
        self.navigationController?.pushViewController(libraryController, animated: true)
    }
    
}
