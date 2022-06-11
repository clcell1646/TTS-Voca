//
//  SelectWordCountVC.swift
//  TTS Voca
//
//  Created by 정지환 on 04/06/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import UIKit

class SelectWordCountVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tempData: TempData = TempData.getInstance
    @IBOutlet weak var numberTable: UITableView!
    
    override func viewDidLoad() {
        numberTable.rowHeight = 43.0
        numberTable.dataSource = self
        numberTable.delegate = self
        
        let nibName = UINib(nibName: "BasicCell", bundle: nil)
        numberTable.register(nibName, forCellReuseIdentifier: "BasicCell")
        
        self.navigationItem.title = "Word count".localized
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 17
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let checkedWordCount = tempData.getWordCount()
        let wordCount = String(indexPath.row + 4)
        
        
        let cell = numberTable.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as! BasicCell
        if(wordCount == checkedWordCount) {
            cell.setData(title: String(wordCount), imageName: "check")
        } else {
            cell.setData(title: String(wordCount))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tempData.setWordCount(wordCount: String(indexPath.row + 4))
        NewVocaDB.getInstance.setLastWordCount(lastWordCount: tempData.getWordCount())
        numberTable.deselectRow(at: indexPath, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
}


class SelectWordCountCell: UITableViewCell {
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var checkLabel: UIImageView!
    func setText(number: String) {
        numberLabel.text = number
    }
    
    func check() {
        checkLabel.isHidden = false
    }
    
    func uncheck() {
        checkLabel.isHidden = true
    }
}


