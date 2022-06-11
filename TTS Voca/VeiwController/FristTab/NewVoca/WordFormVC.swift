//
//  WordFormVC.swift
//  TTS Voca
//
//  Created by 정지환 on 29/05/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import Foundation
import UIKit


protocol WordFormTableDelegate {
    func focusOn(focusSection: Int)
    func addRow()
    func removeRow(at: Int)
    func lastFormDoneAction()
}


class WordFormVC: UIViewController {
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var wordTable: UITableView!
    let tempData: TempData = TempData.getInstance
    let newVocaDB: NewVocaDB = NewVocaDB.getInstance
    let palette: TagPalette = TagPalette()
    var backgroundColor: UIColor!
    
    // scrollToRow 를 부르기 전에 scrollType을 반드시 설정할 것.
    var focusSection: Int!
    var scrollType: Int!
    var voidIndexPath: IndexPath!
    var voidTF: Int!
    
    var wordCount: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordTable.dataSource = self
        wordTable.delegate = self
        wordTable.backgroundColor = nil
        wordTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: UIScreen.main.bounds.height - 210, right: 0)
        backgroundColor = palette.getTagColor(tag: tempData.getTag())
        
        wordCount = Int(tempData.getWordCount())!
        
        self.navigationItem.title = "Enter word".localized
        doneButton.title = "Done".localized
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        formCompletion()
    }
    
    func lastFormDoneAction() {
        formCompletion()
    }
    
    func formCompletion() {
        self.view.endEditing(true)
        
        var wordIdx: Int = -1
        var meanIdx: Int = -1
        
        for i in 0..<Int(tempData.getWordCount())! {
            if(tempData.getWord(at: i) == "") {
                wordIdx = i
                break
            }
            if(tempData.getMean(at: i) == "") {
                meanIdx = i
                break
            }
        }
        
        // validation Run Code - start -
        //        wordIdx = -1
        //        meanIdx = -1
        // validation Run Code -  end  -
        
        // test code =====================
        //        wordIdx = -1
        //        meanIdx = -1
        // test code =====================
        
        
        
        // 단어장 유효성 검증 => true: 단어장 추가, false: 해당 부분으로 포커스
        if(wordIdx == -1 && meanIdx == -1) {
            addVoca()
            (self.navigationController as! VocaListNVC).vocaListDelegate.reloadVocaTable()
            self.navigationController?.dismiss(animated: true, completion: nil)
        } else {
            scrollType = 1
            var message: String!
            if(wordIdx != -1) {
                message = "Line".localized + "\(wordIdx + 1)" + " is empty.".localized // "\(wordIdx + 1)번째 단어를 입력해주세요."
                voidIndexPath = IndexPath(row: 0, section: wordIdx + 1)
                voidTF = 0
            } else {
                message = "Line".localized + "\(meanIdx + 1)" + " is empty.".localized // "\(meanIdx + 1)번째 뜻을 입력해주세요."
                voidIndexPath = IndexPath(row: 0, section: meanIdx + 1)
                voidTF = 1
            }
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
            wordTable.scrollToRow(at: voidIndexPath as IndexPath, at: .top, animated: true)
        }
    }
    
    func addVoca() {
        let date: Date = Date()
        
        newVocaDB.setLastTag(lastTag: tempData.getTag())
        newVocaDB.setLastLanguage(lastLanguage: tempData.getLanguage())
        newVocaDB.setLastWordCount(lastWordCount: tempData.getWordCount())
        newVocaDB.addVoca(num: newVocaDB.getNextNum(),
                          title: tempData.getVocaTitle(),
                          uploadDate: date,
                          language: tempData.getLanguage(),
                          e_Status: 0,
                          e_Date: date,
                          tag: tempData.getTag(),
                          learningCount: 0,
                          wordCount: Int(tempData.getWordCount())!,
                          words: tempData.getWords(),
                          means: tempData.getMeans())
        tempData.clear()
    }
}


