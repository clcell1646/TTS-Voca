//
//  PreviewVC.swift
//  TTS Voca
//
//  Created by 정지환 on 04/06/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import UIKit

class PreviewVC: UIViewController {
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var hausLevelLabel: UILabel!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var newVocaBadge: UIView!
    @IBOutlet weak var vocaTitle: UILabel!
    @IBOutlet weak var languageWordCount: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    let tempData: TempData = TempData.getInstance
    let palette: TagPalette = TagPalette()
    @IBOutlet weak var e_bar1: UIView!
    @IBOutlet weak var e_bar2: UIView!
    @IBOutlet weak var e_bar3: UIView!
    @IBOutlet weak var e_bar4: UIView!
    @IBOutlet weak var e_bar5: UIView!
    //    @IBOutlet weak var e_bar6: UIView!
    
    @IBOutlet weak var cardBadgeLabel: UILabel!
    @IBOutlet weak var totalLearningCountLabel: UILabel!
    
    override func viewDidLoad() {
        navigationTitle.title = "Preview".localized
        hausLevelLabel.text = "Haus level"
        dismissButton.setTitle("Close".localized, for: .normal)
        
        newVocaBadge.layer.cornerRadius = newVocaBadge.frame.height / 2
        newVocaBadge.backgroundColor = palette.getBadgeColor(tag: tempData.getTag())
        cardBadgeLabel.text = "New voca".localized
        
        
        var learningCount_S: String = ""
        learningCount_S.append("Total learnings".localized + " : ")
        learningCount_S.append(String(5))
        learningCount_S.append(" times".localized)
        totalLearningCountLabel.text = learningCount_S
        
        
        let vocaTitle_S: String = tempData.getVocaTitle()
        if(vocaTitle_S == "") {
            vocaTitle.text = "Voca title".localized
        } else {
            vocaTitle.text = vocaTitle_S
        }
        
        let language: String = tempData.getLanguage()
        var languageWordCount_S: String = ""
        if(language == "Select".localized) {
            languageWordCount_S.append("Language")
        } else {
            languageWordCount_S.append(language)
        }
        languageWordCount_S.append(", ")
        languageWordCount_S.append(String(tempData.getWordCount()))
        languageWordCount_S.append(" words".localized)
        languageWordCount.text = languageWordCount_S
        
        palette.setBackground(card: card, tag: tempData.getTag())
        
        let cornerRadius: CGFloat = 1.5
        e_bar1.layer.cornerRadius = cornerRadius
        e_bar2.layer.cornerRadius = cornerRadius
        e_bar3.layer.cornerRadius = cornerRadius
        e_bar4.layer.cornerRadius = cornerRadius
        e_bar5.layer.cornerRadius = cornerRadius
        
        dismissButton.backgroundColor = palette.getTagColor(tag: tempData.getTag())
        dismissButton.layer.cornerRadius = 4
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
