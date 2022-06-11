//
//  RealmController.swift
//  TTS Voca
//
//  Created by 정지환 on 19/05/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import RealmSwift


class DB {
    static let getInstance = DB()
    let realm: Realm
    let appResults: Results<App>
    let userResults: Results<User>
    let vocaTableDataResults: Results<VocaTableData>
    let settingResults: Results<Setting>
    let vocaCountResults: Results<VocaCount>
    let dictionaryListResults: Results<DictionaryList>
    
    init() {
        realm = try! Realm()
        appResults = realm.objects(App.self)
        userResults = realm.objects(User.self)
        vocaTableDataResults = realm.objects(VocaTableData.self)
        settingResults = realm.objects(Setting.self)
        vocaCountResults = realm.objects(VocaCount.self)
        dictionaryListResults = realm.objects(DictionaryList.self)
        
         // First Launch
        if(userResults.isEmpty) {
            try! realm.write {
                realm.add(App())
                realm.add(User())
                realm.add(VocaTableData())
                realm.add(Setting())
                realm.add(VocaCount())
                realm.add(DictionaryList())
                
                switch Locale.current.languageCode {
                case "ko":
                    userResults.first!.setUserTTSLanguage(userTTSLanguage: "Korean (South Korea)")
                    break
                case "ja":
                    userResults.first!.setUserTTSLanguage(userTTSLanguage: "Japanese (Japan)")
                    break
                default:
                    userResults.first!.setUserTTSLanguage(userTTSLanguage: "English (United States)")
                    break
                }
                
                // set Sample Voca
                let sampleData: SampleData = SampleData()
                let sampleVoca: [Voca] = sampleData.getSampleVoca()
                
                for voca in sampleVoca {
                    vocaTableDataResults.first!.addVoca(voca: voca)
                }
                
                // set Empty Dictionary Data
                dictionaryListResults.first!.initDict()
            }
        }
    }
    
    func getRealm() ->Realm {
        return realm
    }
    
    func getApp() -> App {
        return appResults.first!
    }
    
    func getUser() -> User {
        return userResults.first!
    }
    
    func getVocaTableData() -> VocaTableData {
        return vocaTableDataResults.first!
    }
    
    func getSetting() -> Setting {
        return settingResults.first!
    }
    
    func getVocaCount() -> VocaCount {
        return vocaCountResults.first!
    }
    
    func getDictionaryList() -> DictionaryList {
        return dictionaryListResults.first!
    }
}

class AppDB {
    static let getInstance: AppDB = AppDB()
    let db: DB
    let realm: Realm
    let app: App
    
    init() {
        db = DB.getInstance
        realm = db.getRealm()
        app = db.getApp()
    }
    
    func isFirstLaunch() -> Bool {
        if(app.getIsFirstLaunch()) {
            try! realm.write {
                app.setIsFirstLaunch(isFirstLaunch: false)
            }
            return true
        } else {
            return false
        }
    }
    func getVersion() -> Float {
        return app.getVersion()
    }
}


