//
//  EbbinghausNotifcation.swift
//  TTS Voca
//
//  Created by 정지환 on 10/07/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class EbbinghausNotification {
    let settingDB: SettingDB = SettingDB.getInstance
    let center: UNUserNotificationCenter
    let sl = SpecialLocalizer()
    init() {
        center = UNUserNotificationCenter.current()
    }
    
    func addSimpleNotification(date: Date, title: String, body: String, badge: Int, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.badge = badge as NSNumber
        let nextTriggerDate = Calendar.current.date(byAdding: .second, value: 0, to: date)!
        let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: nextTriggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }
    
    func setNotification() {
        // setBundle
        
        let bluTime: Int = settingDB.getBeLeftUndoneAlertTime() * 60
        let after10min = Date(timeIntervalSinceNow: Double(bluTime)) // 10 분 뒤//                    에빙하우스 복습 알림
        let badgeCount: Int = getBadgeCount(at: after10min)//                           - 복습할 n개의 단어장이 있습니다.
        if(badgeCount != 0 && settingDB.getBeLeftUndoneAlert()) { // 밀린 단어장 알림이 켜져있는 경우, 에빙하우스 알림 On/Off는 관계 없다.    - n개의 복습할 단어장이 밀려있습니다.
            addSimpleNotification(  date: after10min,
                                    title: "bundleTitle".localized,
                                    body: sl.getBundleTitle(badgeCount: badgeCount),
                                    badge: badgeCount,
                                    identifier: "TTSVocaEbbinghausBundle")
            
//            print("밀린 단어장 알림 등록")
        }

        
        
        // setSpecific
        if(settingDB.getEbbinghaus()) { // 에빙하우스 알림이 켜져있다면
            let vocas: Array<Voca> = Array(VocaListDB.getInstance.getList(tag: 0)) // mean All Voca.
            for voca in vocas {
                if(voca.getE_Status() != 0) { // 미학습(새 단어장)인 경우는 알림 대상에서 제외
                    if(voca.getNotification()) { // 개별 알림이 켜져 있는 경우 등록
                        let e_Date = voca.getE_Date() // 복습 알림 시간
                        
                        if(e_Date < Date()) { // 복습 일정이 현재 시간 이전이면
                            continue // 그냥 번들에 포함시켜서 알림.
                        }
                        let bCount = getBadgeCount(at: e_Date) // 알림이 울릴 때의 뱃지 개수를 계산한다.
                        addSimpleNotification(  date: e_Date,
                                                title: "Ebbinghaus notification".localized,
                                                body: sl.getE_NotiBody(title: voca.getTitle(), e_Status: voca.getE_Status()),
                                                badge: bCount,
                                                identifier: "TTSVocaEbbinghaus\(voca.getNum())")
                    }
                }
            }
        }
//        printPendingNotifications()
    }
    
    func getBadgeCount(at: Date) -> Int {
        let vocas: Array<Voca> = Array(VocaListDB.getInstance.getList(tag: 0)) // mean All Voca.
        var badgeCount: Int = 0
        for voca in vocas {
            if(voca.getE_Status() != 0) { // 미학습(새 단어장)이 아닌 경우
                if(voca.getNotification()) { // 개별 알림이 켜져 있는 경우
                    if(voca.getE_Date() <= at) { // 알림이 울리는 시점을 기준으로 e_date가 그 이전인 경우
                        badgeCount += 1
                    }
                }
            }
        }
//        print("badgeCount: \(badgeCount)")
        return badgeCount
    }
    
    func removeAllNotifications() {
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    /*
    private func printPendingNotifications() {
        center.getPendingNotificationRequests(completionHandler: { req in
            print("================Pending start================")
            var i: Int = 1
            for r in req {
                print("\(i)번째 Notification---------------------------")
                print("알림 일자:")
                print(r.trigger!) // 트리거는 DateComponent 정보를 가지고 있음
                print("title: \(r.content.title)")
                print("body:  \(r.content.body)")
                i += 1
            }
            print("=================Pending end=================")
        })
    }
    */
}
