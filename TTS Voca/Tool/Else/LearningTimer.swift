//
//  LearningTimer.swift
//  TTS Voca
//
//  Created by 정지환 on 20/06/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import Foundation


class LearningTimer {
    private var totalTime: Double
    private var startTime: Date!
    
    init() {
        totalTime = 0
        startTime = nil
    }
    
    func startTimer() {
        if(startTime == nil) {
            startTime = Date()
        }
    }
    
    func stopTimer() {
        let currentTime: Date = Date()
        let interval = currentTime.timeIntervalSince(startTime!)
        totalTime += interval
        startTime = nil
    }
    
    func getTotalTime() -> Double {
        return totalTime
    }
}
