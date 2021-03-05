//
//  ViewController.swift
//  PryntTrimmerView
//
//  Created by Henry on 27/03/2017.
//  Copyright © 2017 Prynt. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import PryntTrimmerView
import Photos

/// A view controller to demonstrate the trimming of a video. Make sure the scene is selected as the initial
// view controller in the storyboard
class VideoTrimmerViewController: AssetSelectionViewController {

    @IBOutlet weak var selectAssetButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var trimmerView: TrimmerView!

    var player: AVPlayer?
    var playbackTimeCheckerTimer: Timer?
    var trimmerPositionChangedTimer: Timer?

    var asset: AVAsset!
    var clippedVideo: ((Media)->())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trimmerView.handleColor = UIColor.white
        trimmerView.mainColor = UIColor.darkGray
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadAsset(asset)
    }
    @IBAction func cropVideo(_ sender: Any) {
        stopPlayer()
        guard let startTime = trimmerView.startTime, let endTime = trimmerView.endTime, let player = player else {
            return
        }
        cropVideo(asset: asset, startTime: startTime, endTime: endTime, completion: { (url) in
            
//            self.saveVideoToCameraRoll(at: url)
            DispatchQueue.main.async {
                let video = Media(videoUrl: url)
                self.clippedVideo?(video)
            }
            
        }) { (error) in
            self.showAlert(title: "Error", message: error.localizedDescription)
        }
        
    }

    @IBAction func play(_ sender: Any) {

        guard let player = player else { return }

        if !player.isPlaying {
            player.play()
            startPlaybackTimeChecker()
        } else {
            stopPlayer()
        }
    }
    func stopPlayer(){
        guard let player = player else { return }
        player.pause()
        stopPlaybackTimeChecker()
    }

    override func loadAsset(_ asset: AVAsset) {

        trimmerView.asset = asset
        trimmerView.delegate = self
        addVideoPlayer(with: asset, playerView: playerView)
    }

    private func addVideoPlayer(with asset: AVAsset, playerView: UIView) {
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)

        NotificationCenter.default.addObserver(self, selector: #selector(VideoTrimmerViewController.itemDidFinishPlaying(_:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)

        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect(x: 0, y: 0, width: playerView.frame.width, height: playerView.frame.height)
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerView.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
        playerView.layer.addSublayer(layer)
    }

    @objc func itemDidFinishPlaying(_ notification: Notification) {
        if let startTime = trimmerView.startTime {
            player?.seek(to: startTime)
        }
    }

    func startPlaybackTimeChecker() {

        stopPlaybackTimeChecker()
        playbackTimeCheckerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                                        selector:
            #selector(VideoTrimmerViewController.onPlaybackTimeChecker), userInfo: nil, repeats: true)
    }

    func stopPlaybackTimeChecker() {

        playbackTimeCheckerTimer?.invalidate()
        playbackTimeCheckerTimer = nil
    }

    @objc func onPlaybackTimeChecker() {

        guard let startTime = trimmerView.startTime, let endTime = trimmerView.endTime, let player = player else {
            return
        }

        let playBackTime = player.currentTime()
        trimmerView.seek(to: playBackTime)

        if playBackTime >= endTime {
            player.seek(to: startTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
            trimmerView.seek(to: startTime)
        }
    }
    func cropVideo(asset: AVAsset, startTime: CMTime, endTime: CMTime, completion: ((_ outputUrl: URL) -> Void)? = nil, failure: ((_ error: Error) -> Void)? = nil)
    {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let length = Float(asset.duration.value) / Float(asset.duration.timescale)
        print("video length: \(length) seconds")
        let assetUrl = asset as! AVURLAsset
        var outputURL = documentDirectory.appendingPathComponent("output")
        do {
            try fileManager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
            outputURL = outputURL.appendingPathComponent("\(assetUrl.url.lastPathComponent).mp4")
        }catch let error {
            print(error)
        }

        //Remove existing file
        try? fileManager.removeItem(at: outputURL)

        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else { return }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4

        let timeRange = CMTimeRange(start: startTime,
                                    end: endTime)

        exportSession.timeRange = timeRange
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                print("exported at \(outputURL)")
                completion?(outputURL)
            case .failed:
                print("failed \(exportSession.error.debugDescription)")
                failure?(exportSession.error ?? VideoTrimmError.failure)
            case .cancelled:
                print("cancelled \(exportSession.error.debugDescription)")
                failure?(exportSession.error ?? VideoTrimmError.cancelled)
            default: break
            }
        }
    }
    
    func saveVideoToCameraRoll(at url: URL){
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }) { saved, error in
            DispatchQueue.main.async {
                if saved {
                    
                    self.showAlert(title: "Your video was successfully saved", message: nil)
                }else{
                    self.showAlert(title: "Error", message: error?.localizedDescription)
                }
                let fileManager = FileManager.default
                do{
                    try fileManager.removeItem(at: url)
                    print("video deleted from url")
                }
                catch(let error){
                    print("error while deleting video",error.localizedDescription)
                }
            }
        }
    }
}

extension VideoTrimmerViewController: TrimmerViewDelegate {
    func positionBarStoppedMoving(_ playerTime: CMTime) {
        player?.seek(to: playerTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        player?.play()
        startPlaybackTimeChecker()
    }

    func didChangePositionBar(_ playerTime: CMTime) {
        stopPlaybackTimeChecker()
        player?.pause()
        player?.seek(to: playerTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        let duration = (trimmerView.endTime! - trimmerView.startTime!).seconds
        print(duration)
    }
}
