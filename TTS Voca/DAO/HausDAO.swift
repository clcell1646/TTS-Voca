//
//  HTTPController.swift
//  TTS Voca
//
//  Created by 정지환 on 18/08/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import Foundation
import TAKUUID

class HausDAO {
    let prefix: String = "http://cloudvoca.co.kr/"
    
    // -1 그대로이면 통신 실패, 이메일이 존재하지 않더라도 서버에선 10 이 반환된다.
    func getSlot(email: String, fullName: String, profileURL: URL) -> Int {
        var slot: Int = -1
        
        let email: String = email
        let fullName: String = fullName
        let profileURL: String = "\(profileURL)"
        var profileURL_wrap: String = ""
        for ch in profileURL {
            if(ch == "&") {
                profileURL_wrap += "뛟"
            } else {
                profileURL_wrap += "\(ch)"
            }
        }

        let param = "email=\(email)&fullName=\(fullName)&profileURL=\(profileURL_wrap)"
        let paramData = param.data(using: .utf8)
        
        let order = "GetSlot.do"
        let url = URL(string: prefix + order)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")
        
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // 서버가 응답이 없거나 통신이 실패
            if let e = error {
                NSLog("An error has occured: \(e.localizedDescription)")
                semaphore.signal()
                return
            }
            
            if let r = response as? HTTPURLResponse {
//                print("r: \(r)")
                if let sl = r.allHeaderFields["slot"] as? String {
                    if let s = Int(sl) {
                        slot = s
                    }
                }
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        return slot
    }
    
    func updateSlot(email: String, buySlot: Int) -> Bool {
        var complete: Bool = false
        
        // 전송할 값
        let email: String = email
        let buySlot: String = String(buySlot)
        let param = "email=\(email)&buySlot=\(buySlot)"
        let paramData = param.data(using: .utf8)
        
        // URL 객체 정의
        let order = "UpdateSlot.do"
        let url = URL(string: prefix + order)
        
        // URLRequest 객체를 정의
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        // HTTP 메시지 헤더
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")
        
//        print("email: \(email)")
        
        let semaphore = DispatchSemaphore(value: 0)
        // URLSession 객체를 통해 전송, 응답값 처리
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // 서버가 응답이 없거나 통신이 실패
            if let e = error {
                NSLog("An error has occured: \(e.localizedDescription)")
                complete = false
                semaphore.signal()
                return
            }
            
            if let r = response as? HTTPURLResponse {
                if let result = r.allHeaderFields["result"] as? String {
                    if(result == "success") {
                        complete = true
                    } else {
                        complete = false
                    }
                }
            }
            semaphore.signal()
        }
        // POST 전송
        task.resume()
        semaphore.wait()
        return complete
    }
    
    func getUUID() -> String {
        var uuid: String = ""
        
        let email = UserDB.getInstance.getEmail()
        if(email == "") {
            return "not logged-in device"
        }
        
        let param = "email=\(email)"
        let paramData = param.data(using: .utf8)
        
        let order = "GetUUID.do"
        let url = URL(string: prefix + order)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")
        
        
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
//                NSLog("An error has occured: \(e.localizedDescription)")
                uuid = "error"
                semaphore.signal()
                return
            }
            
            if let r = response as? HTTPURLResponse {
//                print(r)
                if let dbUUID = r.allHeaderFields["uuid"] as? String {
                    uuid = dbUUID
                } else {
                    uuid = "error"
                }
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
        return uuid
    }
    
    func updateUUID() { // -> Bool {
//        var complete: Bool = false
        
        let email = UserDB.getInstance.getEmail()
        let uuid = TAKUUIDStorage.sharedInstance().findOrCreate()!
        let param = "email=\(email)&uuid=\(uuid)"
        let paramData = param.data(using: .utf8)
        
        let order = "UpdateUUID.do"
        let url = URL(string: prefix + order)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")
        
        
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let e = error {
                NSLog("An error has occured: \(e.localizedDescription)")
//                complete = false
                semaphore.signal()
                return
            }
            
            if let r = response as? HTTPURLResponse {
//                print(r)
                if let result = r.allHeaderFields["result"] as? String {
                    if(result == "success") {
//                        complete = true
                    } else {
//                        complete = false
                    }
                }
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        
//        return complete
    }
    
    func isSameUUID() -> Bool {
        let dbUUID = getUUID()
        if(!(dbUUID == "error")) { // 에러이거나(셀룰러나 wifi연결안됨) uuid가 비어있으면 그냥 같다고 해줌...
            if(!(dbUUID == "not logged-in device")) { // 로컬 기기에 로그인하지 않음.
                let deviceUUID = TAKUUIDStorage.sharedInstance().findOrCreate()
                if(!(dbUUID == deviceUUID)) {
                    return false
                }
            }
        }
        return true
    }
}
