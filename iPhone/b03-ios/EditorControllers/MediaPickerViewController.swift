
//
//  MediaPickerViewController.swift
//  Mustage
//
//  Created by user on 16/06/20.
//  Copyright © 2020 shuifeng.me. All rights reserved.
//

import UIKit
import AVKit
import Photos

class MediaPickerViewController: UIViewController{
    
    let mainStoryBoard = UIStoryboard(name: "Editor", bundle: nil)

    
    func moveToImageEditor(image: UIImage?, outputImage: ((Media?)->())? ){
           guard let editorController = mainStoryBoard.instantiateViewController(withIdentifier: "PhotoEditorViewController") as? PhotoEditorViewController else {
                   return
           }
           editorController.croppedImage = image
           editorController.outputImage = outputImage
            navigationController?.pushViewController(editorController, animated: true)
       }
       
    func moveToVideoTrimmer(asset:  AVAsset, outputVideo: ((Media)->())?){
           guard let editorController = mainStoryBoard.instantiateViewController(withIdentifier: "VideoTrimmerViewController") as? VideoTrimmerViewController else {
               return
           }
           editorController.asset = asset
           editorController.clippedVideo = outputVideo
           navigationController?.pushViewController(editorController, animated: true)
       }
       
       func moveToLibrary(){
           guard let libraryController = self.mainStoryBoard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {
               return
           }
           libraryController.selectedMedia = {
               (assets) in
               
           }
           self.navigationController?.pushViewController(libraryController, animated: true)
       }
    
    func moveToSelectMediaController(media: [PHAsset], output: @escaping ([Media?])->()){
        guard let editorController = mainStoryBoard.instantiateViewController(withIdentifier: "SelectedMediaViewController") as? SelectedMediaViewController else {
           return
        }
        editorController.assets = media
        editorController.outputMedia = output
        navigationController?.pushViewController(editorController, animated: false)
    }
    
    func getAvAssetFromPhAsset(asset: PHAsset, avasset: @escaping (AVAsset?)->()){
        
        PHCachingImageManager().requestAVAsset(forVideo: asset, options: nil) { (asset, mix, info) in
            DispatchQueue.main.async {
                avasset(asset)
            }
        }
    }
}
