//
//  SelectedMediaViewController.swift
//  MetalFilters
//
//  Created by user on 15/06/20.
//  Copyright © 2020 shuifeng.me. All rights reserved.
//

import UIKit
import Photos
import AVKit
import MetalPetal

class SelectedMediaViewController: MediaPickerViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filtersView: UIView!
    
    fileprivate var filterCollectionView: UICollectionView!
    fileprivate var originInputImage: MTIImage?
    fileprivate var adjustFilter = MTBasicAdjustFilter()
    fileprivate var allFilters: [MTFilter.Type] = []
    fileprivate var allTools: [FilterToolItem] = []
    fileprivate var thumbnails: [String: UIImage] = [:]
    fileprivate var cachedFilters: [Int: MTFilter] = [:]
    
    var assets: [PHAsset] = []
    private var media: [Media?] = []
    private var selectedImages = [UIImage]()
    var outputMedia: (([Media?]) -> ())?
    fileprivate var targetSize: CGSize = .zero
    var i = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let itemWidth: CGFloat = (view.frame.width -  CGFloat(1 + 1))/CGFloat(1)
        targetSize = CGSize(width: itemWidth * UIScreen.main.scale, height: itemWidth * UIScreen.main.scale)
        collectionView.register(SelectedMediaCollectionViewCell.self, forCellWithReuseIdentifier: "SelectedMediaCell")

        // Do any additional setup after loading the view.
        addDoneItem()
        intiateV()
        setMediaArray()
        allFilters = MTFilterManager.shared.allFilters
        setupFilterCollectionView()
    }
    
    
    fileprivate func setupFilterCollectionView() {
    
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: filtersView.bounds.height - 44)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        filterCollectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        filterCollectionView.backgroundColor = .clear
        filterCollectionView.showsHorizontalScrollIndicator = false
        filterCollectionView.showsVerticalScrollIndicator = false
        filtersView.addSubview(filterCollectionView)
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.register(FilterPickerCell.self, forCellWithReuseIdentifier: NSStringFromClass(FilterPickerCell.self))
        filterCollectionView.reloadData()
    }
        
    fileprivate func generateFilterThumbnails() {
          DispatchQueue.global().async {
            if self.assets.count > 0
            {
                let size = CGSize(width: 200, height: 200)
                UIGraphicsBeginImageContextWithOptions(size, false, 0)
                self.media[0]?.uiimage?.draw(in: CGRect(origin: .zero, size: size))
                let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                if let image = scaledImage {
                    for filter in self.allFilters {
                        let image = MTFilterManager.shared.generateThumbnailsForImage(image, with: filter)
                        self.thumbnails[filter.name] = image
                        DispatchQueue.main.async {
                            self.filterCollectionView.reloadData()
                        }
                    }
                }
            }
          }
      }
    
    
    func intiateV(){
        for _ in assets{
            media.append(nil)
        }
    }
    
    func setMediaArray(){
        if i >= assets.count{
            //stop loader
            generateFilterThumbnails()
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.reloadData()
            return}
        //start loader
        let asset = assets[i]
        if asset.mediaType == .image{
            let option = PHImageRequestOptions()
            option.deliveryMode = .highQualityFormat
            PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: option) {  (image, _) in
                if let img = image{
                    let media = Media(image: img)
                    self.media[self.i] = media
                    self.selectedImages.append(img)
                }
                self.i+=1;
                self.setMediaArray()
            }
        }
        else if asset.mediaType == .video{
            self.getAvAssetFromPhAsset(asset: asset) { (asset) in
                if let asset = asset as? AVURLAsset{
                    let media = Media(videoUrl: asset.url)
                    self.media[self.i] = media
                }
                self.i+=1;
                self.setMediaArray()
            }
        }
        else {
            self.i+=1;
            self.setMediaArray()
        }
    }
    
    func addDoneItem(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneItem))
    }
    
    @IBAction func doneItem(_ sender: UIButton){
        //start loader
        outputMedia?(media)
    }
}


extension SelectedMediaViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filterCollectionView {
            return allFilters.count
        }
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == filterCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(FilterPickerCell.self), for: indexPath) as! FilterPickerCell
            let filter = allFilters[indexPath.item]
            cell.update(filter)
            cell.thumbnailImageView.image = thumbnails[filter.name]
            return cell
        }else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedMediaCell", for: indexPath) as! SelectedMediaCollectionViewCell
            let asset = assets[indexPath.row]
            cell.assetIdentifier = asset.localIdentifier
            let option = PHImageRequestOptions()
            option.deliveryMode = .highQualityFormat
            cell.playImageView.isHidden = (asset.mediaType != .video)
            cell.cancelBtnAction = {(cell) in
                if cell.assetIdentifier == asset.localIdentifier{
                    self.assets.remove(at: indexPath.row)
                    self.media.remove(at: indexPath.row)
                    if self.assets.count == 0{
                        self.navigationController?.popViewController(animated: true)
                    }
                    self.collectionView.reloadData()
                }
            }
            if let media = media[indexPath.row] , media.mediaType == .image {
                cell.setImage(image: media.uiimage)
            }else{
                PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: option) { [unowned cell] (image, _) in
                    DispatchQueue.main.async {
                        if asset.localIdentifier == cell.assetIdentifier {
                            cell.setImage(image: image)
                        }
                    }
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == filterCollectionView  {
            DispatchQueue.main.async {
                let filter = self.allFilters[indexPath.item].init()
                self.media.removeAll()
                for image in self.selectedImages
                {
                    let ciImage = CIImage(cgImage: image.cgImage!)
                    let originImage = MTIImage(ciImage: ciImage, isOpaque: true)
                    filter.inputImage = originImage
                    if let device = MTLCreateSystemDefaultDevice(),let outputImage = filter.outputImage {
                        do {
                            let context = try MTIContext(device: device)
                            let filteredImage = try context.makeCGImage(from: outputImage)
                            let filterImage = UIImage(cgImage: filteredImage)
                            let media = Media(image: filterImage)
                            //let originImage = MTIImage(ciImage: ciImage, isOpaque: true)
                            self.media.append(media)
                        } catch {
                            print(error)
                        }
                    }
                }
                self.collectionView.reloadData()
            }
        }
        else
        {
            let selectedAsset = assets[indexPath.row]
            if selectedAsset.mediaType == PHAssetMediaType.video{
                PHCachingImageManager().requestAVAsset(forVideo: selectedAsset, options: nil) { (asset, mix, info) in
                    let asset = asset as! AVURLAsset
                    DispatchQueue.main.async {
                        self.moveToVideoTrimmer(asset: asset) { (media) in
                            self.navigationController?.popViewController(animated: true)
                            self.media[indexPath.row] = media
                        }
                    }
                }
            }else{
                loadImageFor(assets[indexPath.row]) { [weak self] (image) in
                    self?.moveToImageEditor(image: image) { (media) in
                        self?.navigationController?.popViewController(animated: true)
                        self?.media[indexPath.row] = media
                        collectionView.reloadItems(at: [indexPath])
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == filterCollectionView
        {
           return CGSize(width: 104, height: filtersView.bounds.height - 44)
        }
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == filterCollectionView
        {
           return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate func loadImageFor(_ asset: PHAsset, loadedImage : @escaping (UIImage?)->()) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = true
        let targetSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        //start loader
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .default, options: options) { (image, _) in
            //stop loader
            DispatchQueue.main.async {
                loadedImage(image)
            }
        }
    }
}
