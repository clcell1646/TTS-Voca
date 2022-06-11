//
//  MultipleChoiceView.swift
//  TTS Voca
//
//  Created by 정지환 on 13/06/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import UIKit


class MultipleChoiceView: XibView {
    private let xibName = "MultipleChoiceView"
    var rootView: ViewConnector!
    var learningVoca: LearningVoca!
    let settingDB: SettingDB = SettingDB.getInstance
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var meanLabel: UILabel!
    
    
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    
    var type: Int!
    var answer: Int!
    
    var language: String!
    var word: String!
    var mean: String!
    
    var wordTTS: TTSService!
    var meanTTS: TTSService!
    
    func setData(voca: Voca, wordData: WordData, wordTTS: TTSService, meanTTS: TTSService) {
        disableAllButton()
        
        // 아이패드 보기 글자 크게.
        switch(UIDevice.current.userInterfaceIdiom) {
        case .phone:
            break
        case .pad:
            answerButton1.titleLabel?.font = .systemFont(ofSize: 22.0)
            answerButton2.titleLabel?.font = .systemFont(ofSize: 22.0)
            answerButton3.titleLabel?.font = .systemFont(ofSize: 22.0)
            answerButton4.titleLabel?.font = .systemFont(ofSize: 22.0)
            break
        default:
            break
        }
        
        self.wordTTS = wordTTS
        self.meanTTS = meanTTS
        
        word = wordData.getWord()
        mean = wordData.getMean()
        
        
        let randomAnswer: RandomAnswer = RandomAnswer()
        let answers: [String]!
        type = wordData.getType()
        if(type == 1) {
            wordLabel.text = wordData.getWord()
            meanLabel.text = "?"
            answers = randomAnswer.get4Answers(array: Array(voca.getMeanList()), answer: wordData.getMean())
            answer = Int(answers[4])!
            speechWord()
        } else { // type == 2
            wordLabel.text = "?"
            meanLabel.text = wordData.getMean()
            answers = randomAnswer.get4Answers(array: Array(voca.getWordList()), answer: wordData.getWord())
            answer = Int(answers[4])!
            speechMean()
        }
        answerButton1.setTitle(answers[0], for: .normal)
        answerButton2.setTitle(answers[1], for: .normal)
        answerButton3.setTitle(answers[2], for: .normal)
        answerButton4.setTitle(answers[3], for: .normal)
        
        enableAllButton()
    }
    
    func speechWord() {
        if(settingDB.getTTS()) {
            speechStop()
            wordTTS.speech(word: word)
        }
    }
    
    func speechMean() {
        if(settingDB.getTTS()) {
            speechStop()
            meanTTS.speech(word: mean)
        }
    }
    
    func speechStop() {
        if(settingDB.getTTS()) {
            wordTTS.stop()
            meanTTS.stop()
        }
    }
    @IBAction func speechWordAction(_ sender: UITapGestureRecognizer) {
        if(type == 1) {
            speechWord()
        }
    }
    @IBAction func speechMeanAction(_ sender: UITapGestureRecognizer) {
        if(type == 2) {
            speechMean()
        }
    }
    
    var alreadyTouch: Bool = false
    
    @IBAction func answerAction1(_ sender: UIButton) {
        if(alreadyTouch) {
            return
        } else {
            disableAllButton()
        }
        
        if(answer == 0) {
            correctAnswer()
        } else {
            failAnswer()
        }
    }
    
    @IBAction func answerAction2(_ sender: UIButton) {
        if(alreadyTouch) {
            return
        } else {
            disableAllButton()
        }
        if(answer == 1) {
            correctAnswer()
        } else {
            failAnswer()
        }
    }
    
    @IBAction func answerAction3(_ sender: UIButton) {
        if(alreadyTouch) {
            return
        } else {
            disableAllButton()
        }
        
        if(answer == 2) {
            correctAnswer()
        } else {
            failAnswer()
        }
    }
    
    @IBAction func answerAction4(_ sender: UIButton) {
        if(alreadyTouch) {
            return
        } else {
            disableAllButton()
        }
        
        if(answer == 3) {
            correctAnswer()
        } else {
            failAnswer()
        }
    }
    
    // PresenetWordView에서는 type == 1 이면 한글, type == 2 이면 영어를 읽어줘야한다.
    func correctAnswer() {
        if(type == 1) {
            rootView.nextStage(pass: 1, presentWord: WordData(type: 4, word: word, mean: mean))
        } else {
            rootView.nextStage(pass: 1, presentWord: WordData(type: 5, word: word, mean: mean))
        }
    }
    
    func failAnswer() {
        if(type == 1) {
            rootView.nextStage(pass: 0, presentWord: WordData(type: 6, word: word, mean: mean))
        } else {
            rootView.nextStage(pass: 0, presentWord: WordData(type: 7, word: word, mean: mean))
        }
    }
    
    func enableAllButton() {
        alreadyTouch = false
        answerButton1.isEnabled = true
        answerButton2.isEnabled = true
        answerButton3.isEnabled = true
        answerButton4.isEnabled = true
    }
    
    func disableAllButton() {
        alreadyTouch = true
        answerButton1.isEnabled = false
        answerButton2.isEnabled = false
        answerButton3.isEnabled = false
        answerButton4.isEnabled = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initUI(buttonColor: UIColor) {
        answerButton1.backgroundColor = buttonColor
        answerButton2.backgroundColor = buttonColor
        answerButton3.backgroundColor = buttonColor
        answerButton4.backgroundColor = buttonColor
        
        let radius: CGFloat = 4.0
        answerButton1.layer.cornerRadius = radius
        answerButton2.layer.cornerRadius = radius
        answerButton3.layer.cornerRadius = radius
        answerButton4.layer.cornerRadius = radius
    }
}