class UserDB {
    static let getInstance: UserDB = UserDB()
    let db: DB
    let realm: Realm
    let user: User
    init() {
        db = DB.getInstance
        realm = db.getRealm()
        user = db.getUser()
    }
    func logout() {
        setEmail(email: "")
        setProfileData(profileImage: UIImage(named: "GoogleLogo")!.pngData()!)
        setSlotCount(slotCount: 10)
    }
    func isLoggedin() -> Bool {
        return !(user.getEmail() == "")
    }
    func getProfileData() -> Data {
        return user.getprofileImage()
    }
    func setProfileData(profileImage: Data) {
        try! realm.write {
            user.setProfileImage(profileImage: profileImage)
        }
    }
    func getName() -> String {
        return user.getName()
    }
    func setName(name: String) {
        try! realm.write {
            user.setName(name: name)
        }
    }
    func getOfferEnterprise() -> String {
        return user.getOfferEnterprise()
    }
    func setOfferEnterprise(offerEnterprise: String) {
        try! realm.write {
            user.setOfferEnterprise(offerEnterprise: offerEnterprise)
        }
    }
    func isTutorial1() -> Bool {
        if(user.getTutorial1()) {
            try! realm.write {
                user.setTutorial1(tutorial1: false)
            }
            return true
        } else {
            return false
        }
    }
    func getTutorial2() -> Bool {
        return user.getTutorial2()
    }
    func setTutorial2(tutoreal2: Bool) {
        try! realm.write {
            user.setTutorial2(tutorial2: false)
        }
    }
    func endLearning(exp: Int, learningTime: Int) {
        try! realm.write {
            user.addExp(todayExp: exp)
            user.addTodayLearningTime(learningTime: learningTime)
        }
    }
    func getRecent7DaysExp(date: Date) -> Array<Int> {
        return user.getRecent7DaysExp(date: date)
    }
    func getVocaCount() -> Int {
        return user.getVocaCount()
    }
    func getEmail() -> String {
        return user.getEmail()
    }
    func setEmail(email: String) {
        try! realm.write {
            user.setEmail(email: email)
        }
    }
    func getSlotCount() -> Int {
        return user.getSlotCount()
    }
    func setSlotCount(slotCount: Int) {
        try! realm.write {
            user.setSlotCount(slotCount: slotCount)
        }
    }
    func getTotalWordCount() -> Int {
        return user.getTotalWordCount()
    }
    func getTotalExp() -> Int {
        return user.getTotalExp()
    }
    func getTotalLearningTime() -> Int {
        return user.getTotalLearningTime()
    }
    func getTodayLearningTime() -> Int {
        var todayLearningTime: Int = 0
        try! realm.write {
            todayLearningTime = user.getTodayLearningTime()
        }
        return todayLearningTime
    }
    func getLastVocaShowType() -> Direction {
        switch user.getLastVocaShowType() {
        case 0:
            return .left
        case 1:
            return .center
        case 2:
            return .right
        default:
            return .center
        }
    }
    func setLastVocaShowType(type: Direction) {
        try! realm.write {
            switch type {
            case .left:
                user.setLastVocaShowType(lastVocaShowType: 0)
                break
            case .center:
                user.setLastVocaShowType(lastVocaShowType: 1)
                break
            case .right:
                user.setLastVocaShowType(lastVocaShowType: 2)
                break
            }
        }
    }
    func getUserTTSLanguage() -> String {
        return user.getUserTTSLanguage()
    }
    func setUserTTSLanguage(userTTSLanguage: String) {
        try! realm.write {
            user.setUserTTSLanguage(userTTSLanguage: userTTSLanguage)
        }
    }
}


class SettingDB {
    static let getInstance: SettingDB = SettingDB()
    let db: DB
    let realm: Realm
    let setting: Setting
    init() {
        db = DB.getInstance
        realm = db.getRealm()
        setting = db.getSetting()
    }
    
    func setEbbinghaus(ebbinghaus: Bool) {
        try! realm.write {
            setting.setEbbinghaus(ebbinghaus: ebbinghaus)
        }
    }
    func getEbbinghaus() -> Bool {
        return setting.getEbbinghaus()
    }
    func setBeLeftUndoneAlert(beLeftUndoneAlert: Bool) {
        try! realm.write {
            setting.setBeLeftUndoneAlert(beLeftUndoneAlert: beLeftUndoneAlert)
        }
    }
    func getBeLeftUndoneAlert() -> Bool {
        return setting.getBeLeftUndoneAlert()
    }
    func setBeLeftUndoneAlertTime(beLeftUndoneAlertTime: Int) {
        try! realm.write {
            setting.setBeLeftUndoneAlertTime(beLeftUndoneAlertTime: beLeftUndoneAlertTime)
        }
    }
    func getBeLeftUndoneAlertTime() -> Int {
        return setting.getBeLeftUndoneAlertTime()
    }
    func setTTS(tts: Bool) {
        try! realm.write {
            setting.setTTS(tts: tts)
        }
    }
    func getTTS() -> Bool {
        return setting.getTTS()
    }
    func setShortAnswer(shortAnswer: Bool) {
        try! realm.write {
            setting.setShortAnswer(shortAnswer: shortAnswer)
        }
    }
    func getShortAnswer() -> Bool {
        return setting.getShortAnswer()
    }
    func setTTSSpeed(ttsSpeed: Float) {
        try! realm.write {
            setting.setTTSSpeed(ttsSpeed: ttsSpeed)
        }
    }
    func getTTSSpeed() -> Float {
        return setting.getTTSSpeed()
    }
    
}

