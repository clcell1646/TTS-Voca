//
//  TTSController.swift
//  TTS Voca
//
//  Created by 정지환 on 26/05/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import AVFoundation

class TTSService {
    let synthesizer: AVSpeechSynthesizer
    let ttsLanguage: String
    var utterance: AVSpeechUtterance!
    
    init(language: String) {
        synthesizer = AVSpeechSynthesizer()
        ttsLanguage = language
    }
    
    func speech(word: String) {
        utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: ttsLanguage)
        utterance.rate = SettingDB.getInstance.getTTSSpeed()
        synthesizer.speak(utterance)
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
}
