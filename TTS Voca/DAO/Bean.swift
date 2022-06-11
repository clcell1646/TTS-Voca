//
//  Bean.swift
//  TTS Voca
//
//  Created by 정지환 on 19/05/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import Foundation
import RealmSwift

// language = [ 0: English, 1: Japanese, 2,3,4: Chinese, 5: Korean, 6: Spanish, 7: French(불어), 8: German(독어),
// 9: Arabic(아랍어), 10: Hindi language(힌디어), 11: Polish(폴란드어), 12: Russian,
// 13: Italian, 14: Thai(Thailand), 15: Swedish(스웨덴어), 16: Turkish, 17: Greek(그리스어), 18: ]
class Voca: Object {
    @objc private dynamic var num: Int = 0 // 제목이 같을 경우, 셀을 눌렀을 때 해당 보카를 불러오기 위해
    @objc private dynamic var title = ""
    @objc private dynamic var isEnable: Bool = true // 슬롯 부족 시 false.
    @objc private dynamic var createDate: Date = Date()
    @objc private dynamic var language: String = ""
//    @objc private dynamic var languageForVocaList: String = "" // 사용자 언어 설정 기능 추가시
    @objc private dynamic var e_Status: Int = 0     // Ebbinghaus curve // 0인 경우 새 단어장
    @objc private dynamic var e_Date: Date = Date() // Ebbinghaus curve
    @objc private dynamic var tag: Int = 0
    @objc private dynamic var learningCount: Int = 0
    @objc private dynamic var learningTime: Int = 0
    @objc private dynamic var wordCount: Int = 0
    @objc private dynamic var notification: Bool = true
    private let wordList = List<String>()
    private let meanList = List<String>()
    
    func setNum(num: Int) {
        self.num = num
    }
    func getNum() -> Int {
        return num
    }
    func setTitle(title: String) {
        self.title = title
    }
    func getTitle() -> String {
        return title
    }
    func setIsEnable(isEnable: Bool) {
        self.isEnable = isEnable
    }
    func getIsEnable() -> Bool {
        return isEnable
    }
    func setCreateDate(uploadDate: Date) {
        self.createDate = uploadDate
    }
    func getCreateDate() -> Date {
        return createDate
    }
    func setLanguage(language: String) {
        self.language = language
    }
    func getLanguage() -> String {
        return language
    }
    func setE_Status(e_Status: Int) {
        self.e_Status = e_Status
    }
    func getE_Status() -> Int {
        return e_Status
    }
    func setE_Date(e_Date: Date) {
        self.e_Date = e_Date
    }
    func getE_Date() -> Date {
        return e_Date
    }
    func setTag(tag: Int) {
        self.tag = tag
    }
    func getTag() -> Int {
        return tag
    }
    func setLearningCount(learningCount: Int) {
        self.learningCount = learningCount
    }
    func getLearningCount() -> Int {
        return learningCount
    }
    func setLearningTime(learningTime: Int) {
        self.learningTime = learningTime
    }
    func getLearningTime() -> Int {
        return learningTime
    }
    func setWordCount(wordCount: Int) {
        self.wordCount = wordCount
    }
    func getWordCount() -> Int {
        return wordCount
    }
    func setNotification(notification: Bool) {
        self.notification = notification
    }
    func getNotification() -> Bool {
        return notification
    }
    
    // Method Of (word & mean List)
    func addWordMean(word: String, mean: String) {
        wordList.append(word)
        meanList.append(mean)
    }
    func setWordList(words: [String]) {
        wordList.removeAll()
        for i in 0..<wordCount {
            wordList.append(words[i])
        }
    }
    func setMeanList(means: [String]) {
        meanList.removeAll()
        for i in 0..<wordCount {
            meanList.append(means[i])
        }
    }
    func getWordList() -> List<String> {
        return wordList
    }
    func getMeanList() -> List<String> {
        return meanList
    }
}


class VocaTableData: Object {
    let vocaList = List<Voca>()
    
    func addVoca(voca: Voca) {
        vocaList.append(voca)
    }
    
    func getVocaList() -> List<Voca> {
        return vocaList
    }
    
