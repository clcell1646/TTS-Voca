//
//  NewVocaVC.swift
//  TTS Voca
//
//  Created by 정지환 on 23/05/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import UIKit

class NewVocaVC: UIViewController, UITextFieldDelegate {
    var editMode: Bool = false
    var voca: Voca!
    var tempDataForEditMode: TempDataForEditMode!
    
    let selectedColor: UIColor = UIColor(displayP3Red: 0.31, green: 0.28, blue: 0.25, alpha: 1.0)
    let tempData: TempData = TempData.getInstance
    let newVocaDB: NewVocaDB = NewVocaDB.getInstance
    let palette: TagPalette = TagPalette()
    
    @IBOutlet weak var leftBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var vocaTitleHeader: UILabel!
    @IBOutlet weak var vocaTitle: UITextField!
    @IBOutlet weak var languageHeader: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var wordCountInspector: UILabel!
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var wordCountSelector: UIView!
    
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var tagColorHeader: UILabel!
    @IBOutlet weak var tagSelector: UIView!
    @IBOutlet weak var tagLabel1: UIView!
    @IBOutlet weak var tagLabel1_width: NSLayoutConstraint!
    @IBOutlet weak var tagLabel1_height: NSLayoutConstraint!
    @IBOutlet weak var tagLabel2: UIView!
    @IBOutlet weak var tagLabel2_width: NSLayoutConstraint!
    @IBOutlet weak var tagLabel2_height: NSLayoutConstraint!
    @IBOutlet weak var tagLabel3: UIView!
    @IBOutlet weak var tagLabel3_width: NSLayoutConstraint!
    @IBOutlet weak var tagLabel3_height: NSLayoutConstraint!
    @IBOutlet weak var tagLabel4: UIView!
    @IBOutlet weak var tagLabel4_width: NSLayoutConstraint!
    @IBOutlet weak var tagLabel4_height: NSLayoutConstraint!
    @IBOutlet weak var tagLabel5: UIView!
    @IBOutlet weak var tagLabel5_width: NSLayoutConstraint!
    @IBOutlet weak var tagLabel5_height: NSLayoutConstraint!

    let defaultTagWidth: CGFloat = 38, defaultTagHeight: CGFloat = 18
    let selectedTagWidth: CGFloat = 38 * 1.3, selectedTagHeight: CGFloat = 18 * 1.3
    
    let defaultAlignWidth: CGFloat = 60, defaultAlignHeight: CGFloat = 18
    let selectedAlignWidth: CGFloat = 60 * 1.3, selectedAlignHeight: CGFloat = 18 * 1.3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vocaTitle.delegate = self
        self.navigationItem.title = "New voca".localized
        tagColorHeader.text = "Tag color".localized
        vocaTitleHeader.text = "Voca title".localized
        vocaTitle.placeholder = "Voca title".localized
        languageHeader.text = "Language".localized
        wordCountInspector.text = "Word count".localized
        leftBarButtonItem.title = "Cancel".localized
        rightBarButtonItem.title = "Next".localized
        previewButton.setTitle("Preview".localized, for: .normal)
        
        
        
        if(editMode) {
            self.navigationItem.title = "Edit voca".localized
            
            // 기존 데이터 저장
            tempDataForEditMode = TempDataForEditMode(tag: tempData.getTag(), vocaTitle: tempData.getVocaTitle(), language: tempData.getLanguage(), wordCount: tempData.getWordCount(), words: tempData.getWords(), means: tempData.getMeans())
            
            
            tempData.setTag(tag: voca.getTag())
            tempData.setVocaTitle(vocaTitle: voca.getTitle())
            tempData.setLanguage(language: voca.getLanguage())
            
            wordCountInspector.isHidden = true
            wordCountSelector.isHidden = true
            
            let doneButton = UIBarButtonItem(title: "Done".localized, style: .done, target: self, action: #selector(doneEditMode))
            navigationItem.rightBarButtonItem = doneButton
        } else {
            tempData.setTag(tag: newVocaDB.getLastTag())
            tempData.setLanguage(language: newVocaDB.getLastLanguage())
            // tempData.setLanguage(language: TTSData().LtoS(language: newVocaDB.getLastLanguage()))
            tempData.setWordCount(wordCount: newVocaDB.getLastWordCount())
        }
        initUI()
    }
    