class NewVocaDB {
    static let getInstance: NewVocaDB = NewVocaDB()
    let db: DB
    let realm: Realm
    let user: User
    let vocaCount: VocaCount
    init() {
        db = DB.getInstance
        realm = db.getRealm()
        user = db.getUser()
        vocaCount = db.getVocaCount()
    }
    
    func setLastTag(lastTag: Int) {
        try! realm.write {
            user.setLastTag(lastTag: lastTag)
        }
    }
    
    func getLastTag() -> Int {
        return user.getLastTag()
    }
    
    func setLastLanguage(lastLanguage: String) {
        try! realm.write {
            user.setLastLanguage(lastLanguage: lastLanguage)
        }
    }
    
    func getLastLanguage() -> String {
        return user.getLastLanguage()
    }
    
    func setLastWordCount(lastWordCount: String) {
        try! realm.write {
            user.setLastWordCount(lastWordCount: lastWordCount)
        }
    }
    
    func getLastWordCount() -> String {
        return user.getLastWordCount()
    }
    
    func getNextNum() -> Int {
        try! realm.write {
            vocaCount.addCount()
        }
        return vocaCount.getCount()
    }
    
    func addVoca(num: Int, title: String, uploadDate: Date, language: String, e_Status: Int, e_Date: Date, tag: Int, learningCount: Int, wordCount: Int, words: [String], means: [String]) {
        try! realm.write {
            let voca: Voca = Voca()
            voca.setNum(num: num)
            voca.setTitle(title: title)
            voca.setCreateDate(uploadDate: uploadDate)
            voca.setLanguage(language: language)
            voca.setE_Status(e_Status: e_Status)
            voca.setE_Date(e_Date: e_Date)
            voca.setTag(tag: tag)
            voca.setLearningCount(learningCount: learningCount)
            voca.setWordCount(wordCount: wordCount)
            voca.setWordList(words: words)
            voca.setMeanList(means: means)
            
            db.getVocaTableData().addVoca(voca: voca)
            
            user.setVocaCount(vocaCount: user.getVocaCount() + 1)
            user.setTotalWordCount(totalWordCount: user.getTotalWordCount() + wordCount)
        }
    }
}


class VocaListDB {
    static let getInstance: VocaListDB = VocaListDB()
    let db: DB
    let realm: Realm
    let user: User
    let vocaTableData: VocaTableData
    var vocaList: List<Voca>
    
    init() {
        db = DB.getInstance
        realm = db.getRealm()
        user = db.getUser()
        vocaTableData = db.getVocaTableData()
        vocaList = vocaTableData.getVocaList()
    }
    
    func getList(tag: Int) -> [Voca] {
        var resultList: [Voca] = [Voca]()
        if(tag == 0) {
            resultList = Array(vocaList)
        } else {
            resultList = Array(vocaList).filter { $0.getTag() == tag }
        }
        return resultList
    }
    
    func deleteVoca(num: Int) {
        try! realm.write {
            var i: Int = 0
            for voca in vocaList {
                if(num == voca.getNum()) {
                    let totalWordCount: Int = user.getTotalWordCount()
                    let vocaWordCount: Int = voca.getWordCount()
                    user.setVocaCount(vocaCount: user.getVocaCount() - 1)
                    user.setTotalWordCount(totalWordCount: totalWordCount - vocaWordCount)
                    
                    let slotCount = user.getSlotCount()
                    if(slotCount <= vocaList.count - 1) { // 슬롯이 오버된 상태에서
                        if(voca.getIsEnable()) { // 지울 단어장이 활성화된 단어장이라면
                            vocaList[slotCount].setIsEnable(isEnable: true)
                        }
                    }
                    vocaList.remove(at: i)
                    break
                }
                i += 1
            }
        }
    }
    
