/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import AVKit
import MobileCoreServices

class VideoPreviewViewController: UIViewController {
  
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?{
        didSet{
            imageView?.image = image
        }
    }
    var asset: AVAsset!
    fileprivate var playerController: AVPlayerViewController?

    
    @IBAction func playVideo(_ sender: AnyObject) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if playerController == nil{
           setUpVideoView()
        }
    }
    private func setUpVideoView(){
       playerController = AVPlayerViewController()
       
       playerController!.view.frame = view.bounds
       view.addSubview(playerController!.view)
        addChildViewController(playerController!)
        playerController!.didMove(toParentViewController: self)
    }
    func addPlayer(with asset: AVAsset){
        let item = AVPlayerItem(asset: asset)
         let player = AVPlayer(playerItem: item)
        playerController!.player = player
        
        
    }
    func removePlayer(){
        
    }
}

