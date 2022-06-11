//
//  learningVC.swift
//  TTS Voca
//
//  Created by 정지환 on 13/06/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import UIKit


protocol ViewConnector {
    func nextStage(pass: Int, presentWord: WordData)
    func dismiss()
    func getRootViewController() -> UIViewController
    func setDictionaryURL(url: String)
}


class LearningVC: UIViewController, ViewConnector {
    var vocaListDelegate: VocaListDelegate!
    
    // Universal
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBarRemainConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var fillBar: UIView!
    @IBOutlet weak var contentView: UIView!
    var substitutionView: [UIView] = [UIView]()
    var clearStage: Int!
    var stageCount: Int!
    
    var voca: Voca!
    var learningVoca: LearningVoca!
    let learningTimer: LearningTimer = LearningTimer()
    
    let palette: TagPalette = TagPalette()
    
    var progressBarWidth: CGFloat!
    var progressBarPartLen: CGFloat!
    
    @IBOutlet weak var rootView: UIView!
    
    let ttsData: TTSData = TTSData()
    var wordTTS: TTSService!
    var meanTTS: TTSService!
    
    
    var dicURL: String!
    func setDictionaryURL(url: String) {
        dicURL = url
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "DictionarySegue") {
            (segue.destination as! DictionaryView).urlString = dicURL
        }
    }
    
    
    var finalDict1: Dictionary?
    var finalDict2: Dictionary?
    var isImageHide1: Bool = true
    var isImageHide2: Bool = true
    var isKorean: Bool!
    func prepareDictData() {
        let deviceLanguage: String = Locale.preferredLanguages.first!
        isKorean = (deviceLanguage == "ko-KR")
        
        let dictDB = DictionaryDB.getInstance
        let langNum = ttsData.LtoN(language: voca.getLanguage())
        
        // Specified Language Dictionary
        let specLangDict1 = dictDB.getDictionary(languageNum: langNum, dictionaryNum: 0)
        let specLangDict2 = dictDB.getDictionary(languageNum: langNum, dictionaryNum: 1)
        
        let globalDict1 = dictDB.getDictionary(languageNum: 36, dictionaryNum: 0)
        let globalDict2 = dictDB.getDictionary(languageNum: 36, dictionaryNum: 1)
        let isEnableGDict1 = !(globalDict1.getPrefix() == "" && globalDict1.getSuffix() == "")
        let isEnableGDict2 = !(globalDict2.getPrefix() == "" && globalDict2.getSuffix() == "")
        /*
         해당 언어의 개별 설정이 켜져 있는가?
         전역 언어 설정이 있는가?
         한국인 인가?
         */
        if(specLangDict1.isEnable) { // 개별 언어 사전
            finalDict1 = specLangDict1
        } else {
            if(isEnableGDict1) { // 전역 사전
                finalDict1 = globalDict1
            } else {
                if(isKorean) { // 다음
                    loadDaumDict()
                } else { // 설정 안내
                    let dict = Dictionary()
                    dict.prefix = "none"
                    finalDict1 = dict
                }
            }
        }
        
        if(specLangDict2.isEnable) {
            finalDict2 = specLangDict2
        } else {
            if(isEnableGDict2) {
                finalDict2 = globalDict2
            } else {
                if(isKorean) { // 네이버
                    loadNaverDict()
                } else {
                    let dict = Dictionary()
                    dict.prefix = "none"
                    finalDict2 = dict
                }
            }
        }
    }
    
    func loadDaumDict() {
        let daumDict: Dictionary = ttsData.getDaumDictionary(language: voca.getLanguage())
        finalDict1 = daumDict
        isImageHide1 = false
    }
    
    func loadNaverDict() {
        let naverDict: Dictionary = ttsData.getNaverDictionary(language: voca.getLanguage())
        finalDict2 = naverDict
        isImageHide2 = false
    }
    
    
    override func viewDidLoad() {
        (UIApplication.shared.delegate as! AppDelegate).learningTimer = learningTimer
        learningTimer.startTimer()
        
        prepareDictData()
        
        wordTTS = TTSService(language: ttsData.LtoC(language: voca.getLanguage()))
        meanTTS = TTSService(language: ttsData.LtoC(language: UserDB.getInstance.getUserTTSLanguage()))
        
        setRootUI()
        readyViews()
        
        learningVoca = LearningVoca(voca: voca)
        clearStage = -1
        stageCount = learningVoca.getStageCount()

        progressBarWidth = UIScreen.main.bounds.width
        progressBarPartLen = CGFloat(Float(progressBarWidth) / Float(stageCount))
        
        setProgressBar()
        setStage(wordData: learningVoca.getNext())
    }
    
    func nextStage(pass: Int, presentWord: WordData) {
        if(pass == 1) {
            setProgressBar()
            learningVoca.currentPass()
            learningVoca.addPresentWordStage(wordData: presentWord)
            setStage(wordData: learningVoca.getNext())
        } else if(pass == 0) {
            learningVoca.currentFail()
            learningVoca.addPresentWordStage(wordData: presentWord)
            setStage(wordData: learningVoca.getNext())
        } else { // pass == -1 PresentWordView
            learningVoca.currentPass()
            if(learningVoca.hasNext()) {
                setStage(wordData: learningVoca.getNext())
            } else {
                endLearning()
            }
        }
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setStage(wordData: WordData) {
        let type: Int = wordData.getType()
        switch type {
        case 0: // 단어 보여주기
            (substitutionView[0] as! PresentWordView).setData(language: voca.getLanguage(), wordData: wordData, wordTTS: wordTTS, meanTTS: meanTTS, presentType: 0)
            (substitutionView[0] as! PresentWordView).setDictionaryData(isKorean: isKorean, dictImageHide1: isImageHide1, dictImageHide2: isImageHide2, dictionary1: finalDict1!, dictionary2: finalDict2!)
            setContentView(type: 0)
            break
        case 1: // 한글 선택
            (substitutionView[1] as! MultipleChoiceView).setData(voca: voca, wordData: wordData, wordTTS: wordTTS, meanTTS: meanTTS)
            setContentView(type: 1)
            break
        case 2: // 영어(lang) 선택
            (substitutionView[1] as! MultipleChoiceView).setData(voca: voca, wordData: wordData, wordTTS: wordTTS, meanTTS: meanTTS)
            setContentView(type: 1)
            break
        case 3: // 주관식 답변
            (substitutionView[2] as! ShortAnswerView).setData(wordData: wordData, meanTTS: meanTTS)
            setContentView(type: 2)
            break
        
        // 아래는 문제를 푼 뒤 디스플레이 하는 경우들
        case 4: // 단어 맞춤, 한글 TTS
            (substitutionView[0] as! PresentWordView).setData(language: voca.getLanguage(), wordData: wordData, wordTTS: wordTTS, meanTTS: meanTTS, presentType: 1)
            setContentView(type: 0)
            break
        case 5: // 단어 맞춤, 영어 TTS
            (substitutionView[0] as! PresentWordView).setData(language: voca.getLanguage(), wordData: wordData, wordTTS: wordTTS, meanTTS: meanTTS, presentType: 2)
            setContentView(type: 0)
            break
        case 6: // 단어 틀림, 한글 TTS
            (substitutionView[0] as! PresentWordView).setData(language: voca.getLanguage(), wordData: wordData, wordTTS: wordTTS, meanTTS: meanTTS, presentType: 3)
            setContentView(type: 0)
            break
        case 7: // 단어 틀림, 영어 TTS
            (substitutionView[0] as! PresentWordView).setData(language: voca.getLanguage(), wordData: wordData, wordTTS: wordTTS, meanTTS: meanTTS, presentType: 4)
            setContentView(type: 0)
            break
        default:
            break
        }
    }
    
    func getRootViewController() -> UIViewController {
        return self
    }

    func endLearning() {
        (UIApplication.shared.delegate as! AppDelegate).learningTimer = nil
        learningTimer.stopTimer()
        
        let totalTime: Int = Int(learningTimer.getTotalTime())
        let learningTime: Int = (voca.getLearningTime() + totalTime)
        let learningCount: Int = (voca.getLearningCount() + 1)

        // 에빙하우스 학습 일자 이후의 학습인가? e_learn: Bool
        var e_Date: Date = voca.getE_Date()
        var e_learn: Bool = false
        
        if(e_Date < Date()) {
            e_learn = true
        }
        
        var e_Status: Int = voca.getE_Status()
        if(e_learn) {
            let eTime: EbbinghausTime = EbbinghausTime()
            var e_Interval: Double!
            switch e_Status {
            case 0:
                e_Interval = eTime.getIntervalLevel1()
                break
            case 1:
                e_Interval = eTime.getIntervalLevel2()
                break
            case 2:
                e_Interval = eTime.getIntervalLevel3()
                break
            case 3:
                e_Interval = eTime.getIntervalLevel4()
                break
            case 4:
                e_Interval = eTime.getIntervalLevel5()
                break
            default:
                e_Interval = eTime.getRepeatInterval()
                break
            }

            e_Date = Date(timeIntervalSinceNow: e_Interval)
            e_Status += 1
            
//            if(voca.getE_Status() >= 6) {
//                e_learn = false
//            }
        }
        
        progressLabel.text = RandomEmoticon().getRandom()
        UserDB.getInstance.endLearning(exp: stageCount, learningTime: learningTime)
        VocaDB.getInstance.updateVocaForLearn(voca: voca, learningTime: learningTime, learningCount: learningCount, e_Status: e_Status, e_Date: e_Date)
        
        
        (substitutionView[3] as! ResultView).setData(voca: voca, learningTimer: learningTimer, stageCount: stageCount, rootView: self, vocaListDelegate: vocaListDelegate, e_learn: e_learn)
        contentView.addSubview(substitutionView[3])
        cancelButton.isEnabled = false
    }
    
    func setProgressBar() {
        clearStage += 1
        progressLabel.text = "\(clearStage!) / \(stageCount!)"
        
        rootView.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.progressBarRemainConstraint.constant = CGFloat(self.stageCount - self.clearStage) * self.progressBarPartLen
            self.rootView.layoutIfNeeded()
        })
        // animate
    }
    
    func setRootUI() {
        navigationTitle.title = voca.getTitle()
        fillBar.backgroundColor = palette.getTagColor(tag: voca.getTag())
    }
    
    func setContentView(type: Int) {
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        
        switch type {
        case 0:
            contentView.addSubview(substitutionView[0])
            break
        case 1:
            contentView.addSubview(substitutionView[1])
            break
        case 2:
            contentView.addSubview(substitutionView[2])
            break
        default:
            break
        }
    }
    
    func readyViews() {
        var topPadding: CGFloat = 0
        var bottomPadding: CGFloat = 0
        let width: CGFloat = UIScreen.main.bounds.width
        var height: CGFloat = UIScreen.main.bounds.height
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topPadding = (window?.safeAreaInsets.top)!
            bottomPadding = (window?.safeAreaInsets.bottom)!
            height = height - topPadding - bottomPadding - 44 - 35
        }
        let contentCGRect: CGRect = CGRect(x: 0, y: 0, width: width, height: height)
        
        let presentWordView: UIView = PresentWordView(frame: contentCGRect)
        let multipleChoiceView: UIView = MultipleChoiceView(frame: contentCGRect)
        let shortAnswerView: UIView = ShortAnswerView(frame: contentCGRect)
        let resultView: UIView = ResultView(frame: contentCGRect)
        
        let tagColor: UIColor = palette.getTagColor(tag: voca.getTag())
        let badgeColor: UIColor = palette.getBadgeColor(tag: voca.getTag())
        let buttonColor: UIColor = palette.getButtonColor(tag: voca.getTag())
        
        (presentWordView as! PresentWordView).initUI(buttonColor: buttonColor, borderColor: badgeColor)
        (presentWordView as! PresentWordView).rootView = self
        (multipleChoiceView as! MultipleChoiceView).initUI(buttonColor: tagColor)
        (multipleChoiceView as! MultipleChoiceView).rootView = self
        (multipleChoiceView as! MultipleChoiceView).learningVoca = learningVoca
        (shortAnswerView as! ShortAnswerView).initUI()
        (shortAnswerView as! ShortAnswerView).rootView = self
        (shortAnswerView as! ShortAnswerView).learningVoca = learningVoca
        (resultView as! ResultView).initUI(buttonColor: buttonColor, badgeColor: badgeColor)
        
        substitutionView.append(presentWordView)
        substitutionView.append(multipleChoiceView)
        substitutionView.append(shortAnswerView)
        substitutionView.append(resultView)
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "", message: "Are you sure you want to cancel the learning?".localized, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "No".localized, style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "Yes".localized, style: .destructive, handler: {(alert: UIAlertAction!) in self.cancelLearn()})
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func cancelLearn() {
        self.dismiss(animated: true, completion: nil)
    }
}