    @objc func doneEditMode() {
        self.view.endEditing(true)
        if(tempData.getVocaTitle() == "") {
            vocaTitle.becomeFirstResponder()
            AlertController().simpleAlert(viewController: self, title: "", message: "Please enter a vocabulary name.".localized)
            return
        }
        
        VocaDB.getInstance.editVocaInfo(voca: voca, tag: tempData.getTag(), title: tempData.getVocaTitle(), language: tempData.getLanguage())
        
        // 이후
        exitEditMode()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // 기존 데이터 원상 복구
    func exitEditMode() {
        tempData.setTag(tag: tempDataForEditMode.getTag())
        tempData.setVocaTitle(vocaTitle: tempDataForEditMode.getVocaTitle())
        tempData.setLanguage(language: tempDataForEditMode.getLanguage())
        tempData.setWordCount(wordCount: tempDataForEditMode.getWordCount())
        tempData.setWords(words: tempDataForEditMode.getWords())
        tempData.setMeans(means: tempDataForEditMode.getMeans())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Set Tag Color
        let tag = tempData.getTag()
        selectTag(at: tag)
        
        // Set Voca Title
        let vocaName = tempData.getVocaTitle()
        vocaTitle.text = vocaName

        // Set Language
        let language = tempData.getLanguage()
        languageLabel.text = language
        if(language == "Select".localized) {
            languageLabel.textColor = UIColor.lightGray
        } else {
            languageLabel.textColor = UIColor.black
        }
        
        // Set Word Count
        let wordCount = tempData.getWordCount()
        wordCountLabel.text = wordCount
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        if(editMode) {
            exitEditMode()
            editMode = false
        } else {
            newVocaDB.setLastWordCount(lastWordCount: tempData.getWordCount())
            tempData.clear()
        }
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        
        var isValid = false
        if(tempData.getVocaTitle() == "") {
            let message = "Please enter a vocabulary name.".localized
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok".localized, style: .default, handler: { _ in
                self.vocaTitle.becomeFirstResponder()
            })
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        } else if(tempData.getLanguage() == "Select".localized) {
            let message = "Please select a language.".localized
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok".localized, style: .default, handler: { _ in
                self.performSegue(withIdentifier: "SelectLanguage", sender: nil)
            })
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            isValid = true
        }
        
        if(isValid) {
            self.performSegue(withIdentifier: "WordFormSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SelectLanguage") {
            (segue.destination as! SelectLanguageVC).editMode = editMode
            tempData.setLanguage(language: languageLabel.text!)
        }
        if(segue.identifier == "SelectWordCount") {
            tempData.setWordCount(wordCount: wordCountLabel.text!)
        }
        if(segue.identifier == "PreviewVCSegue") {
            self.view.endEditing(true)
        }
    }

    func setCornerRadius(view: UIView) {
        view.layer.cornerRadius = view.bounds.height / 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tempData.setVocaTitle(vocaTitle: getVocaTitle())
    }
    
    func getVocaTitle() -> String {
        if let title = vocaTitle.text {
            return title
        }
        return ""
    }
}

extension NewVocaVC {
    func initUI() {
        vocaTitle.text = tempData.getVocaTitle()
        
        tagLabel1.backgroundColor = palette.getBlue()
        tagLabel2.backgroundColor = palette.getGreen()
        tagLabel3.backgroundColor = palette.getYellow()
        tagLabel4.backgroundColor = palette.getRed()
        tagLabel5.backgroundColor = palette.getPurple()
        setLayer(label: tagLabel1)
        setLayer(label: tagLabel2)
        setLayer(label: tagLabel3)
        setLayer(label: tagLabel4)
        setLayer(label: tagLabel5)
        
        selectTag(at: tempData.getTag())
    }
    
    func setLayer(label: UIView) {
        let layer = label.layer
        layer.cornerRadius = 4
    }
    
