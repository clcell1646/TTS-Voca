//
//  ResultView.swift
//  TTS Voca
//
//  Created by 정지환 on 22/06/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import UIKit

class ResultView: UIView {
    private let xibName = "ResultView"
    
    var vocaListDelegate: VocaListDelegate!

    @IBOutlet weak var betweenLabel0: UILabel!
    @IBOutlet weak var betweenLabel1: UILabel!
    @IBOutlet weak var betweenLabel2: UILabel!
    @IBOutlet weak var betweenLabel3: UILabel!
    @IBOutlet weak var betweenLabel4: UILabel!
    // =======================================
    @IBOutlet weak var betweenLabel5: UILabel!
    @IBOutlet weak var betweenLabel6: UILabel!
    @IBOutlet weak var betweenLabel7: UILabel!
    @IBOutlet weak var betweenLabel8: UILabel!
    @IBOutlet weak var betweenLabel9: UILabel!
    @IBOutlet weak var betweenLabel10: UILabel!
    @IBOutlet weak var learningCompleteLabel: UILabel!
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var learningTimeLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    
    @IBOutlet weak var ebbinghausInspectorWidth: NSLayoutConstraint!
    @IBOutlet weak var ebbinghausInspectorLabel: UILabel!
    @IBOutlet weak var ebbinghausInspectorNeedleLabel: UIView!
    @IBOutlet weak var ebbinghausLevelStackView: UIStackView!
    @IBOutlet weak var ebbinghausLevelConstraint: NSLayoutConstraint!
    @IBOutlet weak var ebbinghausLevel0: UILabel!
    @IBOutlet weak var ebbinghausLevel1: UILabel!
    @IBOutlet weak var ebbinghausLevel2: UILabel!
    @IBOutlet weak var ebbinghausLevel3: UILabel!
    @IBOutlet weak var ebbinghausLevel4: UILabel!
    @IBOutlet weak var ebbinghausLevel5: UILabel!
    
    @IBOutlet weak var e_year: UILabel!
    @IBOutlet weak var e_month: UILabel!
    @IBOutlet weak var e_date: UILabel!
    @IBOutlet weak var e_hour: UILabel!
    @IBOutlet weak var e_minute: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!

    let eLevelDefault: Int = -40
    let eLevelInterval: Int = -130 // -110
    
    let defaultConstraint: Int = 30
    let eStatusUI_Interval: Int = -110 // - 110
    
    let defaultFontSize: Int = 35
//    let focusFontSize: Int = 30
    let defaultFontAlpha: CGFloat = 0.4
    let focusFontAlpha: CGFloat = 1.0
    
    var rootView: ViewConnector!
    var voca: Voca!
    var exp: Int!
    var e_learn: Bool!
    
    var e_Status: Int!
    var startLevel: Int!
    var startPos: Int!
    
    func localize() {
        dismissButton.setTitle("Ok".localized, for: .normal)
        
        learningCompleteLabel.text = "Learning completed".localized
        ebbinghausInspectorLabel.text = "Ebbinghaus level".localized
        ebbinghausLevel0.text = "Unlearned".localized
        ebbinghausLevel1.text = "Level 1".localized
        ebbinghausLevel2.text = "Level 2".localized
        ebbinghausLevel3.text = "Level 3".localized
        ebbinghausLevel4.text = "Level 4".localized
        ebbinghausLevel5.text = "Level 5".localized
        
        switch Locale.current.languageCode {
        case "ko":
            betweenLabel0.text = ""
            betweenLabel1.text = "단어를"
            betweenLabel2.text = "동안"
            betweenLabel3.text = "학습하여"
            betweenLabel4.text = "를 얻었습니다!"
            betweenLabel5.text = "다음 학습 예정일은"
            betweenLabel6.text = "년"
            betweenLabel7.text = "월"
            betweenLabel8.text = "일"
            betweenLabel9.text = "시"
            betweenLabel10.text = "분 입니다."
            ebbinghausInspectorWidth.constant = 140
            break
        case "ja":
            betweenLabel0.text = ""
            betweenLabel1.text = "単語を"
            betweenLabel2.text = "の間"
            betweenLabel3.text = "学習して"
            betweenLabel4.text = "を獲得しました！"
            betweenLabel5.text = "次の学習予定日は"
            betweenLabel6.text = "年"
            betweenLabel7.text = "月"
            betweenLabel8.text = "日"
            betweenLabel9.text = "時"
            betweenLabel10.text = "分です。"
            ebbinghausInspectorWidth.constant = 180
            break
        default:
            betweenLabel0.text = "Learn "
            betweenLabel1.text = " for "
            betweenLabel2.text = ""
            betweenLabel3.text = "and get "
            betweenLabel4.text = ""
            betweenLabel5.text = "The next lesson is "
            betweenLabel6.text = ""
            betweenLabel7.text = ""
            betweenLabel8.text = ",  "
            betweenLabel9.text = ""
            betweenLabel10.text = ""
            ebbinghausInspectorWidth.constant = 160
            break
        }
        
    }
    
