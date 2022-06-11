//
//  PermissionController.swift
//  TTS Voca
//
//  Created by 정지환 on 10/07/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import UserNotifications


class PermissionController {
    init() {
        
    }
    
    func haveAlertPermission() -> Bool {
        var semaphore: DispatchSemaphore?
        var alertPermission: Bool!
        if #available(iOS 10.0, *) {
            semaphore = DispatchSemaphore(value: 0)
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: { didAllow, Error in
                if(didAllow) {
                    // 권한 있음
                    alertPermission = true
                } else {
                    // 권한 없음
                    alertPermission = false
                }
                semaphore!.signal()
            })
        } else {
            // 버전이 너무 낮음
            alertPermission = false
        }
        if let s = semaphore {
            s.wait()
        }
        return alertPermission
    }
}