    func getVocaCount() -> Int {
        return vocaList.count
    }
}


class DailyExp: Object{
    @objc dynamic var date: Int = 0
    @objc dynamic var exp: Int = 0
    
    func setDate(date: Int){
        self.date = date
    }
    func getDate() -> Int {
        return date
    }
    func setExp(exp: Int){
        self.exp = exp
    }
    func getExp() -> Int {
        return exp
    }
}


class TodayLearningTime: Object {
    @objc dynamic var date: Int = 0
    @objc dynamic var learningTime: Int = 0
    
    func setDate(date: Int){
        self.date = date
    }
    func getDate() -> Int {
        return date
    }
    func setLearningTime(learningTime: Int){
        self.learningTime = learningTime
    }
    func getLearningTime() -> Int {
        return learningTime
    }
}

class App: Object {
    @objc private dynamic var version: Float = 1.0
    @objc private dynamic var isFirstLaunch: Bool = true
    
    func setIsFirstLaunch(isFirstLaunch: Bool) {
        self.isFirstLaunch = isFirstLaunch
    }
    
    func getIsFirstLaunch() -> Bool {
        return isFirstLaunch
    }
    
    func getVersion() -> Float {
        return version
    }
}


class User: Object {
    @objc private dynamic var email: String = ""
    @objc private dynamic var name: String = ""
    @objc private dynamic var profileImage: Data = (UIImage(named: "AppIcon")!.pngData()!)
    @objc private dynamic var offerEnterprise: String = ""
    @objc private dynamic var tutorial1: Bool = true
    @objc private dynamic var tutorial2: Bool = true
    @objc private dynamic var joinDate: Date = Date()
    @objc private dynamic var slotCount: Int = 10
    @objc private dynamic var vocaCount: Int = 5
    @objc private dynamic var totalWordCount: Int = 60
    @objc private dynamic var totalExp: Int = 0
    @objc private dynamic var totalLearningTime: Int = 0
    @objc private dynamic var todayLearningTime: TodayLearningTime! = TodayLearningTime()
    // last- 단어장 생성시 마지막으로 선택했던 옵션
    @objc private dynamic var lastTag: Int = 1
    @objc private dynamic var lastLanguage: String = "Select".localized
    @objc private dynamic var lastWordCount: String = "20"
    @objc private dynamic var lastVocaShowType: Int = 1 // [ 0: .left(단어만 보기), 1: .cener(모두 보기), 2: .right(뜻만 보기) ]
    @objc private dynamic var userTTSLanguage: String = "English (United States)"
    let dailyExps: List<DailyExp> = List<DailyExp>()

