//
//  SelectLanguageForDictionary.swift
//  TTS Voca
//
//  Created by 정지환 on 05/08/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import Foundation
import UIKit

class SelectLanguageForDictionaryTVC: UITableViewController {
    let ttsData = TTSData()
    var languageToShow = [String]()
    var handOverLanguage: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Language-specific presets".localized
        
        languageToShow = ttsData.getLanguageToShow()
        
        let nibName = UINib(nibName: "BasicCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "BasicCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ttsData.getLanguage().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as! BasicCell
        cell.setData(title: languageToShow[indexPath.row], imageName: "arrow_right")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handOverLanguage = languageToShow[indexPath.row]
        performSegue(withIdentifier: "SelectDictionarySegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Language list".localized
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SelectDictionarySegue") {
            let viewController = segue.destination as! SelectDictionaryTVC
            viewController.setDataFromSuperView(languageToShow: handOverLanguage, languageNum: ttsData.StoN(languageToShow: handOverLanguage))
        }
    }
}


class LanguageForDictionaryTableCell: UITableViewCell {
    @IBOutlet weak var languageLabel: UILabel!
    func setData(language: String) {
        languageLabel.text = language
    }
}
