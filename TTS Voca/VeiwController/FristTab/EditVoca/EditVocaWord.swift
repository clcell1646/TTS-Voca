//
//  EditVocaWord.swift
//  TTS Voca
//
//  Created by 정지환 on 28/07/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//


import Foundation
import UIKit


protocol EditWordTableDelegate {
    func getWordCount() -> Int
    func setWord(word: String, at: Int)
    func setMean(mean: String, at: Int)
    func addRow()
    func removeRow(at: Int)
}


extension EditVocaWordVC: EditWordTableDelegate {
    func getWordCount() -> Int {
        return wordCount
    }
    
    func setWord(word: String, at: Int) {
        words[at] = word
    }
    
    func setMean(mean: String, at: Int) {
        means[at] = mean
    }
    
    func addRow() {
        if(wordCount == 20) {
            AlertController().simpleAlert(viewController: self, title: "", message: "You can register up to 20.".localized)
            return
        }
        wordCount += 1
        wordTable.beginUpdates()
        wordTable.insertSections([wordCount], with: .bottom)
        wordTable.endUpdates()
//        focusOn(focusSection: wordCount)
    }
    
    func removeRow(at: Int) {
        if(wordCount == 4) {
            AlertController().simpleAlert(viewController: self, title: "", message: "The minimum word count is 4.".localized)
            return
        }
        updateVisibleCellsRowNum(deletedCellNum: at)
        wordCount -= 1
        words.remove(at: at)
        means.remove(at: at)
        words.append("")
        means.append("")
        wordTable.beginUpdates()
        wordTable.deleteSections([at + 1], with: .bottom)
        wordTable.endUpdates()
    }
}


class EditVocaWordVC: UIViewController {
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    var wordTableDelegate: WordTableDelegate!
    var voca: Voca!
    let palette: TagPalette = TagPalette()
    
    @IBOutlet weak var wordTable: UITableView!
    
    var words = [String](repeating: "", count: 20)
    var means = [String](repeating: "", count: 20)
    var wordCount: Int!
    var backgroundColor: UIColor!
    
    var focusSection: Int!
    var scrollType: Int!
    var voidIndexPath: IndexPath!
    var voidTF: Int!
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordTable.dataSource = self
        wordTable.delegate = self
        wordTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: UIScreen.main.bounds.height - 210, right: 0)
        
        wordCount = voca.getWordCount()
        backgroundColor = palette.getTagColor(tag: voca.getTag())
        
        setData()
        
        cancelButton.title = "Cancel".localized
        doneButton.title = "Done".localized
        navigationTitle.title = "Edit word".localized
    }
    
    // Only Called When Cell Deleted
    func updateVisibleCellsRowNum(deletedCellNum: Int) {
        for visibleCell in wordTable.visibleCells {
            if(visibleCell is EditWordFormCell) {
                let cell: EditWordFormCell = visibleCell as! EditWordFormCell
                cell.subRowNum(over: deletedCellNum)
            }
        }
    }
    
    
    func setData() {
        var i: Int = 0
        for word in Array(voca.getWordList()) {
            words[i] = word
            i += 1
        }
        
        i = 0
        for mean in Array(voca.getMeanList()) {
            means[i] = mean
            i += 1
        }
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
        
        for i in 0..<wordCount {
            if(words[i] == "") {
                wordIdx = i
                break
            }
            if(means[i] == "") {
                meanIdx = i
                break
            }
        }
        
        // 단어장 유효성 검증 => true: 단어장 추가, false: 해당 부분으로 포커스
        if(wordIdx == -1 && meanIdx == -1) {
            // 유효함, 단어장 수정
            updateWords()
            wordTableDelegate.reloadWordTable()
            self.dismiss(animated: true, completion: nil)
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
            let alertAction = UIAlertAction(title: "Ok".localized, style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
            wordTable.scrollToRow(at: voidIndexPath as IndexPath, at: .top, animated: true)
        }
    }
    
    func updateWords() {
        VocaDB.getInstance.updateVocaWord(voca: voca, wordCount: wordCount, words: words, means: means)
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
}


extension EditVocaWordVC: UITableViewDataSource, UITableViewDelegate, WordFormTableDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0) {
            return 69.7
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
        if(indexPath.section == 0) {
            let cell: StaticWordTableHeader = wordTable.dequeueReusableCell(withIdentifier: "StaticWordTableHeader", for: indexPath) as! StaticWordTableHeader
            cell.initUI(backgroundColor: palette.getTagColor(tag: voca.getTag()), title: voca.getTitle())
            return cell
        }
        
