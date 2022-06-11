//
//  AppDelegate.swift
//  TTS Voca
//
//  Created by 정지환 on 16/05/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//
//  Design Assist By jjangu

import UIKit
import UserNotifications
import GoogleSignIn
import FBSDKCoreKit
import TAKUUID

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var vocaListDelegate: VocaListDelegate?
    var learningTimer: LearningTimer?
    let eNoti = EbbinghausNotification()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Ebbinghaus Notification
        removeAllNotification()
        
        // Google Login --start--
        GIDSignIn.sharedInstance().clientID = "284722265158-dmp3g8ump8vonkst33o0tkjhmohomk53.apps.googleusercontent.com"
        // Google Login ---end---
        
        // Facebook Login --start--
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        // Facebook Login ---end---

        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let GIDSignInHandler = GIDSignIn.sharedInstance().handle(url)
        
        let FBSignInHandler = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        // 단어장 공유 Import
        if let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            let items = urlComponents.queryItems
            if let type: String = items?.first?.name, let data: String = items?.first?.value {
                print("type: \(type)")
                switch type {
                case "newvoca":
                    // data : [ title, language, tag, wordCount, words, means ]
                    addSharedVoca(data: data.removingPercentEncoding!)
                    break
                default:
                    break
                }
            }
        }
        
        return GIDSignInHandler || FBSignInHandler
    }
    
//    func application(_ application: UIApplication,
//                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        print("else")
//        let GIDSignInHandler = GIDSignIn.sharedInstance().handle(url)
//
//        let FBSignInHandler = ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
//
//        return GIDSignInHandler || FBSignInHandler
//    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        if let lTimer = learningTimer {
            lTimer.stopTimer()
//            print(lTimer.getTotalTime())
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        setEbbinghausNotification()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        removeAllNotification()
//        print("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        removeAllNotification()
        if let lTimer = learningTimer {
            lTimer.startTimer()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func removeAllNotification() {
        eNoti.removeAllNotifications()
//        eNoti.printPendingNotifications()
    }
    
    func setEbbinghausNotification() {
        eNoti.setNotification()
//        eNoti.printPendingNotifications()
    }
    
    func addSharedVoca(data: String) {
        // data : [ title, language, tag, wordCount, words, means ]
        
        // 여기서 슬롯 검증.
        let vocaCount = UserDB.getInstance.getVocaCount()
        if(vocaCount >= UserDB.getInstance.getSlotCount()) { // 단어장 개수가 슬롯 갯수보다 많거나 같은 경우
            AlertController().simpleAlert(viewController: (window?.rootViewController)!, title: "", message: "There is not enough slots to make more voca.".localized)
        } else {
            // hausvoca://?newvoca={"title":}
            let jsonConverter = JSONConverter()
            if let data = jsonConverter.convertToDictionary(text: data) {
                let title = data["title"] as! String
                let language = data["language"] as! String // 존재하는 언어인지 검증.
                let tag = data["tag"] as! String // blue, orange 등... // 존재하는 태그인지 검증.
                var tagInt: Int = 0
                switch tag {
                case "blue":
                    tagInt = 1
                    break
                case "green":
                    tagInt = 2
                    break
                case "yellow":
                    tagInt = 3
                    break
                case "red":
                    tagInt = 4
                    break
                case "purple":
                    tagInt = 5
                    break
                default:
                    break
                }
                let wordCount = data["wordCount"] as! Int // word 개수 아래 실제 개수와 맞는지 검증
                let words = data["words"] as! [String]
                let means = data["means"] as! [String]
                
                let alertController = UIAlertController(title: title, message: "Are you sure you want to add shared wordbook?".localized, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Add".localized, style: .default) { _ in
                    let newVocaDB = NewVocaDB.getInstance
                    let date = Date()
                    newVocaDB.addVoca(num: newVocaDB.getNextNum(),
                                      title: title,
                                      uploadDate: date,
                                      language: language,
                                      e_Status: 0,
                                      e_Date: date,
                                      tag: tagInt,
                                      learningCount: 0,
                                      wordCount: wordCount,
                                      words: words,
                                      means: means)
                    AlertController().simpleAlert(viewController: (self.window?.rootViewController)!, title: "", message: "Added successfully.".localized)
                    if let delegate = self.vocaListDelegate {
                        delegate.reloadVocaTable()
                    }
                }
                alertController.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
                alertController.addAction(alertAction)
                self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                
                print(title)
                print(language)
                print(tag)
                print(wordCount)
                print(words)
                print(means)
            }
        }
    }
}

