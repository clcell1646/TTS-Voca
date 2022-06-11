//
//  SpecialLocalizer.swift
//  TTS Voca
//
//  Created by 정지환 on 25/08/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import Foundation

class SpecialLocalizer {
    private let locale = Locale.current
    //                      ["English", "Korean", "Japanese", "Chinese"]
    let data: [[String]] = [["Level 1", "1단계", "1段階", "chinese1"],
                            ["Level 2", "2단계", "2段階", "chinese2"],
                            ["Level 3", "3단계", "3段階", "chinese3"],
                            ["Level 4", "4단계", "4段階", "chinese4"],
                            ["Level 5", "5단계", "5段階", "chinese5"],
                            ["hour ", "시간 ", "時間 ", "chH "],
                            ["min ", "분 ", "分 ", "chM "],
                            ["sec", "초", "秒", "chS"]]
    
    func localize(string: String) -> String {
        for d in data {
            if(d.first! == string) {
                switch locale.languageCode {
                case "ko":
                    return d[1]
                case "ja":
                    return d[2]
//                case "zh-Hans": // Chinese (Simplified)
//                    return d[3]
//                case "zh-Hant": // Chinese (Traditional)
//                    return d[3]
//                case "zh-HK": // Chinese (Hong Kong)
//                    return d[3]
                default:
                    return d[0]
                }
            }
        }
        return ""
    }
    
    func getLineHeader(string: String) -> String {
        let token = string.components(separatedBy: "Line")
        let num = token.last!
        switch locale.languageCode {
        case "ko":
            return "\(num)번째 단어"
        case "ja":
            return "\(num)行"
//        case "zh-Hans": // Chinese (Simplified)
//            return "\(num)행"
//        case "zh-Hant": // Chinese (Traditional)
//            return "\(num)행"
//        case "zh-HK": // Chinese (Hong Kong)
//            return "\(num)행"
        default:
            return "Row\(num)"
        }
    }
    
    func getSimpleDateFor7days(month: Int, day: Int) -> String {
        switch locale.languageCode {
        case "ko":
            return "\(month)월 \(day)일"
        case "ja":
            return "\(month)月 \(day)日"
//        case "zh-Hans": // Chinese (Simplified)
//            return "\(month)월 \(day)일"
//        case "zh-Hant": // Chinese (Traditional)
//            return "\(month)월 \(day)일"
//        case "zh-HK": // Chinese (Hong Kong)
//            return "\(month)월 \(day)일"
        default:
            return "\(month) / \(day)"
        }
    }
    
    func getBundleTitle(badgeCount: Int) -> String {
        switch Locale.current.languageCode {
        case "ko":
            return "복습할 \(badgeCount)개의 단어장이 있습니다."
        case "ja":
            if(badgeCount < 10) {
                return "復習する\(badgeCount)つの単語帳があります。"
            } else {
                return "復習する\(badgeCount)個の単語帳があります。"
            }
        default:
            return "There are \(badgeCount) wordbook to review."
        }
    }
    
    func getE_NotiBody(title: String, e_Status: Int) -> String {
        switch Locale.current.languageCode {
        case "ko":
            return "단어장 \"\(title)\"의 \(e_Status)단계 복습이 필요합니다."
        case "ja":
            return "単語帳「\(title)」の\(e_Status)段階復習が必要です。"
        default:
            return "The level\(e_Status) review of wordbook \"\(title)\" is required."
        }
    }
}
