//
//  TimeStorage.swift
//  TTS Voca
//
//  Created by 정지환 on 03/06/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

// bar1     첫 학습 : 에빙하우스 1단계
// bar2     10분 뒤 학습 : 에빙하우스 2단계
// bar3     1시간 뒤 학습: 에빙하우스 3단계
// bar4     1일 뒤 학습: 에빙하우스 4단계
// bar5     7일 뒤 학습: 에빙하우스 5단계
// bar6     1달 뒤 학습: 에빙하우스 6단계
// 이후 반복

class EbbinghausTime {
    private let min10: Double, hour1: Double, day1: Double, day7: Double, month1: Double
    init() {
        min10 = 600
        hour1 = min10 * 6
        day1 = hour1 * 24
        day7 = day1 * 7
        month1 = day1 * 30
    }
    func getIntervalLevel1() -> Double {
//        return 10         // 10초
        return min10
    }
    func getIntervalLevel2() -> Double {
//        return 10
        return hour1
    }
    func getIntervalLevel3() -> Double {
//        return 10
        return day1
    }
    func getIntervalLevel4() -> Double {
//        return 10
        return day7
    }
    func getIntervalLevel5() -> Double {
//        return 10
        return month1
    }
    func getRepeatInterval() -> Double {
//        return 10
        return month1
    }
}