    func focusLabel(level: Int) {
        if(level == 0) {
            ebbinghausLevel0.alpha = focusFontAlpha
            ebbinghausLevel0.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        } else {
            ebbinghausLevel0.alpha = defaultFontAlpha
            ebbinghausLevel0.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }
        if(level == 1) {
            ebbinghausLevel1.alpha = focusFontAlpha
            ebbinghausLevel1.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        } else {
            ebbinghausLevel1.alpha = defaultFontAlpha
            ebbinghausLevel1.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }
        if(level == 2) {
            ebbinghausLevel2.alpha = focusFontAlpha
            ebbinghausLevel2.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        } else {
            ebbinghausLevel2.alpha = defaultFontAlpha
            ebbinghausLevel2.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }
        if(level == 3) {
            ebbinghausLevel3.alpha = focusFontAlpha
            ebbinghausLevel3.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        } else {
            ebbinghausLevel3.alpha = defaultFontAlpha
            ebbinghausLevel3.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }
        if(level == 4) {
            ebbinghausLevel4.alpha = focusFontAlpha
            ebbinghausLevel4.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        } else {
            ebbinghausLevel4.alpha = defaultFontAlpha
            ebbinghausLevel4.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }
        if(level >= 5) {
            ebbinghausLevel5.alpha = focusFontAlpha
            ebbinghausLevel5.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        } else {
            ebbinghausLevel5.alpha = defaultFontAlpha
            ebbinghausLevel5.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }
    }
    
    func setData(voca: Voca, learningTimer: LearningTimer, stageCount: Int, rootView: ViewConnector, vocaListDelegate: VocaListDelegate, e_learn: Bool) {
        self.voca = voca
        self.vocaListDelegate = vocaListDelegate
        
        self.rootView = rootView
        self.e_learn = e_learn
        self.e_Status = voca.getE_Status()
        // 6단계 부터는 다시 5로 낮춤과 동시에 애니메이팅을 해선 안됨.
        if(e_Status >= 6) {
            self.e_Status = 5
            self.e_learn = false
        }
        
        ebbinghausLevel0.font = ebbinghausLevel0.font.withSize(35.0)
        ebbinghausLevel1.font = ebbinghausLevel1.font.withSize(35.0)
        ebbinghausLevel2.font = ebbinghausLevel2.font.withSize(35.0)
        ebbinghausLevel3.font = ebbinghausLevel3.font.withSize(35.0)
        ebbinghausLevel4.font = ebbinghausLevel4.font.withSize(35.0)
        ebbinghausLevel5.font = ebbinghausLevel5.font.withSize(35.0)
        
        var wordCount_S: String = String(voca.getWordCount())
        switch Locale.current.languageCode {
        case "ko":
            wordCount_S.append("개")
            break
        case "ja":
            if(voca.getWordCount() < 10) {
                wordCount_S.append("つ")
            } else {
                wordCount_S.append("個")
            }
            break
        default:
            wordCount_S.append(" words")
            break
        }
        wordCountLabel.text = wordCount_S
        
        let timeConverter = TimeConverter()
        let learningTime_S: String = timeConverter.ItoS(learningTime: Int(learningTimer.getTotalTime()))
        learningTimeLabel.text = learningTime_S
        
        var expLabel_S: String = String(stageCount)
        switch Locale.current.languageCode {
        case "ko":
            expLabel_S.append("exp")
            break
        case "ja":
            expLabel_S.append("exp")
            break
        default:
            expLabel_S.append("exp!")
            break
        }
        expLabel.text = expLabel_S
        
        if(self.e_learn) {
            startLevel = e_Status - 1
            startPos = ((e_Status - 1) * eLevelInterval) + eLevelDefault
        } else {
            startLevel = e_Status
            startPos = (e_Status * eLevelInterval) + eLevelDefault
        }
        focusLabel(level: startLevel)
        ebbinghausLevelConstraint.constant = CGFloat(startPos)
        
        let dc: DateConverter = DateConverter()
        let e_date_S: String = dc.DtoS_resultPage(date: voca.getE_Date())
        let arr: [String] = e_date_S.components(separatedBy: ".")
        e_year.text = arr[0]
        e_month.text = DateConverter().getAmericanMonth(month: Int(arr[1])!)
        e_date.text = arr[2]
        e_hour.text = arr[3]
        e_minute.text = arr[4]
        
        switch Locale.current.languageCode {
        case "ko":
            e_year.text = arr[0]
            e_month.text = arr[1]
            e_date.text = arr[2]
            e_hour.text = arr[3]
            e_minute.text = arr[4]
            break
        case "ja":
            e_year.text = arr[0]
            e_month.text = arr[1]
            e_date.text = arr[2]
            e_hour.text = arr[3]
            e_minute.text = arr[4]
            break
        default:
            e_year.text = arr[0]
            e_month.text = DateConverter().getAmericanMonth(month: Int(arr[1])!)
            e_date.text = arr[2]
            var h: String = arr[3]
            if(h.count == 1) {
                h = "0" + h
            }
            var m: String = arr[4]
            if(m.count == 1) {
                m = "0" + m
            }
            e_hour.text = h + ":" + m
            e_minute.text = ""
            break
        }
        
        localize()
    }

    func initUI(buttonColor: UIColor, badgeColor: UIColor) {
        learningCompleteLabel.textColor = badgeColor
        ebbinghausInspectorLabel.backgroundColor = badgeColor
        ebbinghausInspectorNeedleLabel.backgroundColor = badgeColor
        dismissButton.backgroundColor = buttonColor

        ebbinghausInspectorLabel.layer.cornerRadius = 4
        ebbinghausInspectorLabel.layer.masksToBounds = true
        let transform: CGAffineTransform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        ebbinghausInspectorNeedleLabel.transform = transform
        dismissButton.layer.cornerRadius = 4
    }
    
    @objc func moveEbbinghausLevel() {
        let endPos = startPos + eLevelInterval
        self.layoutIfNeeded()
        UIView.animate(withDuration: 1.5, animations: { () -> Void in
            self.focusLabel(level: self.startLevel + 1)
            self.ebbinghausLevelConstraint.constant = CGFloat(endPos)
            self.layoutIfNeeded()
        })
    }
    
    override func didMoveToSuperview() {
        if(e_learn) {
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(moveEbbinghausLevel), userInfo: nil, repeats: false)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit(){
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        vocaListDelegate.reloadVocaTable()
        rootView.dismiss()
    }
}