extension WordFormVC: UITableViewDataSource, UITableViewDelegate, WordFormTableDelegate {
    func addRow() {
        if(wordCount == 20) {
            AlertController().simpleAlert(viewController: self, title: "", message: "You can register up to 20.".localized)
            return
        }
        wordCount += 1
        wordTable.beginUpdates()
        wordTable.insertSections([wordCount], with: .bottom)
        wordTable.endUpdates()
        tempData.setWordCount(wordCount: String(wordCount))
    }
    
    func removeRow(at: Int) {
        if(wordCount == 4) {
            AlertController().simpleAlert(viewController: self, title: "", message: "The minimum word count is 4.".localized)
            return
        }
        tempData.removeRow(at: at)
        updateVisibleCellsRowNum(deletedCellNum: at)
        wordCount -= 1
        wordTable.beginUpdates()
        wordTable.deleteSections([at + 1], with: .bottom)
        wordTable.endUpdates()
        tempData.setWordCount(wordCount: String(wordCount))
    }
    
    // Only Called When Cell Deleted
    func updateVisibleCellsRowNum(deletedCellNum: Int) {
        for visibleCell in wordTable.visibleCells {
            if(visibleCell is WordFormCell) {
                let cell: WordFormCell = visibleCell as! WordFormCell
                cell.subRowNum(over: deletedCellNum)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0) {
            return 70
        }
        return 90
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return wordCount + 2 // header & footer
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // header cell
        if(indexPath.section == 0){
            let cell: StaticWordTableHeader = tableView.dequeueReusableCell(withIdentifier: "StaticWordTableHeader", for: indexPath) as! StaticWordTableHeader
            cell.initUI(backgroundColor: backgroundColor, title: tempData.getVocaTitle())
            return cell
        }
        // footer cell
        if(indexPath.section == wordCount + 1) {
            let cell: WordFormTableFooter = tableView.dequeueReusableCell(withIdentifier: "WordFormTableFooter", for: indexPath) as! WordFormTableFooter
            cell.initUI(backgroundColor: backgroundColor, wordFormTable: self)
            return cell
        }
        
        
        // 단어 입력 셀
        let cell: WordFormCell = tableView.dequeueReusableCell(withIdentifier: "WordFormCell", for: indexPath) as! WordFormCell
        cell.setData(focusDelegate: self, backgroundColor: backgroundColor, rowNum: indexPath.section - 1, wordFormTableDelegate: self, tempData: tempData)
        return cell
    }
    
    func focusOn(focusSection: Int) {
        scrollType = 0
        self.focusSection = focusSection
        let focusIP: IndexPath = IndexPath(row: 0, section: focusSection)
        wordTable.scrollToRow(at: focusIP as IndexPath, at: .top, animated: true)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        switch scrollType {
        // Focus Move: wordTF -> meanTF
        case 0:
            if(focusSection != -1) {
                let focusIP: IndexPath = IndexPath(row: 0, section: focusSection)
                let cell: WordFormCell = wordTable.cellForRow(at: focusIP) as! WordFormCell
                cell.wordTF.becomeFirstResponder()
                focusSection = -1 // 자동 스크롤 이후에는 커서를 리셋
            }
            break
        // Done Action: focus void UITextField
        case 1:
            if let ip = voidIndexPath, let cell = wordTable.cellForRow(at: ip) {
                if(voidTF == 0) {
//                    print("wordTF")
                    (cell as! WordFormCell).wordTF.becomeFirstResponder()
                }
                if(voidTF == 1) {
//                    print("mordTF")
                    (cell as! WordFormCell).meanTF.becomeFirstResponder()
                }
                voidIndexPath = nil // 자동 스크롤 이후에는 커서를 리셋
            }
            break
        default:
            break
        }
    }
}


class WordFormCell: UITableViewCell, UITextFieldDelegate {
    let sl = SpecialLocalizer()
    
