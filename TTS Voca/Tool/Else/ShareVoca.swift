//
//  ShareString.swift
//  TTS Voca
//
//  Created by 정지환 on 04/09/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import Foundation
import UIKit

class ShareVoca {
    func share(vc: UIViewController, voca: Voca) {
        // data : [ title, language, tag, wordCount, words, means ]
        let prefix = "hausvoca://?newvoca="
        let title = "\"title\":\"\(voca.getTitle())\""
        let language = "\"language\":\"\(voca.getLanguage())\""
        var tag: String = "\"tag\":"
        switch voca.getTag() {
        case 1:
            tag += "\"blue\""
            break
        case 2:
            tag += "\"green\""
            break
        case 3:
            tag += "\"yellow\""
            break
        case 4:
            tag += "\"red\""
            break
        case 5:
            tag += "\"purple\""
            break
        default:
            break
        }
        let wordCount = "\"wordCount\":\(voca.getWordCount())"
        let words: [String] = Array(voca.getWordList())
        var wordData: String = "\"words\":["
        
        var i = 0
        for word in words {
            wordData += "\"\(word)\""
            if(i != words.count - 1) {
                wordData += ", "
            }
            i += 1
        }
        wordData += "]"
        
        let means: [String] = Array(voca.getMeanList())
        var meanData: String = "\"means\":["
        
        i = 0
        for mean in means {
            meanData += "\"\(mean)\""
            if(i != means.count - 1) {
                meanData += ","
            }
            i += 1
        }
        meanData += "]"
        
        let dataString = "{" + title + "," + language + "," + tag + "," + wordCount + "," + wordData + "," + meanData + "}"
        let encodedString = dataString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
//        shareString(vc: vc, text: prefix + encodedString)
        if let url = URL(string: prefix + encodedString) {
            shareURL(vc: vc, url: url)
        }
    }
    
    func shareString(vc: UIViewController, text: String) {
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = vc.view
        vc.present(activityViewController, animated: true, completion: nil)
    }
    
    func shareURL(vc: UIViewController, url: URL) {
        let urlShare = [ url ]
        let activityViewController = UIActivityViewController(activityItems: urlShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = vc.view
        vc.present(activityViewController, animated: true, completion: nil)
    }
}
