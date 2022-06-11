//
//  VocaDetail.swift
//  TTS Voca
//
//  Created by 정지환 on 04/06/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import Foundation
import UIKit


protocol StopArrowTimerDelegate {
    func stopArrowTimer()
}

protocol WordTableDelegate {
    func reloadWordTable()
    func setShowType(type: Direction)
    func speechWord(word: String)
}


class WordListVC: UIViewController, StopArrowTimerDelegate, WordTableDelegate {
    func reloadWordTable() {
        setData()
        wordTable.reloadData()
    }

    var isWordVisible: Bool = true
    var isMeanVisible: Bool = true
    
    func setShowType(type: Direction) {
        switch type {
        case .left:
            isWordVisible = true
            isMeanVisible = false
            break
        case .center:
            isWordVisible = true
            isMeanVisible = true
            break
        case .right:
            isWordVisible = false
            isMeanVisible = true
        }
        
        wordTable.layoutIfNeeded()
        UIView.animate(withDuration: 0.4, animations: {
            for visibleCell in self.wordTable.visibleCells {
                if(visibleCell is WordTableCell) {
                    let cell = visibleCell as! WordTableCell
                    cell.setWord(visible: self.isWordVisible)
                    cell.setMean(visible: self.isMeanVisible)
                }
            }
            self.wordTable.layoutIfNeeded()
        })
    }
    
    
    var ttsService: TTSService!
    func speechWord(word: String) {
        ttsService.stop()
        ttsService.speech(word: word)
    }
    
    @IBOutlet weak var learnButtonBottomSpace: NSLayoutConstraint!
    var defaultBottomSpace: CGFloat = 10
    var notchBottomSpace: CGFloat = 44
    
    
    var vocaListDelegate: VocaListDelegate!
    var barButtonItemDelegate: BarButtonItemDelegate!
    
    @IBOutlet weak var arrow_left: UIImageView!
    @IBOutlet weak var arrow_left_constraint: NSLayoutConstraint!
    let startContraint: CGFloat = 10.0
    let endContraint: CGFloat = -150.0 // -50.0
    let startAlpha: CGFloat = 0.6
    let endAlpha: CGFloat = 0
    
    @IBOutlet weak var learnButton: UIButton!
    @IBOutlet weak var wordTable: UITableView!

    let palette: TagPalette = TagPalette()
    var voca: Voca!
    var words = [String]()
    var means = [String]()
    
    var arrowTimer: Timer?
    
    override func viewDidLoad() {
        initUI()
        wordTable.dataSource = self
        wordTable.delegate = self
        setData()
        
        setShowType(type: UserDB.getInstance.getLastVocaShowType())
        
        if(UserDB.getInstance.isTutorial1()) {
            AlertController().simpleAlert(viewController: self, title: "", message: "Touch a word to hear it.\n(You must turn off mute switch.)".localized)
        }
        if(UserDB.getInstance.getTutorial2()) {
            startArrowTimer()
        }
    }
    
    func setData() {
        words = Array(voca.getWordList())
        means = Array(voca.getMeanList())
        
        let ttsCode: String = TTSData().LtoC(language: voca.getLanguage())
        ttsService = TTSService(language: ttsCode)
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        barButtonItemDelegate.addEditBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ttsService.stop()
    }

