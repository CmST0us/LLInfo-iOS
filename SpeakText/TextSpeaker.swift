//
//  TextSpeakHelper.swift
//  LLInfo
//
//  Created by CmST0us on 2018/2/4.
//  Copyright © 2018年 eki. All rights reserved.
//

import Foundation
import AVFoundation

class TextSpeaker {
    
    var rate: Float = AVSpeechUtteranceDefaultSpeechRate
    var voiceLanguage: String? = nil
    private(set) weak var delegate: AVSpeechSynthesizerDelegate? = nil
    private lazy var synthesizer: AVSpeechSynthesizer = {
        return AVSpeechSynthesizer()
    }()
    
    init(delegate: AVSpeechSynthesizerDelegate?) {
        self.delegate = delegate
    }
    
}
// MARK: - test speak method
extension TextSpeaker {
    func speak(text: String) {
        let u = AVSpeechUtterance(string: text)
        u.rate = self.rate
        u.voice = AVSpeechSynthesisVoice(language: self.voiceLanguage)
        self.synthesizer.speak(u)
    }
    
    func speak(text: String, language: String) {
        let u = AVSpeechUtterance(string: text)
        u.rate = self.rate
        u.voice = AVSpeechSynthesisVoice(language: language)
        self.synthesizer.speak(u)
    }
    
    func stop(){
        self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
}