    func setNotification(num: Int, isOn: Bool) {
        try! realm.write {
            var i: Int = 0
            for voca in vocaList {
                if(num == voca.getNum()) {
                    voca.setNotification(notification: isOn)
                    break
                }
                i += 1
            }
        }
    }
    
    // slot이 부족한지 체크
    func isSlotIsShort() -> Bool { // be short : 모자라다
        let slotCount = user.getSlotCount()
        if(slotCount < vocaList.count) {
            return true
        } else {
            return false
        }
    }
    
    // 로그인, 로그아웃 시에만 호출.
    func setVocaEnableStatusBySlotCount() {
        let slotCount = user.getSlotCount()
//        print(slotCount)
        try! realm.write {
            var i: Int = 1
            for voca in vocaList {
                if(i > slotCount) {
//                    print("disable: \(voca.getTitle())")
                    voca.setIsEnable(isEnable: false)
                } else {
//                    print("enable: \(voca.getTitle())")
                    voca.setIsEnable(isEnable: true)
                }
                i += 1
            }
        }
    }
}

class VocaDB {
    static let getInstance: VocaDB = VocaDB()
    let db: DB
    let realm: Realm
    let user: User
    
    init() {
        db = DB.getInstance
        realm = db.getRealm()
        user = db.getUser()
    }
    
    // Complete Learning
    func updateVocaForLearn(voca: Voca, learningTime: Int, learningCount: Int, e_Status: Int, e_Date: Date) {
        try! realm.write {
            voca.setLearningTime(learningTime: learningTime)
            voca.setLearningCount(learningCount: learningCount)
            voca.setE_Status(e_Status: e_Status)
            voca.setE_Date(e_Date: e_Date)
        }
    }
    
    // Voca Word Editing
    func updateVocaWord(voca: Voca, wordCount: Int, words: [String], means: [String]) {
        try! realm.write {
            let currentWordCount = user.getTotalWordCount()
            let totalWordCount = currentWordCount - voca.getWordCount() + wordCount
            user.setTotalWordCount(totalWordCount: totalWordCount)
            
            voca.setWordCount(wordCount: wordCount)
            voca.setWordList(words: words)
            voca.setMeanList(means: means)
        }
    }
    
    // Voca Info Editing
    func editVocaInfo(voca: Voca, tag: Int, title: String, language: String) {
        try! realm.write {
            voca.setTag(tag: tag)
            voca.setTitle(title: title)
            voca.setLanguage(language: language)
        }
    }
    
    func setNotification(voca: Voca, notification: Bool) {
        try! realm.write {
            voca.setNotification(notification: notification)
        }
    }
}


class DictionaryDB {
    static let getInstance: DictionaryDB = DictionaryDB()
    let db: DB
    let realm: Realm
    let dictionaryList: DictionaryList
    
    init() {
        db = DB.getInstance
        realm = db.getRealm()
        dictionaryList = db.getDictionaryList()
    }
    
    // if you want to get Global Dict, call languageNumber 36.
    func getDictionary(languageNum: Int, dictionaryNum: Int) -> Dictionary {
//        print(dictionaryList.getDictionary(languageNum: languageNum, dictionaryNum: dictionaryNum).getTitle())
        return dictionaryList.getDictionary(languageNum: languageNum, dictionaryNum: dictionaryNum)
    }
    
    func setDictionary(languageNum: Int, dictionaryNum: Int, isEnable: Bool, title: String, prefix: String, suffix: String) {
        try! realm.write {
            let dict = Dictionary()
            dict.setIsEnable(isEnable: isEnable)
            dict.setTitle(title: title)
            dict.setPrefix(prefix: prefix)
            dict.setSuffix(suffix: suffix)
            dictionaryList.replaceDictionary(languageNum: languageNum, dictionaryNum: dictionaryNum, dictionary: dict)
        }
    }
}