    var wordFormTableDelegate: WordFormTableDelegate!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var wordTF: UITextField!
    @IBOutlet weak var meanTF: UITextField!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var crossImage: UIImageView!
    var wordForm: WordFormTableDelegate!
    
    var rowNum: Int!
    var tempData: TempData!
    
    func setData(focusDelegate: WordFormTableDelegate, backgroundColor: UIColor, rowNum: Int, wordFormTableDelegate: WordFormTableDelegate, tempData: TempData) {
        self.wordForm = wordFormTableDelegate
        self.wordFormTableDelegate = focusDelegate
        self.rowNum = rowNum
        self.tempData = tempData
        
        headerLabel.textColor = .white
        
        headerView.backgroundColor = backgroundColor
        innerView.backgroundColor = backgroundColor
        
        wordTF.tintColor = backgroundColor
        meanTF.tintColor = backgroundColor
        
        wordTF.delegate = self
        meanTF.delegate = self
        
        headerLabel.text = sl.getLineHeader(string: "Line\(rowNum + 1)")
        wordTF.text = tempData.getWord(at: rowNum)
        meanTF.text = tempData.getMean(at: rowNum)
        
        wordTF.placeholder = "Word".localized
        meanTF.placeholder = "Mean".localized
        
        card.layer.cornerRadius = 4
        
        rightView.backgroundColor = backgroundColor
        crossImage.backgroundColor = backgroundColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeRow))
        rightView.addGestureRecognizer(tap)
    }
    
    @objc func removeRow() {
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete the word?".localized, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "No".localized, style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "Yes".localized, style: .destructive, handler: {(alert: UIAlertAction!) in
            self.wordForm.removeRow(at: self.rowNum)
        })
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        parentViewController!.present(alert, animated: true, completion: nil)
    }
    
    func subRowNum(over: Int) {
        if(rowNum > over) {
            rowNum -= 1
            headerLabel.text = sl.getLineHeader(string: "Line\(rowNum + 1)")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 단어 텍스트 필드일 경우
        if(textField == wordTF) {
            meanTF.becomeFirstResponder()
            return true
        }
        
        // 마지막 셀일 경우
        if(rowNum == Int(tempData.getWordCount())! - 1) {
//            endEditing(true)
            wordFormTableDelegate.lastFormDoneAction()
            return true
        }
        
        // 뜻 텍스트 필드일 경우
        if(textField == meanTF) {
            wordFormTableDelegate.focusOn(focusSection: rowNum + 2)
            return true
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        if(textField == wordTF) {
            tempData.setWord(at: rowNum, word: textField.text!)
        }
        
        if(textField == meanTF) {
            tempData.setMean(at: rowNum, mean: textField.text!)
        }
    }
}



class WordFormTableFooter: UITableViewCell {
    @IBOutlet weak var addWordButton: UIButton!
    @IBOutlet weak var footerView: UIView!
    var wordFormTable: WordFormTableDelegate!
    
    func initUI(backgroundColor: UIColor, wordFormTable: WordFormTableDelegate) {
        self.wordFormTable = wordFormTable
        
        footerView.backgroundColor = backgroundColor
        footerView.layer.cornerRadius = 4
        
        addWordButton.setTitle("Add word".localized, for: .normal)
    }
    @IBAction func addRow(_ sender: UIButton) {
        wordFormTable.addRow()
    }
}


class StaticWordTableHeader: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewWidth: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cornerBackgroundView: UIView!
    @IBOutlet weak var whiteOverlapView: UIView!
    
    func initUI(backgroundColor: UIColor, title: String) {
        //        titleLabel.text = title
        topView.backgroundColor = backgroundColor
        cornerBackgroundView.backgroundColor = backgroundColor
        bottomView.backgroundColor = backgroundColor
        
        topView.layer.cornerRadius = 4
        whiteOverlapView.layer.cornerRadius = 4
        bottomView.layer.cornerRadius = 4
        
        let width: CGFloat = self.contentView.bounds.width - 40
        topViewWidth.constant = width / 5 * 3
    }
}
