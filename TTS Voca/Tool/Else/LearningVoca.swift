//
//  LearningVoca.swift
//  TTS Voca
//
//  Created by 정지환 on 15/06/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//


class LearningVoca {
    private let settingDB: SettingDB = SettingDB.getInstance
    private let userDB: UserDB = UserDB.getInstance
    
    private var voca: Voca
    private var stageCount: Int
    private var roadMap: [WordData] = [WordData]()
    
    init(voca: Voca) {
        self.voca = voca
        let wordCount = voca.getWordCount()
        
        if(settingDB.getShortAnswer()) {
            stageCount = wordCount * 3
        } else {
            stageCount = wordCount * 2
        }
        
        let words: [String] = Array(voca.getWordList())
        let means: [String] = Array(voca.getMeanList())
        
        // data1의 단어를 20개로 맞춘다. 모자라는 단어는 더미를 넣는다.
        var data1: [WordData] = [WordData]()
        
        for i in (0..<20) {
            if(i < wordCount) {
                data1.append(WordData(type: 0, word: words[i], mean: means[i]))
            } else {
                data1.append(WordData(type: -1, word: "", mean: ""))
            }
        }
        // data1의 단어를 4개 단위로 자른다.
        var bundle1: [WordData] = [WordData]()
        var bundle2: [WordData] = [WordData]()
        var bundle3: [WordData] = [WordData]()
        var bundle4: [WordData] = [WordData]()
        var bundle5: [WordData] = [WordData]()
        
        for i in (0..<20) {
            switch (i/4) {
            case 0:
                bundle1.append(data1[i])
                break
            case 1:
                bundle2.append(data1[i])
                break
            case 2:
                bundle3.append(data1[i])
                break
            case 3:
                bundle4.append(data1[i])
                break
            case 4:
                bundle5.append(data1[i])
                break
            default:
                break
            }
        }
        
        var data2: [WordData] = [WordData]()
        let isFirstLearn: Bool = (voca.getLearningCount() == 0)
        
        if(isFirstLearn) {
            for w in getProperBundle(bundle: bundle1, type: 0) {
                data2.append(WordData(type: w.getType(), word: w.getWord(), mean: w.getMean()))
            }
        }
        for w in getProperBundle(bundle: bundle1, type: 1) {
            data2.append(WordData(type: w.getType(), word: w.getWord(), mean: w.getMean()))
        }
        
        if(isFirstLearn) {
            for w in getProperBundle(bundle: bundle2, type: 0) {
                data2.append(WordData(type: w.getType(), word: w.getWord(), mean: w.getMean()))
            }
        }
        for w in getProperBundle(bundle: bundle2, type: 1) {
            data2.append(WordData(type: w.getType(), word: w.getWord(), mean: w.getMean()))
        }
        for w in getProperBundle(bundle: bundle1, type: 2) {
            data2.append(WordData(type: w.getType(), word: w.getWord(), mean: w.getMean()))
        }
        for w in getProperBundle(bundle: bundle2, type: 2) {
            data2.append(WordData(type: w.getType(), word: w.getWord(), mean: w.getMean()))
        }
        
        if(isFirstLearn) {
            for w in getProperBundle(bundle: bundle3, type: 0) {
                data2.append(WordData(type: w.getType(), word: w.getWord(), mean: w.getMean()))
            }
        }
        for w in getProperBundle(bundle: bundle3, type: 1) {
            data2.append(WordData(type: w.getType(), word: w.getWord(), mean: w.getMean()))
        }
        
        if(isFirstLearn) {
            for w in getProperBundle(bundle: bundle4, type: 0) {
                data2.append(WordData(type: w.getType(), word: w.getWord(), mean: w.getMean()))
            }
        }
        for w in getProperBundle(bundle: bundle4, type: 1) {
            data2.append(WordData(type: w.getType(), word: w.getWord(), mean: w.getMean()))
        }
        
        if(settingDB.getShortAnswer()) {
            for w in getProperBundle(bundle: bundle1, type: 3) {
                data2.append(WordData(type: w.getType(), word: w.getWord(), mean: w.getMean()))
            }
            for w in getProperBundle(bundle: bundle2, type: 3) {
                data2.append(WordData(type: w.getType(), word: w.getWord(), mean: w.getMean()))
            }
        }
        
        for w in getProperBundle(bundle: bundle3, type: 2) {
            data2.append(WordData(type: w.getType(), word: w.getWord(), mean: w.getMean()))
        }
        
        if(isFirstLearn) {
            for w in getProperBundle(bundle: bundle5, type: 0) {
                data2.append(WordData(type: w.getType(), word: w.getWord(), mean: w.getMean()))
            }
        }
        for w in getProperBundle(bundle: bundle5, type: 1) {
            data2.append(WordData(type: w.getType(), word: w.getWord(), mean: w.getMean()))
        }
        for w in getProperBundle(bundle: bundle4, type: 2) {
            data2.append(WordData(type: w.getType(), word: w.getWord(), mean: w.getMean()))
        }
        for w in getProperBundle(bundle: bundle5, type: 2) {
            data2.append(WordData(type: w.getType(), word: w.getWord(), mean: w.getMean()))
        }
        
        if(settingDB.getShortAnswer()) {
            for w in getProperBundle(bundle: bundle3, type: 3) {
                data2.append(WordData(type: w.getType(), word: w.getWord(), mean: w.getMean()))
            }
            for w in getProperBundle(bundle: bundle4, type: 3) {
                data2.append(WordData(type: w.getType(), word: w.getWord(), mean: w.getMean()))
            }
            for w in getProperBundle(bundle: bundle5, type: 3) {
                data2.append(WordData(type: w.getType(), word: w.getWord(), mean: w.getMean()))
            }
        }
        roadMap = data2
    }
    