    func selectTag(at: Int) {
        tempData.setTag(tag: at)
        if(!editMode) {
            newVocaDB.setLastTag(lastTag: tempData.getTag())
        }
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            if(at == 1) {
                self.selectedTagUI(view: self.tagLabel1, width: self.tagLabel1_width, height: self.tagLabel1_height)
            } else {
                self.defaultTagUI(view: self.tagLabel1, width: self.tagLabel1_width, height: self.tagLabel1_height)
            }
            if(at == 2) {
                self.selectedTagUI(view: self.tagLabel2, width: self.tagLabel2_width, height: self.tagLabel2_height)
            } else {
                self.defaultTagUI(view: self.tagLabel2, width: self.tagLabel2_width, height: self.tagLabel2_height)
            }
            if(at == 3) {
                self.selectedTagUI(view: self.tagLabel3, width: self.tagLabel3_width, height: self.tagLabel3_height)
            } else {
                self.defaultTagUI(view: self.tagLabel3, width: self.tagLabel3_width, height: self.tagLabel3_height)
            }
            if(at == 4) {
                self.selectedTagUI(view: self.tagLabel4, width: self.tagLabel4_width, height: self.tagLabel4_height)
            } else {
                self.defaultTagUI(view: self.tagLabel4, width: self.tagLabel4_width, height: self.tagLabel4_height)
            }
            if(at == 5) {
                self.selectedTagUI(view: self.tagLabel5, width: self.tagLabel5_width, height: self.tagLabel5_height)
            } else {
                self.defaultTagUI(view: self.tagLabel5, width: self.tagLabel5_width, height: self.tagLabel5_height)
            }
            
            self.tagSelector.layoutIfNeeded()
        })
        
        
    }
    
    func selectedTagUI(view: UIView, width: NSLayoutConstraint, height: NSLayoutConstraint) {
        width.constant = selectedTagWidth
        height.constant = selectedTagHeight
    }
    
    func defaultTagUI(view: UIView, width: NSLayoutConstraint, height: NSLayoutConstraint) {
        width.constant = defaultTagWidth
        height.constant = defaultTagHeight
    }
    
    @IBAction func tagAction1(_ sender: UITapGestureRecognizer) {
        selectTag(at: 1)
    }
    @IBAction func tagAction2(_ sender: UITapGestureRecognizer) {
        selectTag(at: 2)
    }
    @IBAction func tagAction3(_ sender: UITapGestureRecognizer) {
        selectTag(at: 3)
    }
    @IBAction func tagAction4(_ sender: UITapGestureRecognizer) {
        selectTag(at: 4)
    }
    @IBAction func tagAction5(_ sender: UITapGestureRecognizer) {
        selectTag(at: 5)
    }
    
}


class VocaTitle: UITextField {
    let padding = UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 20)
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}



class TempData {
    static let getInstance = TempData()
    private var tag: Int
    private var vocaTitle: String
    private var language: String
    private var wordCount: String
    private var words = [String]()
    private var means = [String]()
    
    init() {
        tag = 1
        vocaTitle = ""
        language = "Select".localized
        wordCount = "20"
        words = [String](repeating: "", count: 20)
        means = [String](repeating: "", count: 20)
    }
    
    func clear() {
        tag = 1
        language = "Select".localized
        wordCount = "20"
        words = [String](repeating: "", count: 20)
        means = [String](repeating: "", count: 20)
    }
    
    func setTag(tag: Int) {
        self.tag = tag
    }
    
    func getTag() -> Int {
        return tag
    }

    func setVocaTitle(vocaTitle: String) {
        self.vocaTitle = vocaTitle
    }
    
    func getVocaTitle() -> String {
        return vocaTitle
    }
    
    func setLanguage(language: String) {
        self.language = language
    }
    
    func getLanguage() -> String {
        return language
    }
    
    func setWordCount(wordCount: String) {
        self.wordCount = wordCount
    }
    
    func getWordCount() -> String {
        return wordCount
    }
    
    func setWord(at: Int, word: String) {
        words[at] = word
    }
    
    func getWord(at: Int) -> String {
        return words[at]
    }
    
    func setMean(at: Int, mean: String) {
        means[at] = mean
    }
    
    func getMean(at: Int) -> String {
        return means[at]
    }
    
    func setWords(words: [String]) {
        self.words = words
    }
    
    func getWords() -> Array<String> {
        return words
    }
    
    func setMeans(means: [String]) {
        self.means = means
    }
    
    func getMeans() -> Array<String> {
        return means
    }
    
    func removeRow(at: Int) {
        words.remove(at: at)
        means.remove(at: at)
        words.append("")
        means.append("")
    }
}


class TempDataForEditMode {
    private var tag: Int
    private var vocaTitle: String
    private var language: String
    private var wordCount: String
    private var words = [String]()
    private var means = [String]()
    
    init(tag: Int, vocaTitle: String, language: String, wordCount: String, words: [String], means: [String]) {
        self.tag = tag
        self.vocaTitle = vocaTitle
        self.language = language
        self.wordCount = wordCount
        self.words = words
        self.means = means
    }
    
    func getTag() -> Int {
        return tag
    }
    
    func getVocaTitle() -> String {
        return vocaTitle
    }
    
    func getLanguage() -> String {
        return language
    }
    
    func getWordCount() -> String {
        return wordCount
    }
    
    func getWords() -> Array<String> {
        return words
    }
    
    func getMeans() -> Array<String> {
        return means
    }
}