    func startArrowTimer() {
        arrowTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(moveArrow), userInfo: nil, repeats: true)
    }

    func stopArrowTimer() {
        UserDB.getInstance.setTutorial2(tutoreal2: false)
        if let timer = arrowTimer {
            if(timer.isValid) {
                timer.invalidate()
            }
        }
    }

    @objc func moveArrow() {
        arrow_left_constraint.constant = startContraint
        arrow_left.alpha = startAlpha
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 1.5, animations: { () -> Void in
            self.arrow_left_constraint.constant = self.endContraint
            self.arrow_left.alpha = self.endAlpha
            self.view.layoutIfNeeded()
        })
    }

    func initUI() {
        wordTable.rowHeight = 80
        learnButton.layer.cornerRadius = 4
        learnButton.backgroundColor = palette.getButtonColor(tag: voca.getTag())
        learnButton.setTitle("Learning".localized, for: .normal)
        
        if let keyWindow = UIApplication.shared.keyWindow, keyWindow.safeAreaInsets.bottom > 0 {
            // this is notch design device
            learnButtonBottomSpace.constant = notchBottomSpace
        } else {
            // this is original home button design device
            learnButtonBottomSpace.constant = defaultBottomSpace
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "learnVocaSegue") {
            let vc = segue.destination as! LearningVC
            vc.voca = voca
            vc.vocaListDelegate = vocaListDelegate
        }
    }
}


extension WordListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0) {
            return 70
        }
        if(indexPath.section == voca.getWordCount() + 1) {
            return 20
        }
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return voca.getWordCount() + 2 // header & footer
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row: Int = indexPath.section
        let backgroundColor: UIColor = palette.getTagColor(tag: voca.getTag())
        if(row == 0) {
            let cell = wordTable.dequeueReusableCell(withIdentifier: "WordTableHeader", for: indexPath) as! ActiveWordTableHeader
            let buttonWidth = (self.view.bounds.width - 20) / 3
            cell.setData(backgroundColor: backgroundColor, title: voca.getTitle(), buttonWidth: buttonWidth, wordTable: self)
            return cell
        }
        if(row == voca.getWordCount() + 1) {
            let cell = wordTable.dequeueReusableCell(withIdentifier: "WordTableFooter", for: indexPath) as! WordTableFooter
            cell.initUI(backgroundColor: backgroundColor)
            return cell
        }
        
        let cell = wordTable.dequeueReusableCell(withIdentifier: "WordTableCell", for: indexPath) as! WordTableCell
        cell.setData(num: row, word: words[row - 1], mean: means[row - 1], backgroundColor: backgroundColor, wordTable: self)
        cell.setWord(visible: isWordVisible)
        cell.setMean(visible: isMeanVisible)
        return cell
    }
}


class WordTableCell: UITableViewCell {
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var meanLabel: UILabel!

    var wordTable: WordTableDelegate!
    var word: String!
    func setData(num: Int, word: String, mean: String, backgroundColor: UIColor, wordTable: WordTableDelegate) {
        innerView.backgroundColor = backgroundColor
        
        self.word = word
        
        wordLabel.text = word
        meanLabel.text = mean
        
        self.wordTable = wordTable
        let tap = UITapGestureRecognizer(target: self, action: #selector(speechWord))
        wordLabel.isUserInteractionEnabled = true
        wordLabel.addGestureRecognizer(tap)
        
        card.layer.cornerRadius = 4
    }
    
    @objc func speechWord() {
        wordTable.speechWord(word: word)
    }
    
    func setWord(visible: Bool) {
        if(visible) {
            wordLabel.alpha = 1.0
        } else {
            wordLabel.alpha = 0
        }
    }
    
    func setMean(visible: Bool) {
        if(visible) {
            meanLabel.alpha = 1.0
        } else {
            meanLabel.alpha = 0
        }
    }
}

class WordTableFooter: UITableViewCell {
    @IBOutlet weak var footerView: UIView!
    
    func initUI(backgroundColor: UIColor) {
        footerView.backgroundColor = backgroundColor
        footerView.layer.cornerRadius = 4
    }
}


class ActiveWordTableHeader: UITableViewCell {
    @IBOutlet weak var indicatorRootView: UIView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicatorWidth: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var indicatorLeft: NSLayoutConstraint!
    @IBOutlet weak var indicatorCenter: NSLayoutConstraint!
    @IBOutlet weak var indicatorRight: NSLayoutConstraint!
    @IBOutlet weak var leftCornerView: UIView!
    @IBOutlet weak var rightCornerView: UIView!
    @IBOutlet weak var leftWhiteOverlapView: UIView!
    @IBOutlet weak var rightWhiteOverlapView: UIView!
    @IBOutlet weak var showOnlyWordButton: UIButton!
    @IBOutlet weak var showAllButton: UIButton!
    @IBOutlet weak var showOnlyMeanButton: UIButton!
    
