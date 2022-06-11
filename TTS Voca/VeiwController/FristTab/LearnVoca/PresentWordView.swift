//
//  PresentWordView.swift
//  TTS Voca
//
//  Created by 정지환 on 13/06/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import UIKit


class PresentWordView: XibView {
    private let xibName = "PresentWordView"
    var rootView: ViewConnector!
    var rootViewController: UIViewController!
    let settingDB: SettingDB = SettingDB.getInstance
    let ttsData: TTSData = TTSData()
    
    @IBOutlet weak var passFailImageView: UIImageView!
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var meanLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var language: String!
    var word: String!
    var mean: String!
    
    var wordTTS: TTSService!
    var meanTTS: TTSService!
    
    // 이하는 사전
    @IBOutlet weak var dictView1: UIView!
    @IBOutlet weak var dictView2: UIView!
    
    @IBOutlet weak var dictTitleLabel1: UILabel!
    @IBOutlet weak var dictTitleLabel2: UILabel!
    
    @IBOutlet weak var dictImageView1: UIImageView!
    @IBOutlet weak var dictImageView2: UIImageView!
    
    // set Form LearningVC. -start-
    var isKorean: Bool!
    var dictImageHide1: Bool!
    var dictImageHide2: Bool!
    var dictPrefix1: String!
    var dictSuffix1: String!
    var dictPrefix2: String!
    var dictSuffix2: String!
    // set From LearningVC. -end-
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // passFail = [ 0: 그냥 디스플레이(영어 TTS) , 1: 단어 맞춤 (한글 TTS), 2: 단어 맞춤 (영어 TTS), 3: 단어 틀림 (한글 TTS), 4: 단어 틀림 (영어 TTS) ]
    func setData(language: String, wordData: WordData, wordTTS: TTSService, meanTTS: TTSService, presentType: Int) {
        rootViewController = rootView.getRootViewController()
        
        self.language = language
        self.word = wordData.getWord()
        self.mean = wordData.getMean()
        
        // set label text
        wordLabel.text = word
        meanLabel.text = mean
        
        self.wordTTS = wordTTS
        self.meanTTS = meanTTS
        
        
        switch presentType {
        case 0: // 기본
            speechWord()
            passFailImageView.alpha = 0
            break
        case 1: // 문제 성공, 한글 읽기
            speechMean()
            passFailImageView.alpha = 0
            setPassImageView()
            break
        case 2: // 문제 성공, 영어 읽기
            speechWord()
            passFailImageView.alpha = 0
            setPassImageView()
            break
        case 3: // 문제 실패, 한글 읽기
            speechMean()
            passFailImageView.alpha = 0
            setFailImageView()
            break
        case 4: // 문제 실패, 영어 읽기
            speechWord()
            passFailImageView.alpha = 0
            setFailImageView()
            break
        default:
            break
        }
    }
    
    func setDictionaryData(isKorean: Bool, dictImageHide1: Bool, dictImageHide2: Bool, dictionary1: Dictionary, dictionary2: Dictionary) {
        self.isKorean = isKorean
        
        self.dictImageView1.isHidden = dictImageHide1
        self.dictImageView2.isHidden = dictImageHide2
        
        self.dictPrefix1 = dictionary1.getPrefix()
        self.dictSuffix1 = dictionary1.getSuffix()
        
        self.dictPrefix2 = dictionary2.getPrefix()
        self.dictSuffix2 = dictionary2.getSuffix()
        
        if(dictPrefix1 == "none") {
            dictTitleLabel1.text = "No dictionary".localized
            dictView1.alpha = 0.4
        } else {
            dictTitleLabel1.text = dictionary1.getTitle()
            dictView2.alpha = 1.0
        }
        
        if(dictPrefix2 == "none") {
            dictTitleLabel2.text = "No dictionary".localized
            dictView2.alpha = 0.4
        } else {
            dictTitleLabel2.text = dictionary2.getTitle()
            dictView2.alpha = 1.0
        }
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
        speechWord()
    }
    
    @IBAction func speechMeanAction(_ sender: UITapGestureRecognizer) {
        speechMean()
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        speechStop()
        rootView.nextStage(pass: -1, presentWord: WordData(type: 0, word: "", mean: ""))
    }
    
    func setPassImageView() {
        passFailImageView.image = UIImage(named: "pass")
        passFailImageView.alpha = 1.0
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.passFailImageView.alpha = 0.0
            self.passFailImageView.layoutIfNeeded()
        })
    }
    
    func setFailImageView() {
        passFailImageView.image = UIImage(named: "fail")
        passFailImageView.alpha = 1.0
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.passFailImageView.alpha = 0.0
            self.passFailImageView.layoutIfNeeded()
        })
    }
    
    func initUI(buttonColor: UIColor, borderColor: UIColor) {
        dictView1.layer.cornerRadius = 4
        dictView1.layer.borderWidth = 0.7
        dictView1.layer.borderColor = borderColor.cgColor
        
        dictView2.layer.cornerRadius = 4
        dictView2.layer.borderWidth = 0.7
        dictView2.layer.borderColor = borderColor.cgColor
        
        nextButton.layer.cornerRadius = 4
        nextButton.layer.backgroundColor = buttonColor.cgColor
        
        nextButton.setTitle("Next".localized, for: .normal)
    }
    
    @IBAction func dictAction1(_ sender: UITapGestureRecognizer) {
        if(!(dictPrefix1 == "none")) {
            if let dictPfx = dictPrefix1, let w = word, let dictSfx = dictSuffix1 {
                let urlString: String = dictPfx + w + dictSfx
                rootView.setDictionaryURL(url: urlString)
                rootViewController.performSegue(withIdentifier: "DictionarySegue", sender: nil)
            }
        } else {
            if(isKorean) {
                AlertController().simpleAlert(viewController: rootViewController, title: "다음 사전", message: "죄송합니다. 지원되지 않는 언어입니다.")
            } else {
                AlertController().simpleAlert(viewController: rootViewController, title: "", message: "Please set the dictionary in the Settings tab.".localized)
            }
        }
    }
    
    @IBAction func dictAction2(_ sender: UITapGestureRecognizer) {
        if(!(dictPrefix2 == "none")) {
            if let dictPfx = dictPrefix2, let w = word, let dictSfx = dictSuffix2 {
                let urlString: String = dictPfx + w + dictSfx
                rootView.setDictionaryURL(url: urlString)
                rootViewController.performSegue(withIdentifier: "DictionarySegue", sender: nil)
            }
        } else {
            if(isKorean) { // none인 경우 미리 설정해놓은 한국인용 다음 또는 네이버 URL Prefix 임.
                AlertController().simpleAlert(viewController: rootViewController, title: "네이버 사전", message: "죄송합니다. 지원되지 않는 언어입니다.")
            } else {
                AlertController().simpleAlert(viewController: rootViewController, title: "", message: "Please set the dictionary in the Settings tab.".localized)
            }
        }
    }
    
    
}
