//
//  BasicDictionarySelectTVC.swift
//  TTS Voca
//
//  Created by 정지환 on 07/08/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import Foundation
import UIKit

class BasicDictionarySelectTVC: UITableViewController {
    let cellTitle = ["Global setting(default)".localized, "Language-specific presets(advanced)".localized]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dictionary settings".localized
        
        let nibName = UINib(nibName: "BasicCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "BasicCell")
        // 초기화 버튼도?
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SelectGlobalDictSegue") {
            let viewController = segue.destination as! SelectDictionaryTVC
            viewController.setDataFromSuperView(languageToShow: "Global setting".localized, languageNum: 36)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "SelectGlobalDictSegue", sender: self)
            break
        case 1:
            performSegue(withIdentifier: "SelectLanguageForDictionarySegue", sender: self)
            break
        default:
            break
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as! BasicCell
        cell.setData(title: cellTitle[indexPath.row], imageName: "arrow_right")
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        self.tabBarController?.tabBar.isHidden = true
    }
}
