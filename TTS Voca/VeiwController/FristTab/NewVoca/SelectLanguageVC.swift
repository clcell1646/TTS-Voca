//
//  SelectLanguageVC.swift
//  TTS Voca
//
//  Created by 정지환 on 04/06/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import UIKit

class SelectLanguageVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var editMode: Bool = false
    var settingUserLanguageMode: Bool = false
    @IBOutlet weak var languageTable: UITableView!
    var languages: [String] = [String]()
    var languagesToShow: [String] = [String]()
    let tempData: TempData = TempData.getInstance
    
    override func viewDidLoad() {
        languageTable.rowHeight = 43.0
        languageTable.dataSource = self
        languageTable.delegate = self
        
        self.title = "Language".localized
        self.navigationItem.largeTitleDisplayMode = .never
        
        let ttsData: TTSData = TTSData()
        languages = ttsData.getLanguage()
        languagesToShow = ttsData.getLanguageToShow()
        
        let nibName = UINib(nibName: "BasicCell", bundle: nil)
        languageTable.register(nibName, forCellReuseIdentifier: "BasicCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(settingUserLanguageMode) {
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var checkedLanguage: String!
        if(settingUserLanguageMode) {
            checkedLanguage = UserDB.getInstance.getUserTTSLanguage()
        } else {
            checkedLanguage = tempData.getLanguage()
        }
        let language = languages[indexPath.row]
        
        let cell = languageTable.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as! BasicCell
        if(language == checkedLanguage) {
            cell.setData(title: languagesToShow[indexPath.row], imageName: "check")
        } else {
            cell.setData(title: languagesToShow[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(settingUserLanguageMode) {
            UserDB.getInstance.setUserTTSLanguage(userTTSLanguage: languages[indexPath.row])
        } else {
            tempData.setLanguage(language: languages[indexPath.row])
            if(!editMode) {
                NewVocaDB.getInstance.setLastLanguage(lastLanguage: tempData.getLanguage())
            }
        }
        languageTable.deselectRow(at: indexPath, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
}


class SelectLanguageCell: UITableViewCell {
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var checkLabel: UIImageView!
    func setText(language: String) {
        languageLabel.text = language
    }
    
    func check() {
        checkLabel.isHidden = false
    }
    
    func uncheck() {
        checkLabel.isHidden = true
    }
}