    func setEmail(email: String) {
        self.email = email
    }
    func getEmail() -> String {
        return email
    }
    func setName(name: String) {
        self.name = name
    }
    func getName() -> String {
        return name
    }
    func setOfferEnterprise(offerEnterprise: String) {
        self.offerEnterprise = offerEnterprise
    }
    func getOfferEnterprise() -> String {
        return offerEnterprise
    }
    func setProfileImage(profileImage: Data) {
        self.profileImage = profileImage
    }
    func getprofileImage() -> Data {
        return profileImage
    }
    func setTutorial1(tutorial1: Bool) {
        self.tutorial1 = tutorial1
    }
    func getTutorial1() -> Bool {
        return tutorial1
    }
    func setTutorial2(tutorial2: Bool) {
        self.tutorial2 = tutorial2
    }
    func getTutorial2() -> Bool {
        return tutorial2
    }
    func setJoinDate(joinDate: Date) {
        self.joinDate = joinDate
    }
    func getJoinDate() -> Date {
        return joinDate
    }
    func setVocaCount(vocaCount: Int) {
        self.vocaCount = vocaCount
    }
    func getVocaCount() -> Int {
        return vocaCount
    }
    func setSlotCount(slotCount: Int) {
        self.slotCount = slotCount
    }
    func getSlotCount() -> Int {
        return slotCount
    }
    func setTotalWordCount(totalWordCount: Int) {
        self.totalWordCount = totalWordCount
    }
    func getTotalWordCount() -> Int {
        return totalWordCount
    }
    func setTotalExp(totalExp: Int) {
        self.totalExp = totalExp
    }
    func getTotalExp() -> Int {
        return totalExp
    }
    func setTotalLearningTime(totalLearningTime: Int) {
        self.totalLearningTime = totalLearningTime
    }
    func getTotalLearningTime() -> Int {
        return totalLearningTime
    }
    func addTodayLearningTime(learningTime: Int) {
        initTodayLearningTime()
        todayLearningTime.setLearningTime(learningTime: todayLearningTime.getLearningTime() + learningTime)
        totalLearningTime += learningTime
    }
    func getTodayLearningTime() -> Int {
        initTodayLearningTime()
        return todayLearningTime.getLearningTime()
    }
    func initTodayLearningTime() {
        let todayDate_I: Int = DateConverter().DtoI(date: Date()) // 2019년 7월 3일 인 경우 => 20190703
        if(!(todayDate_I == todayLearningTime.getDate())) { // 저장되어 있는 마지막 날이 다른 날인 경우.
            todayLearningTime.setDate(date: todayDate_I) // 날짜를 오늘로 설정.
            todayLearningTime.setLearningTime(learningTime: 0) // 시간을 0으로 설정.
        }
    }
    func setLastTag(lastTag: Int) {
        self.lastTag = lastTag
    }
    func getLastTag() -> Int {
        return lastTag
    }
    func setLastLanguage(lastLanguage: String) {
        self.lastLanguage = lastLanguage
    }
    func getLastLanguage() -> String {
        return lastLanguage
    }
    func setLastWordCount(lastWordCount: String) {
        self.lastWordCount = lastWordCount
    }
    func getLastWordCount() -> String {
        return lastWordCount
    }
    func setLastVocaShowType(lastVocaShowType: Int) {
        self.lastVocaShowType = lastVocaShowType
    }
    func getLastVocaShowType() -> Int {
        return lastVocaShowType
    }
    func setUserTTSLanguage(userTTSLanguage: String) {
        self.userTTSLanguage = userTTSLanguage
    }
    func getUserTTSLanguage() -> String {
        return userTTSLanguage
    }
    
    func addExp(todayExp: Int) {
        let dc: DateConverter = DateConverter()
        let todayInt = dc.DtoI(date: Date())

        if(!dailyExps.isEmpty) {
            // 오늘의 데이터가 이미 있다면
            if(dailyExps.last!.getDate() == todayInt) {
                dailyExps.last!.setExp(exp: dailyExps.last!.getExp() + todayExp)
            } else { // 없다면 새로 추가
                let dailyExp = DailyExp()
                dailyExp.setDate(date: todayInt)
                dailyExp.setExp(exp: todayExp)
                dailyExps.append(dailyExp)
            }
        } else {
            let dailyExp = DailyExp()
            dailyExp.setDate(date: todayInt)
            dailyExp.setExp(exp: todayExp)
            dailyExps.append(dailyExp)
        } // 위 코드의 중복 해결 방법이 있을 듯 옵셔널 바인딩과 조건문을 한번에 하는 방법?
        
        totalExp += todayExp
    }
    
    // 24시간은 86400초, Date()에서 연산 후 getExp()
    func getRecent7DaysExp(date: Date) -> Array<Int> {
        var exps = [ 0, 0, 0, 0, 0, 0, 0 ]
        var dateAndExp = [ 0, 0, 0, 0, 0, 0, 0]
        for i in 0..<exps.count {
            let day = 86400 * i
            let cursorDate = (date - Double(day))
            let cursorInt = DateConverter().DtoI(date: cursorDate)
            exps[i] = getExpFor(dateInt: cursorInt) // 20190523인 경우, cursorInt => [20190523, 20190522, 20190521, 20190520, 20190519]
            dateAndExp[i] = cursorInt
        }
        dateAndExp.append(contentsOf: exps)
        return dateAndExp
    }
    
    func getExpFor(dateInt: Int) -> Int {
        for i in (0..<dailyExps.count).reversed() {
            let tempDate = dailyExps[i].getDate()
            if(tempDate == dateInt) {
                return dailyExps[i].getExp()
            } else if(tempDate < dateInt) {
                break
            }
        }
        return 0
    }
}