        if(indexPath.section == wordCount + 1) {
            let cell: EditWordTableFooter = wordTable.dequeueReusableCell(withIdentifier: "EditWordTableFooter", for: indexPath) as! EditWordTableFooter
            cell.setData(backgroundColor: backgroundColor, editTable: self)
            return cell
        }
        
        let cell: EditWordFormCell = wordTable.dequeueReusableCell(withIdentifier: "EditWordFormCell", for: indexPath) as! EditWordFormCell
        cell.setData(backgroundColor: backgroundColor, rowNum: indexPath.section - 1, word: words[indexPath.section - 1], mean: means[indexPath.section - 1], focusDelegate: self, editTable: self)
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
                let cell: EditWordFormCell = wordTable.cellForRow(at: focusIP) as! EditWordFormCell
                cell.wordTF.becomeFirstResponder()
                focusSection = -1 // 자동 스크롤 이후에는 커서를 리셋
            }
            break
        // Done Action: focus void UITextField
        case 1:
            if let ip = voidIndexPath, let cell = wordTable.cellForRow(at: ip) {
                if(voidTF == 0) {
                    (cell as! EditWordFormCell).wordTF.becomeFirstResponder()
                }
                if(voidTF == 1) {
                    (cell as! EditWordFormCell).meanTF.becomeFirstResponder()
                }
                voidIndexPath = nil // 자동 스크롤 이후에는 커서를 리셋
            }
            break
        default:
            break
        }
    }
}


class EditWordFormCell: UITableViewCell, UITextFieldDelegate {
    let sl = SpecialLocalizer()
    
    var wordFormTableDelegate: WordFormTableDelegate!
    var editTable: EditWordTableDelegate!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var wordTF: UITextField!
    @IBOutlet weak var meanTF: UITextField!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var crossImage: UIImageView!
    
    var rowNum: Int!
    
    func setData(backgroundColor: UIColor, rowNum: Int, word: String, mean: String, focusDelegate: WordFormTableDelegate, editTable: EditWordTableDelegate) {
        self.wordFormTableDelegate = focusDelegate
        self.editTable = editTable
        self.rowNum = rowNum

        headerLabel.textColor = .white
        
        headerView.backgroundColor = backgroundColor
        innerView.backgroundColor = backgroundColor
        rightView.backgroundColor = backgroundColor
        crossImage.backgroundColor = backgroundColor
        wordTF.tintColor = backgroundColor
        meanTF.tintColor = backgroundColor
        cardView.layer.cornerRadius = 4
        
        wordTF.delegate = self
        meanTF.delegate = self
        
        
        headerLabel.text = sl.getLineHeader(string: "Line\(rowNum + 1)")
        wordTF.text = word
        meanTF.text = mean
        
        wordTF.placeholder = "Word".localized
        meanTF.placeholder = "Mean".localized
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeRow))
        rightView.addGestureRecognizer(tap)
    }
    
    @objc func removeRow() {
        
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete the word?".localized, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "No".localized, style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "Yes".localized, style: .destructive, handler: {(alert: UIAlertAction!) in
            self.editTable.removeRow(at: self.rowNum)
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
        if(rowNum == editTable.getWordCount() - 1) {
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
            editTable.setWord(word: textField.text!, at: rowNum)
        }
        
        if(textField == meanTF) {
            editTable.setMean(mean: textField.text!, at: rowNum)
        }
    }
}


class EditWordTableFooter: UITableViewCell {
    @IBOutlet weak var addWordButton: UIButton!
    @IBOutlet weak var footerView: UIView!
    var editTable: EditWordTableDelegate!
    
    func setData(backgroundColor: UIColor, editTable: EditWordTableDelegate) {
        self.editTable = editTable
        
        footerView.backgroundColor = backgroundColor
        footerView.layer.cornerRadius = 4
        
        addWordButton.setTitle("Add word".localized, for: .normal)
    }
    
    @IBAction func addRow(_ sender: UIButton) {
        editTable.addRow()
    }
}
