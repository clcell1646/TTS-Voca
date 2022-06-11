//
//  DictionarySettingTVC.swift
//  TTS Voca
//
//  Created by 정지환 on 05/08/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import Foundation
import UIKit

class DictionarySettingTVC: UITableViewController {
    @IBOutlet weak var barButtonSave: UIBarButtonItem!
    @IBOutlet weak var useDictLabel: UILabel!
    var isGlobalDict: Bool = false
    let keyword: String = "study"
    
    @IBOutlet weak var isEnableSwitch: UISwitch!
    @IBOutlet weak var titleTF: CustomDictionaryTextField!
    @IBOutlet weak var autoTF: CustomDictionaryTextField!
    @IBOutlet weak var prefixTF: CustomDictionaryTextField!
    @IBOutlet weak var suffixTF: CustomDictionaryTextField!
    @IBOutlet weak var testTV: UITextView!
    var testURL: String!
    
    var dictEnableSwitchCell: Int = 0 // 전역 사전 설정일 경우 숨길 셀 번호
    
    let headerTitle: [String] = [ "DHeader1".localized,
                                  "DHeader2".localized,
                                  "DHeader3".localized,
                                  "DHeader4".localized,
                                  "DHeader5".localized,
                                  "DHeader6".localized ]
    let footerTitle: [String] = [ "DFooter1".localized,
                                  "DFooter2".localized,
                                  "DFooter3".localized,
                                  "DFooter4".localized,
                                  "DFooter5".localized,
                                  "DFooter6".localized ]
    
    let dictionaryDB: DictionaryDB = DictionaryDB.getInstance
    
    var languageNum: Int!
    var dictionaryNum: Int!
    var dictionary: Dictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTF.delegate = self
        prefixTF.delegate = self
        suffixTF.delegate = self
        
        initiate()
        barButtonSave.title = "Save".localized
    }
    
    func initiate() {
        self.title = dictionary.getTitle()
        useDictLabel.text = "Use dict".localized
        
        isEnableSwitch.setOn(dictionary.getIsEnable(), animated: false)
        titleTF.text = dictionary.getTitle()
        let prefix = dictionary.getPrefix()
        let suffix = dictionary.getSuffix()
        prefixTF.text = prefix
        suffixTF.text = suffix
        let url = dictionary.getPrefix() + keyword + dictionary.getSuffix()
        if(url != keyword) {
            autoTF.text = url
            testTV.text = url
        } else {
            autoTF.text = ""
            testTV.text = ""
        }
        
        autoTF.addTarget(self, action: #selector(autoUpdateURL), for: .editingChanged)
        prefixTF.addTarget(self, action: #selector(updateTestURL), for: .editingChanged)
        suffixTF.addTarget(self, action: #selector(updateTestURL), for: .editingChanged)
    }
    
    @objc func updateTestURL() {
        let url: String = prefixTF.text! + keyword + suffixTF.text!
        if(url != keyword) {
            autoTF.text = url
            testTV.text = url
        } else {
            autoTF.text = ""
            testTV.text = ""
        }
    }
    
    @objc func autoUpdateURL() {
        let autoURL = autoTF.text
        let presuffix: [String]? = autoURL?.components(separatedBy: keyword)
        if let psfix = presuffix {
            if(psfix.count == 2) {
                prefixTF.text = psfix.first
                suffixTF.text = psfix.last
            } else {
                prefixTF.text =  ""
                suffixTF.text =  ""
            }
        } else {
            prefixTF.text =  ""
            suffixTF.text =  ""
        }
        testTV.text = autoURL
    }
    
    
    func setDataFromSuperView(languageNum: Int, dictionaryNum: Int) {
        dictionary = dictionaryDB.getDictionary(languageNum: languageNum, dictionaryNum: dictionaryNum)
        self.languageNum = languageNum
        self.dictionaryNum = dictionaryNum
    }

    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        dictionaryDB.setDictionary(languageNum: languageNum, dictionaryNum: dictionaryNum, isEnable: isEnableSwitch.isOn, title: titleTF.text!, prefix: prefixTF.text!, suffix: suffixTF.text!)
        navigationController?.popViewController(animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(languageNum == 36) {
            switch section {
            case dictEnableSwitchCell:
                return ""
            default:
                break
            }
        }
        return headerTitle[section]
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if(languageNum == 36) {
            switch section {
            case dictEnableSwitchCell:
                return ""
            default:
                break
            }
        }
        return footerTitle[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(languageNum == 36) {
            switch indexPath.section {
            case dictEnableSwitchCell:
                return CGFloat.leastNormalMagnitude
            default:
                break
            }
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(languageNum == 36) {
            switch section {
            case dictEnableSwitchCell:
                return CGFloat.leastNormalMagnitude
            default:
                break
            }
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(languageNum == 36) {
            switch section {
            case dictEnableSwitchCell:
                return CGFloat.leastNormalMagnitude
            default:
                break
            }
        }
        return UITableView.automaticDimension
    }
}

extension DictionarySettingTVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTF.resignFirstResponder()
        autoTF.resignFirstResponder()
        prefixTF.resignFirstResponder()
        suffixTF.resignFirstResponder()
        return true
    }
}

class CustomDictionaryTextField: UITextField {
    let padding = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
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
