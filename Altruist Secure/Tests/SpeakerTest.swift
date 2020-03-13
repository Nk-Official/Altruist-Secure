//
//  SpeakerTest.swift
//  Altruist Secure
//
//  Created by Namrata Khanduri on 13/03/20.
//  Copyright © 2020 Namrata Khanduri. All rights reserved.
//

import AVFoundation
class SpeakerTest : NSObject, DeviceTester{
    
    //MARK: - PROPERTY
    var audioPlayer = AVAudioPlayer()
    private var soundFiles = [Sound]()
    private var lastPlayedFile: Sound?
    //MARK: - INTITALISE
    override init() {
        super.init()
        let sound1 = Sound(name: "sound1", enterValue: 1)
        soundFiles = [sound1]
        
    }
    
    
    //MARK: - TEST
    func startTest(_ viewController: UIViewController) {
        suffleAndPlay()
    }
    private func suffleAndPlay(){
        
        soundFiles.shuffle()
        play(sound: soundFiles.first!)
    }
    func check(entered value: Int) throws ->Bool{
        if lastPlayedFile == nil{
            throw CustomError.customerror("No Sound Played yet")
        }
        return value == lastPlayedFile!.enterValue
    }
    //MARK: - AUDIO PLAYER
    private func play(sound: Sound){
        let path = Bundle.main.path(forResource: sound.name, ofType:"mp3")!
        let url = URL(fileURLWithPath: path)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
            audioPlayer.play()
            lastPlayedFile = sound
        } catch {
            fatalError("could not find sound file")
        }
    }
}


extension SpeakerTest : AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("finish playing")
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("error while playing audio",error?.localizedDescription)
    }
}

struct Sound{
    var name:String
    var enterValue: Int
}