    var tagColor: UIColor!
    var wordTable: WordTableDelegate!
    
    func setData(backgroundColor: UIColor, title: String, buttonWidth: CGFloat, wordTable: WordTableDelegate) {
        self.wordTable = wordTable
        tagColor = backgroundColor
        
        indicatorView.backgroundColor = backgroundColor
        bottomView.backgroundColor = backgroundColor
        leftCornerView.backgroundColor = backgroundColor
        rightCornerView.backgroundColor = backgroundColor
        
        indicatorView.layer.cornerRadius = 4
        leftWhiteOverlapView.layer.cornerRadius = 4
        rightWhiteOverlapView.layer.cornerRadius = 4
        bottomView.layer.cornerRadius = 4
        
//        let width: CGFloat = (UIScreen.main.bounds.width - 20) / 3 //     정확히 1/3
//        indicatorWidth.constant = buttonWidth
        indicatorWidth.constant = (self.contentView.bounds.width - 20) / 3
        
        let type: Direction = UserDB.getInstance.getLastVocaShowType()
        selectShowType(direction: type, animation: false)
        
        showAllButton.setTitle("Show all".localized, for: .normal)
        showOnlyWordButton.setTitle("Word only".localized, for: .normal)
        showOnlyMeanButton.setTitle("Mean only".localized, for: .normal)
    }
    
    override func layoutSubviews() {
        
    }
    
    @IBAction func showOnlyWordAction(_ sender: UIButton) {
        selectShowType(direction: .left, animation: true)
    }
    @IBAction func showAllAction(_ sender: UIButton) {
        selectShowType(direction: .center, animation: true)
    }
    @IBAction func showOnlyMeanAction(_ sender: UIButton) {
        selectShowType(direction: .right, animation: true)
    }
    
    func selectShowType(direction: Direction, animation: Bool) {
        UserDB.getInstance.setLastVocaShowType(type: direction)
        wordTable.setShowType(type: direction)
        if(animation) {
            indicatorRootView.layoutIfNeeded()
            UIView.animate(withDuration: 0.3, animations: {
                self.setIndicator(direction: direction)
                self.setButtonColor(direction: direction)
                self.indicatorRootView.layoutIfNeeded()
            })
        } else {
            self.setIndicator(direction: direction)
            self.setButtonColor(direction: direction)
        }
    }
    
    private func setButtonColor(direction: Direction) {
        if(direction == .left) {
            showOnlyWordButton.setTitleColor(.white, for: .normal)
        } else {
            showOnlyWordButton.setTitleColor(tagColor, for: .normal)
        }
        if(direction == .center) {
            showAllButton.setTitleColor(.white, for: .normal)
        } else {
            showAllButton.setTitleColor(tagColor, for: .normal)
        }
        if(direction == .right) {
            showOnlyMeanButton.setTitleColor(.white, for: .normal)
        } else {
            showOnlyMeanButton.setTitleColor(tagColor, for: .normal)
        }
    }
    
    private func setIndicator(direction: Direction) {
            if(direction == .left) {
                indicatorLeft.priority = .defaultHigh
            } else {
                indicatorLeft.priority = .defaultLow
            }
            if(direction == .center) {
                indicatorCenter.priority = .defaultHigh
            } else {
                indicatorCenter.priority = .defaultLow
            }
            if(direction == .right) {
                indicatorRight.priority = .defaultHigh
            } else {
                indicatorRight.priority = .defaultLow
            }
    }
}


enum Direction {
    case left
    case center
    case right
}