class Setting: Object {
    @objc dynamic var ebbinghaus: Bool = true
    @objc dynamic var beLeftUndoneAlert: Bool = true
    @objc dynamic var beLeftUndoneAlertTime: Int = 10
    @objc dynamic var tts: Bool = true
    @objc dynamic var shortAnswer: Bool = false
    @objc dynamic var ttsSpeed: Float = 0.4
    
    func setEbbinghaus(ebbinghaus: Bool) {
        self.ebbinghaus = ebbinghaus
    }
    func getEbbinghaus() -> Bool {
        return ebbinghaus
    }
    func setBeLeftUndoneAlert(beLeftUndoneAlert: Bool) {
        self.beLeftUndoneAlert = beLeftUndoneAlert
    }
    func getBeLeftUndoneAlert() -> Bool {
        return beLeftUndoneAlert
    }
    func setBeLeftUndoneAlertTime(beLeftUndoneAlertTime: Int) {
        self.beLeftUndoneAlertTime = beLeftUndoneAlertTime
    }
    func getBeLeftUndoneAlertTime() -> Int {
        return beLeftUndoneAlertTime
    }
    func setTTS(tts: Bool) {
        self.tts = tts
    }
    func getTTS() -> Bool {
        return tts
    }
    func setShortAnswer(shortAnswer: Bool) {
        self.shortAnswer = shortAnswer
    }
    func getShortAnswer() -> Bool {
        return shortAnswer
    }
    func setTTSSpeed(ttsSpeed: Float) {
        self.ttsSpeed = ttsSpeed
    }
    func getTTSSpeed() -> Float {
        return ttsSpeed
    }
}


class VocaCount: Object {
    @objc dynamic var count: Int = -1
    func getCount() -> Int {
        return count
    }
    func addCount() {
        count += 1
    }
}


class DictionaryList: Object {
    private let dictionaryList1 = List<Dictionary>()
    private let dictionaryList2 = List<Dictionary>()
    
    func getDictionary(languageNum: Int, dictionaryNum: Int) -> Dictionary {
        switch dictionaryNum {
        case 0:
            return dictionaryList1[languageNum]
        case 1:
            return dictionaryList2[languageNum]
        default:
            return Dictionary()
        }
    }
    
    func replaceDictionary(languageNum: Int, dictionaryNum: Int, dictionary: Dictionary) {
        switch dictionaryNum {
        case 0:
            dictionaryList1.replace(index: languageNum, object: dictionary)
        case 1:
            dictionaryList2.replace(index: languageNum, object: dictionary)
        default:
            break
        }
    }
    
    func initDict() {
        for _ in 0..<36 {
            let dict1 = Dictionary()
            dict1.setTitle(title: "Dictionary1")
            dictionaryList1.append(dict1)
            
            let dict2 = Dictionary()
            dict2.setTitle(title: "Dictionary2")
            dictionaryList2.append(dict2)
        }
        
        let globalDict1 = Dictionary()
        globalDict1.setTitle(title: "Global dict".localized + String(1))
        dictionaryList1.append(globalDict1)
        
        let globalDict2 = Dictionary()
        globalDict2.setTitle(title: "Global dict".localized + String(2))
        dictionaryList2.append(globalDict2)
    }
}

class Dictionary: Object {
    @objc dynamic var isEnable: Bool = false
    @objc dynamic var title: String = ""
    @objc dynamic var prefix: String = ""
    @objc dynamic var suffix: String = ""
    
    
    func setIsEnable(isEnable: Bool) {
        self.isEnable = isEnable
    }
    func getIsEnable() -> Bool {
        return isEnable
    }
    func setTitle(title: String) {
        self.title = title
    }
    func getTitle() -> String {
        return title
    }
    func setPrefix(prefix: String) {
        self.prefix = prefix
    }
    func getPrefix() -> String {
        return prefix
    }
    func setSuffix(suffix: String) {
        self.suffix = suffix
    }
    func getSuffix() -> String {
        return suffix
    }
}
