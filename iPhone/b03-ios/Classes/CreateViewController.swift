//
//  CreateViewController.swift
//  b03-ios
//
//  Created by Bossly on 9/12/16.
//  Copyright © 2016 Bossly. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import MobileCoreServices
import Photos

class CreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var previewView: UIImageView?
    @IBOutlet weak var descriptionView: UITextView? {
        didSet {
            descriptionView?.layer.cornerRadius = 6
        }
    }
    @IBOutlet weak var descriptionPlaceholderView: UILabel?
    @IBOutlet weak var progressView: UIProgressView?
    @IBOutlet weak var progressLabel: UILabel?
    @IBOutlet weak var shareButton: UIBarButtonItem?
    @IBOutlet weak var hintLabel: UILabel?
    @IBOutlet weak var collectionView: UICollectionView!

    var previewImage: UIImage? {
        didSet {
            previewView?.image = previewImage
            shareButton?.isEnabled = (previewImage != nil)
            hintLabel?.isHidden = (previewImage != nil)
        }
    }
    var videoData: Data?
    var multipleImagesUrl = [String]()
    var multipleImages = [UIImage?]()
    var imagesCount : Int = 0
    var editedImagesAsset = [PHAsset]()
    let mainStoryBoard = UIStoryboard(name: "Editor", bundle: nil)
    
    override func viewDidLoad() {
        
        collectionView.register(SelectedMediaCollectionViewCell.self, forCellWithReuseIdentifier: "SelectedMediaCell")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.openPicker(true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        descriptionView?.becomeFirstResponder()
    }
    
    @IBAction func shareStory(_ sender: Any) {
        self.view.endEditing(true)
        uploadMedia()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    
    @IBAction func onEditMedia(_ sender: Any) {
        openPicker()
    }
    
    // MARK: - Helpers
    
    func openPicker(_ animated: Bool = true) {
        self.progressView?.isHidden = true
        self.progressLabel?.isHidden = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // Has camera
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                self.openCamera(.photo)
            }))
            
            alert.addAction(UIAlertAction(title: "Recorder", style: .default, handler: { (action) in
                self.openCamera(.video)
            }))
            
            alert.addAction(UIAlertAction(title: "Library Photos", style: .default, handler: { (action) in
                self.moveToLibrary(type : "photos")
            }))
            alert.addAction(UIAlertAction(title: "Library Videos", style: .default, handler: { (action) in
                self.moveToLibrary(type : "videos")
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            present(alert, animated: true, completion: nil)
        } else {
            self.openLibrary(animated)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        
        guard let mediaType = info[UIImagePickerControllerMediaType] as? String else {
             return
        }
        
        if "public.movie".compare(mediaType).rawValue == 0,
            let video = info[UIImagePickerControllerMediaURL] as? URL {
            self.setupVideoData(video: video)
        } else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            multipleImages.append(image)
            previewImage = image
            videoData = nil
        }
        
        // hide picker and show uploading process
        picker.dismiss(animated: true, completion: {})
    }
    
    func onCompleted() {
        self.dismiss(animated: true, completion: {})
    }
    
    func uploadMedia() {
        if imagesCount <= multipleImages.count
        {
            let postImage = multipleImages[imagesCount]
            imagesCount = imagesCount + 1
            self.shareButton?.isEnabled = false
            
            guard let image = postImage,
                let data = UIImageJPEGRepresentation(image, kJPEGImageQuality) else {
                let message = "Cannot generate thumbnail for selected video"
                let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
                self.shareButton?.isEnabled = true
                return
            }
            
            self.progressView?.isHidden = false
            self.progressLabel?.isHidden = false
            self.progressView?.progress = Float(0)

            // Data in memory
            let storage = Storage.storage().reference()
            let type = (videoData == nil) ? ".jpg" : ".mov"

            if let user = Auth.auth().currentUser {
                let imgref = storage.child("\(user.uid)/\(NSDate().timeIntervalSince1970).jpg")
                let metadata = StorageMetadata(dictionary: [ "contentType": "image/jpg"])
                
                // Upload the file to the path "media/"
                let uploadTask = imgref.putData(data, metadata: metadata) { metadata, error in
                    if error != nil {
                        // Uh-oh, an error occurred!
                        let alert = UIAlertController(title: kAlertErrorTitle, message: "Can't upload now. Please try later", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: kAlertErrorDefaultButton, style: .default) { (action) in })
                        self.present(alert, animated: true) {}
                        self.shareButton?.isEnabled = true
                    } else {
                        imgref.downloadURL(completion: { (url, error) in
                            let urlImage = url?.absoluteString ?? ""
                            
                            if let video = self.videoData {
                                let videoref = storage.child("\(user.uid)/\(NSDate().timeIntervalSince1970)\(type)")
                                let videoMeta = StorageMetadata(dictionary: [ "contentType": "video/quicktime"])
                                videoref.putData(video, metadata: videoMeta) { metadata, error in
                                    videoref.downloadURL(completion: { (vurl, verror) in
                                        let videourl = vurl?.absoluteString ?? ""
                                        let comment = self.descriptionView?.text
                                        Story.createStory(user, url: urlImage, video: videourl, multiple: self.multipleImagesUrl, comment: comment)
                                        self.onCompleted()
                                        self.multipleImages.removeAll()
                                        self.multipleImagesUrl.removeAll()
                                        self.imagesCount = 0
                                    })
                                }
                                self.shareButton?.isEnabled = true
                                self.progressView?.isHidden = true
                                self.progressLabel?.text = kMessageUploadingDone
                                
                            } else {
                                self.multipleImagesUrl.append(urlImage)
                                if self.imagesCount >= self.multipleImages.count
                                {
                                    let comment = self.descriptionView?.text
                                    Story.createStory(user, url: urlImage, video: "", multiple: self.multipleImagesUrl, comment: comment)
                                    self.onCompleted()
                                    self.shareButton?.isEnabled = true
                                    self.progressView?.isHidden = true
                                    self.progressLabel?.text = kMessageUploadingDone
                                    self.multipleImages.removeAll()
                                    self.multipleImagesUrl.removeAll()
                                    self.imagesCount = 0

                                }else
                                {
                                    self.uploadMedia()
                                }
                            }
                        })
                    }
                }
                uploadTask.observe(.progress) { snapshot in
                    // A progress event occurred
                    if let progress = snapshot.progress {
                        let complete = Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                        let percentComplete = Int(complete * 98) + 1 // never show 0% or 100%
                        self.progressView?.progress = Float(complete)
                        self.progressLabel?.text = "\(kMessageUploadingProcess): \(percentComplete)%"
                    }
                }
            } else {
                self.shareButton?.isEnabled = true
            }
        }
    }
    
    func openCamera(_ mode: UIImagePickerControllerCameraCaptureMode = .photo, _ animated: Bool = true) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.videoMaximumDuration = 60 // seconds
        
        if mode == .video {
            picker.mediaTypes = [kUTTypeMovie] as [String]
            picker.cameraCaptureMode = mode
        } else if let types = UIImagePickerController.availableMediaTypes(for: .camera) {
            picker.mediaTypes = types
        }
        
        picker.delegate = self
        self.present(picker, animated: animated, completion: nil)
    }
    
    func openLibrary(_ animated: Bool = true) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.videoMaximumDuration = 60 // seconds
        if let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
            picker.mediaTypes = mediaTypes
        }
        picker.delegate = self
        
        self.present(picker, animated: animated, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: {})
    }
}

