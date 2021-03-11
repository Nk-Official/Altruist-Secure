//
//  SpeakerTest.swift
//  Runner
//
//  Created by user on 06/04/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import AVKit
class SpeakerTest: NSObject {
    
    //MARK: - PROPERTIES
    let speechSynthesizer = AVSpeechSynthesizer()
    private var value: String = ""
    var speakerTestResult: ((Bool)->())?
    
    //MARK: - INIT
    init(value: Int) {
        self.value = "Click \(value)"
        super.init()
        speechSynthesizer.delegate = self
    }
    
    func playSpeech(){
        let speechUtterance = AVSpeechUtterance(string: value)
        speechSynthesizer.speak(speechUtterance)
    }
    
}

//MARK: - AVSpeechSynthesizerDelegate
extension SpeakerTest: AVSpeechSynthesizerDelegate{
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        speakerTestResult?(true)
    }
    
}
