//
//  GetRandomAnswer.swift
//  TTS Voca
//
//  Created by 정지환 on 16/06/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import Foundation

class RandomAnswer {
    init() {
        
    }
    
    func get4Answers(array: [String], answer: String) -> [String] {
        var temp: [String] = array
        
        var i: Int = 0
        for e in temp {
            if(e == answer) {
                temp.remove(at: i)
                break
            }
            i += 1
        }
        
        var result: [String] = [String]()
        for _ in 0..<3 {
//            let n = Int.random(in: 0..<temp.count)
            let n = Int(arc4random_uniform(UInt32(temp.count)))
            result.append(temp[n])
            temp.remove(at: n)
        }
        
        let n = Int.random(in: 0..<4)
        if(n == 3) {
            result.append(answer)
        } else {
            result.insert(answer, at: n)
        }
        result.append(String(n))
        return result
    }
}
