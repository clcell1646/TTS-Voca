//
//  SelectDictionaryTVC.swift
//  TTS Voca
//
//  Created by 정지환 on 04/08/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import Foundation
import UIKit

class SelectDictionaryTVC: UITableViewController {
    var isGlobalDict: Bool = false
    
    var languageToShow: String!
    var languageNum: Int!
    var dictionaryNum: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = languageToShow
        
        let nibName = UINib(nibName: "BasicCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "BasicCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func setDataFromSuperView(languageToShow: String, languageNum: Int) {
        self.languageToShow = languageToShow
        self.languageNum = languageNum
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as! BasicCell
        let dictTitle: String = DictionaryDB.getInstance.getDictionary(languageNum: languageNum, dictionaryNum: indexPath.row).getTitle()
        cell.setData(title: dictTitle, imageName: "arrow_right")
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dictionaryNum = indexPath.row
        performSegue(withIdentifier: "DictionarySettingSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "DictionarySettingSegue") {
            let viewController = segue.destination as! DictionarySettingTVC
            viewController.setDataFromSuperView(languageNum: languageNum, dictionaryNum: dictionaryNum)
        }
    }
}


class SelectDictionaryTableCell: UITableViewCell {
    @IBOutlet weak var dictionaryNameLabel: UILabel!
    func setData(dictionaryName: String) {
        dictionaryNameLabel.text = dictionaryName
    }
}
