//
//  MainViewController.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/9.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import Photos
import Metal
import MetalKit
import AVKit
import PryntTrimmerView

class MainViewController: MediaPickerViewController {
    
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var albumView: UIView!
    fileprivate var scrollView: MTScrollView!
    fileprivate var selectedAsset: PHAsset?
    @IBOutlet weak var multipleSelectionButton: UIButton!
    
    @IBOutlet weak var zoomButton: UIButton!
    fileprivate var albumController: AlbumPhotoViewController?
    fileprivate var videoPreviewController: VideoPreviewViewController?

    
    var selectedMedia: (([Media?])->())?
    var selectionLimit: Int = 0
    var mediaType: String?

    @IBAction func multiPleSelection(_ sender: UIButton){
        if albumController == nil{return}
        albumController?.multipleSelection = !(albumController?.multipleSelection ?? true)
        albumController?.setMultipleSelection()
        if let asset = selectedAsset, albumController!.multipleSelection{
            albumController?.selected = [asset]
        }else if !albumController!.multipleSelection{
            albumController?.selected.removeAll()
        }
        let image: UIImage? = albumController?.multipleSelection ?? false ? UIImage(named: "yp_multiple_colored") : UIImage(named: "yp_multiple")
        sender.setImage(image, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Social Cross"
        multipleSelectionButton.isHidden = mediaType == "photos" ? false : true
        requestPhoto()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         setupScrollView()
        setVideoPreview()
    }
    
    private func setupScrollView() {
        if scrollView != nil{return}
        scrollView = MTScrollView(frame: photoView.bounds)
        photoView.addSubview(scrollView)
    }
    func setVideoPreview(){
        if videoPreviewController != nil {return}
        guard let videoPreview = mainStoryBoard.instantiateViewController(withIdentifier: "VideoPreviewViewController") as? VideoPreviewViewController else{return}
        videoPreview.view.frame = photoView.bounds
        photoView.addSubview(videoPreview.view)
        addChildViewController(videoPreview)
        videoPreview.didMove(toParentViewController: self)
        self.videoPreviewController = videoPreview
    }
    
    fileprivate func requestPhoto() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    PHPhotoLibrary.shared().register(self)
                    self.loadPhotos()
                }
                break
            case .notDetermined:
                break
            default:
                break
            }
        }
    }
    
    fileprivate func loadPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.wantsIncrementalChangeDetails = false
        fetchOptions.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: false) ]
        if mediaType == "photos"
        {
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        }
        else
        {
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d",  PHAssetMediaType.video.rawValue)
        }
        
        let result = PHAsset.fetchAssets(with: fetchOptions)
        if let firstAsset = result.firstObject {
            if firstAsset.mediaType == .video{
                self.convertPhAssetToAvAsset(phasset: firstAsset) { (avasset) in
                    if avasset != nil{
                        self.showVideoPreview(asset: avasset!)
                    }
                }
            }else{
                loadImageFor(firstAsset)
            }
        }
        
        if let controller = albumController {
            controller.update(dataSource: result)
        } else {
            let albumController = AlbumPhotoViewController(dataSource: result)
            albumController.didSelectAssetHandler = { [weak self] selectedAsset in
                self?.resetVideoPreview()
                self?.loadImageFor(selectedAsset)
            }
            albumController.view.frame = albumView.bounds
            albumController.selectionLimit = selectionLimit
            albumView.addSubview(albumController.view)
            addChildViewController(albumController)
            albumController.didMove(toParentViewController: self)
            self.albumController = albumController
        }
    }
    
    fileprivate func loadImageFor(_ asset: PHAsset) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = true
        let targetSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .default, options: options) { (image, _) in
            if asset.mediaType == .video{
                DispatchQueue.main.async {
                    self.convertPhAssetToAvAsset(phasset: asset) { (avasset) in
                        if asset != nil{
                            self.showVideoPreview(asset: avasset!)
                        }
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.showPhotoPreview(image: image)
                }
            }
        }
        selectedAsset = asset
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func zoomButtonAction(_ sender: Any) {
        let contentMode: CGSize = scrollView.imageView.frame.size == photoView.bounds.size ? scrollView.actualSizeFor(scrollView.imageView.image!) : photoView.bounds.size
        UIView.transition(with: scrollView.imageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.scrollView.imageView.frame.size = contentMode
            let offset = CGPoint(x: 0, y: 0)
            self.scrollView.setContentOffset(offset, animated: false)
        }, completion: nil)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if albumController?.multipleSelection ?? false{
            moveToSelectMediaController(media: albumController!.selected, output: {
                [weak self] (media) in
                self?.navigationController?.popViewController(animated: false)
                self?.selectedMedia?(media)
            })
            
        }else{
            if selectedAsset?.mediaType == PHAssetMediaType.video{
                convertPhAssetToAvAsset(phasset: selectedAsset!) { (avasset) in
                    if avasset == nil{return}
                    DispatchQueue.main.async {
                        self.moveToVideoTrimmer(asset: avasset!) { (media) in
                            self.navigationController?.popViewController(animated: false)
                            self.selectedMedia?([media])
                        }
                    }
                }
            }else {
                
                if let snapshotImage : UIImage = photoView.screenshot()
                {
                    moveToImageEditor(image: snapshotImage) { (media) in
                        self.navigationController?.popViewController(animated: false)
                        self.selectedMedia?([media])
                    }
                }
            }
        }
    }
    
}

extension MainViewController: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        self.loadPhotos()
    }
}

extension MainViewController {
    func showVideoPreview(asset: AVAsset){
        videoPreviewController?.view.isHidden = false
        videoPreviewController?.addPlayer(with: asset)
        scrollView.isHidden  =  true
    }
    func showPhotoPreview(image: UIImage?){
        videoPreviewController?.view.isHidden = true
        scrollView.image = image
        scrollView.isHidden  =  false
    }
    func resetVideoPreview(){
        videoPreviewController?.removePlayer()
    }
    func convertPhAssetToAvAsset(phasset: PHAsset, convertedAsset: @escaping (AVAsset?)->()) {
        PHCachingImageManager().requestAVAsset(forVideo: phasset, options: nil) { (asset, mix, info) in
//            let asset = asset as! AVURLAsset
            DispatchQueue.main.async{
                convertedAsset(asset)
            }
        }
    }
}

extension UIView {

//MARK: - screenshot
func screenshot() -> UIImage? {
    // Begin context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
    // Draw view in that context
    guard let currentContext = UIGraphicsGetCurrentContext() else{
        return nil
    }
    layer.render(in: currentContext)
    // And finally, get image
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}
}
