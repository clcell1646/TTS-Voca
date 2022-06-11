//
//  ShortAnswerView.swift
//  TTS Voca
//
//  Created by 정지환 on 13/06/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import UIKit


class ShortAnswerView: XibView, UITextFieldDelegate {
    private let xibName = "ShortAnswerView"
    var rootView: ViewConnector!
    var learningVoca: LearningVoca!
    let settingDB: SettingDB = SettingDB.getInstance
    
    @IBOutlet weak var wordTF: UITextField!
    @IBOutlet weak var meanLabel: UILabel!
    
    var word: String!
    var mean: String!
    
    var meanTTS: TTSService!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setData(wordData: WordData, meanTTS: TTSService) {
        self.word = wordData.getWord()
        self.mean = wordData.getMean()
        
        // set label text
        meanLabel.text = mean
        
        self.meanTTS = meanTTS
        
        speechMean()
        
        wordTF.becomeFirstResponder()
    }
    
    @IBAction func speechMeanAction(_ sender: UITapGestureRecognizer) {
        speechMean()
    }
    
    func speechMean() {
        if(settingDB.getTTS()) {
            speechStop()
            meanTTS.speech(word: mean)
        }
    }
    
    func speechStop() {
        if(settingDB.getTTS()) {
            meanTTS.stop()
        }
    }
    
    func initUI() {
        wordTF.delegate = self
    }
    
    func focusTF() {
        wordTF.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(wordTF.text! == word) {
            rootView.nextStage(pass: 1, presentWord: WordData(type: 5, word: word, mean: mean))
        } else {
            rootView.nextStage(pass: 0, presentWord: WordData(type: 7, word: word, mean: mean))
        }
        wordTF.text = ""
        self.endEditing(true)
        wordTF.becomeFirstResponder()
        return true
    }
}