extension CreateViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return multipleImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedMediaCell", for: indexPath) as! SelectedMediaCollectionViewCell
        cell.cancelBtnAction = {(cell) in
            self.multipleImages.remove(at: indexPath.row)
            if self.multipleImages.count == 1
            {
                self.previewView?.isHidden = false
                self.collectionView.isHidden = true
            }
            self.collectionView.reloadData()
        }
        if let media : UIImage = multipleImages[indexPath.row]{
            cell.setImage(image: media)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}


extension CreateViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        descriptionPlaceholderView?.isHidden = !textView.text.isEmpty
    }
}

extension CreateViewController {
    
    func moveToImageEditor(image: UIImage){
        guard let editorController = mainStoryBoard.instantiateViewController(withIdentifier: "PhotoEditorViewController") as? PhotoEditorViewController else {
                return
        }
        editorController.croppedImage = image
        editorController.outputImage = {(image) in
            self.navigationController?.popViewController(animated: true)
        }
         navigationController?.pushViewController(editorController, animated: true)
    }
    
    func moveToVideoTrimmer(asset:  AVAsset){
        guard let editorController = mainStoryBoard.instantiateViewController(withIdentifier: "VideoTrimmerViewController") as? VideoTrimmerViewController else {
            return
        }
        editorController.asset = asset
        editorController.clippedVideo = {(media) in
            //do something with video url
            //editorController.saveVideoToCameraRoll(at: url)
            self.navigationController?.popViewController(animated: true)
        }
        navigationController?.pushViewController(editorController, animated: true)
    }
    
    func moveToLibrary(type : String){
        guard let libraryController = self.mainStoryBoard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {
            return
        }
        // set selection limit
        self.collectionView.isHidden = true
        self.previewView?.isHidden = false
        libraryController.selectionLimit = 10
        libraryController.mediaType = type
        libraryController.selectedMedia = {(assets) in
            self.navigationController?.popViewController(animated: false)
            if assets.count > 0
            {
                if assets[0]?.mediaType == Media.Mediatype.video
                {
                    self.setupVideoData(video: (assets[0]?.videourl)!)
                }
                else
                {
                    self.previewImage = assets[0]?.uiimage
                    for asset in assets
                    {
                        self.multipleImages.append(asset?.uiimage)
                    }
                    if assets.count > 1
                    {
                        self.previewView?.isHidden = true
                        self.collectionView.isHidden = false
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        self.navigationController?.pushViewController(libraryController, animated: true)
    }
    
    func setupVideoData(video : URL)  {
        
        videoData = try? Data(contentsOf: video)
        let asset = AVAsset(url: video)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        if asset.tracks(withMediaType: .video).count > 0 {
            var time = asset.duration
            time.value = min(time.value, 2)
            if let imageRef = try? imageGenerator.copyCGImage(at: time, actualTime: nil) {
                let image = UIImage(cgImage: imageRef)
                multipleImages.append(image)
                previewImage = image
            }
        } else {
        }
    }
}

extension CreateViewController {

    func convertPhAssetToAvAsset(phasset: PHAsset, convertedAsset: @escaping (AVAsset?)->()) {
        PHCachingImageManager().requestAVAsset(forVideo: phasset, options: nil) { (asset, mix, info) in
            DispatchQueue.main.async{
                convertedAsset(asset)
            }
        }
    }
}
