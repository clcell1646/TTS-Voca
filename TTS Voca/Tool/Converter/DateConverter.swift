//
//  DateController.swift
//  TTS Voca
//
//  Created by 정지환 on 20/05/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import Foundation

class DateConverter {
    let df_cal = DateFormatter() // df for calculate
    let df_create = DateFormatter() // df for show
    let df_learn = DateFormatter() // df for E_Date
    let df_result = DateFormatter() // df for Result Page
    let df_global = DateFormatter() // df for Global
    let df_dueDate = DateFormatter() // df for Global Due Date
    
    init() {
        df_cal.dateFormat = "yyyyMMdd"
        df_cal.locale = Locale.current
        
        df_create.dateFormat = "yyyy년 M월 d일"
        df_create.locale = Locale.current
        
        
        switch Locale.current.languageCode {
        case "ko":
            df_learn.dateFormat = "M월 d일 H시 m분"
            break
        case "ja":
            df_learn.dateFormat = "M月 d日 H時 m分"
            break
        default:
            break
        }
        df_learn.locale = Locale.current
        
        df_result.dateFormat = "yyyy.M.d.H.m"
        df_result.locale = Locale.current
        
        df_global.dateFormat = "yyyy.MM.dd"
        df_global.locale = Locale.current
        
        df_dueDate.dateFormat = "MM.dd HH:mm"
        df_dueDate.locale = Locale.current
    }
    
    func DtoI(date: Date) -> Int {
        let dateString: String = df_cal.string(from: date)
        let dateInt: Int = Int(dateString)!
        return dateInt
    }
    
    func DtoS_create(date: Date) -> String {
        let dateString: String = df_create.string(from: date)
        return dateString
    }
    
    func DtoS_learn(date: Date) -> String {
        let dateString: String = df_learn.string(from: date)
        return dateString
    }
    
    func DtoS_resultPage(date: Date) -> String {
        let dateString: String = df_result.string(from: date)
        return dateString
    }
    
    func DtoS_global(date: Date) -> String {
        let dateString: String = df_global.string(from: date)
        return dateString
    }
    
    func DtoS_dueDate(date: Date) -> String {
        switch Locale.current.languageCode {
        case "ko":
            let dateString: String = df_learn.string(from: date)
            return dateString
        case "ja":
            let dateString: String = df_learn.string(from: date)
            return dateString
        default:
            let dateString: String = df_dueDate.string(from: date)
            return dateString
        }
    }
    
    let americanMonth: [String] = [ "January",
                                    "February",
                                    "March",
                                    "April",
                                    "May",
                                    "June",
                                    "July",
                                    "August",
                                    "September",
                                    "October",
                                    "November",
                                    "December" ]
    func getAmericanMonth(month: Int) -> String {
        return americanMonth[month - 1]
    }
}
