//
//  TimeConverter.swift
//  TTS Voca
//
//  Created by 정지환 on 22/06/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import Foundation

class TimeConverter {
    let sl = SpecialLocalizer()
    init() {
        
    }
    
    func ItoS(learningTime: Int) -> String {
        var result: String = ""
        var lTime: Int = learningTime
        let hour = lTime / 3600
        lTime %= 3600
        let minute = lTime / 60
        lTime %= 60
        let second = lTime
        if(hour != 0) {
            result.append(String(hour))
            result.append(sl.localize(string: "hour "))
        }
        if(hour != 0 || minute != 0) {
            result.append(String(minute))
            result.append(sl.localize(string: "min "))
        }
        result.append(String(second))
        result.append(sl.localize(string: "sec"))
        return result
    }
}