    func currentPass() {
        // 여기서 first 단어와 같은 단어가 있으면 4칸 뒤로 미룬다.
        let wordData = roadMap.first!
        roadMap.removeFirst()
        
        for i in 0..<4 {
            if(i >= roadMap.count) {
                break
            }
            if(roadMap[i].getWord() == wordData.getWord()) {
                if(roadMap.count > 4) {
                    roadMap.insert(roadMap[i], at: 4)
                    roadMap.remove(at: i)
                } else {
                    roadMap.append(roadMap[i])
                    roadMap.remove(at: i)
                }
            }
        }
    }
    
    func currentFail() {
        if(roadMap.count > 4) {
            var tempMap: [WordData] = roadMap
            let n: Int = tempMap.count
            
            tempMap.append(roadMap[1])
            tempMap.append(roadMap[2])
            tempMap.append(roadMap[3])
            tempMap.append(roadMap[0])
            for i in 4..<roadMap.count {
                tempMap.append(roadMap[i])
            }
            
            for _ in 0..<n {
                tempMap.removeFirst()
            }
            
            roadMap = tempMap
        } else { // 남은 단어가 4개 이하일 때
            roadMap.append(roadMap.first!)
            roadMap.removeFirst()
        }
    }
    
    func addPresentWordStage(wordData: WordData) {
        roadMap.insert(wordData, at: 0)
    }
    
    // 상위 타입의 문제가 먼저 나오지 않도록 해야한다.
    func getNext() -> WordData {
        var firstWord: WordData = roadMap.first!
        let type: Int = firstWord.getType()
        var i: Int = 0
        if(type == 1 || type == 2 || type == 3) { // Type == [ 0, 4, 5, 6, 7 ] 인경우 display view 이므로 그냥 통과
            for word in roadMap {
                if(i == 0) { // 첫번째는 무조건 같으므로 건너뛴다.
                    i += 1
                    continue
                }
//                print("i: \(i)")
                if(word.getWord() == firstWord.getWord()) { // 단어가 같다.
//                    print("단어가 같다.")
                    if(word.getMean() == firstWord.getMean()) { // 뜻이 같다.
//                        print("뜻이 같다.")
                        if(word.getType() < firstWord.getType()) {
//                            print("타입은 더 작은 것이 존재한다.")
                            if(roadMap.count > (i + 5)) {
                                roadMap.insert(firstWord, at: i + 5)
                            } else {
                                roadMap.insert(firstWord, at: roadMap.count)
                            }
                            roadMap.removeFirst()
                            firstWord = roadMap.first!
//                            print("Type이 더 작은게 존재, 뒤로 미룬다.")
                        }
                    }
                }
                i += 1
            }
        }
        return firstWord
    }
    
    func hasNext() -> Bool {
        return !roadMap.isEmpty
    }
    
    private func getProperBundle(bundle: [WordData], type: Int) -> [WordData] {
        var result: [WordData] = [WordData]()
        for wordData in bundle {
            // Not Dummy
            if(wordData.getType() != -1) {
                wordData.setType(type: type)
                result.append(wordData)
            }
        }
        return result
    }
    
    func getStageCount() -> Int {
        return stageCount
    }
    
    private func getRoadMap() -> [WordData] {
        return roadMap
    }
}


class WordData {
    private var type: Int // [ -1: dummy data, 0: Korean Choice, 1: .Language Choice, 2: Short Answer ]
    private let word: String
    private let mean: String
    init(type: Int, word: String, mean: String) {
        self.type = type
        self.word = word
        self.mean = mean
    }
    
    func setType(type: Int) {
        self.type = type
    }
    func getType() -> Int{
        return type
    }
    func getWord() -> String {
        return word
    }
    func getMean() -> String {
        return mean
    }
}

// 외않돼지;;
//        data2.append(contentsOf: getProperBundle(bundle: bundle1, type: 0))
//        data2.append(contentsOf: getProperBundle(bundle: bundle2, type: 0))
//        data2.append(contentsOf: getProperBundle(bundle: bundle1, type: 1))
//        data2.append(contentsOf: getProperBundle(bundle: bundle2, type: 1))
//        data2.append(contentsOf: getProperBundle(bundle: bundle3, type: 0))
//        data2.append(contentsOf: getProperBundle(bundle: bundle4, type: 0))
//        data2.append(contentsOf: getProperBundle(bundle: bundle1, type: 2))
//        data2.append(contentsOf: getProperBundle(bundle: bundle2, type: 2))
//        data2.append(contentsOf: getProperBundle(bundle: bundle3, type: 1))
//        data2.append(contentsOf: getProperBundle(bundle: bundle5, type: 0))
//        data2.append(contentsOf: getProperBundle(bundle: bundle4, type: 1))
//        data2.append(contentsOf: getProperBundle(bundle: bundle5, type: 1))
//        data2.append(contentsOf: getProperBundle(bundle: bundle3, type: 2))
//        data2.append(contentsOf: getProperBundle(bundle: bundle4, type: 2))
//        data2.append(contentsOf: getProperBundle(bundle: bundle5, type: 2))
