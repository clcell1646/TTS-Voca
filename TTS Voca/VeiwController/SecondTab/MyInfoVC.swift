//
//  MyInfoVC.swift
//  TTS Voca
//
//  Created by 정지환 on 23/05/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import UIKit

class MyInfoVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var myInfoTable: UITableView!
    let userDB: UserDB = UserDB.getInstance
    let timeConverter: TimeConverter = TimeConverter()
    let type: [String] = [ "My voca".localized + " / " + "Slot count".localized, "Word count".localized, "Total exp".localized, "Total learning time".localized, "Today's learning time".localized ]
    var data: [String]!
    
    let palette = TagPalette()
    
//    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myInfoTable.dataSource = self
        myInfoTable.delegate = self
        myInfoTable.backgroundColor = UIColor.white
        myInfoTable.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 10, right: 0)
//        myInfoTable.backgroundColor = UIColor.groupTableViewBackground
        
        self.navigationItem.title = "My Info".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setData()
    }
    
    func setData() {
        data = [String]() // 초기화
        data.append("\(userDB.getVocaCount()) / \(userDB.getSlotCount())" + " slots".localized)
        data.append("\(userDB.getTotalWordCount())" + " words".localized)
        data.append("\(userDB.getTotalExp())exp")
        data.append(timeConverter.ItoS(learningTime: userDB.getTotalLearningTime()))
        data.append(timeConverter.ItoS(learningTime: userDB.getTodayLearningTime()))
        myInfoTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(userDB.isLoggedin()) {
            return 7
        } else {
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(userDB.isLoggedin()) {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
                cell.loadData(imageData: userDB.getProfileData(), name: userDB.getName())
                return cell
            case 6:
                let cell = myInfoTable.dequeueReusableCell(withIdentifier: "MyInfoTableGraphCell", for: indexPath) as! MyInfoTableGraphCell
                cell.initUI()
                cell.setData(recent7daysExp: userDB.getRecent7DaysExp(date: Date()))
                return cell
            default:
                let cell = myInfoTable.dequeueReusableCell(withIdentifier: "MyInfoTableNormalCell", for: indexPath) as! MyInfoTableNormalCell
                cell.setData(type: type[indexPath.row - 1], data: data[indexPath.row - 1], tagColor: palette.getTagColor(tag: indexPath.row))
                return cell
            }
        } else {
            switch indexPath.row {
            case 5:
                let cell = myInfoTable.dequeueReusableCell(withIdentifier: "MyInfoTableGraphCell", for: indexPath) as! MyInfoTableGraphCell
                cell.initUI()
                cell.setData(recent7daysExp: userDB.getRecent7DaysExp(date: Date()))
                return cell
            default:
                let cell = myInfoTable.dequeueReusableCell(withIdentifier: "MyInfoTableNormalCell", for: indexPath) as! MyInfoTableNormalCell
                cell.setData(type: type[indexPath.row], data: data[indexPath.row], tagColor: palette.getTagColor(tag: indexPath.row + 1))
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(userDB.isLoggedin()) {
            switch indexPath.row {
            case 0:
                return 80
            case 6:
                return 410
            default:
                return 50
            }
        } else {
            switch indexPath.row {
            case 5:
                return 410
            default:
                return 50
            }
        }
    }
}

class AccountCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func loadData(imageData: Data, name: String) {
        profileImageView.image = UIImage(data: imageData)
        nameLabel.text = name
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
}


class MyInfoTableGraphCell: UITableViewCell {
    @IBOutlet weak var graphCellTitle: UILabel!
    
    @IBOutlet weak var viewForWidth: UIView!
    @IBOutlet weak var leadingBean: UIView!
    
    @IBOutlet weak var dateLabel1: UILabel!
    @IBOutlet weak var dateLabel2: UILabel!
    @IBOutlet weak var dateLabel3: UILabel!
    @IBOutlet weak var dateLabel4: UILabel!
    @IBOutlet weak var dateLabel5: UILabel!
    @IBOutlet weak var dateLabel6: UILabel!
    @IBOutlet weak var dateLabel7: UILabel!
    @IBOutlet weak var expBar1: UIView!
    @IBOutlet weak var expBar2: UIView!
    @IBOutlet weak var expBar3: UIView!
    @IBOutlet weak var expBar4: UIView!
    @IBOutlet weak var expBar5: UIView!
    @IBOutlet weak var expBar6: UIView!
    @IBOutlet weak var expBar7: UIView!
    @IBOutlet weak var expBar1_width: NSLayoutConstraint!
    @IBOutlet weak var expBar2_width: NSLayoutConstraint!
    @IBOutlet weak var expBar3_width: NSLayoutConstraint!
    @IBOutlet weak var expBar4_width: NSLayoutConstraint!
    @IBOutlet weak var expBar5_width: NSLayoutConstraint!
    @IBOutlet weak var expBar6_width: NSLayoutConstraint!
    @IBOutlet weak var expBar7_width: NSLayoutConstraint!
    @IBOutlet weak var expLabel1: UILabel!
    @IBOutlet weak var expLabel2: UILabel!
    @IBOutlet weak var expLabel3: UILabel!
    @IBOutlet weak var expLabel4: UILabel!
    @IBOutlet weak var expLabel5: UILabel!
    @IBOutlet weak var expLabel6: UILabel!
    @IBOutlet weak var expLabel7: UILabel!
    @IBOutlet weak var emptyLabel1: UILabel!
    @IBOutlet weak var emptyLabel2: UILabel!
    @IBOutlet weak var emptyLabel3: UILabel!
    @IBOutlet weak var emptyLabel4: UILabel!
    @IBOutlet weak var emptyLabel5: UILabel!
    @IBOutlet weak var emptyLabel6: UILabel!
    @IBOutlet weak var emptyLabel7: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    
    let sl = SpecialLocalizer()
    
    func setData(recent7daysExp: [Int]) {
        graphCellTitle.text = "Last 7 days learning history".localized;
        
        var date_S: [Int] = [Int]() // date_S[0]: 20190101 => 1월 1일
        var exp: [Int] = [Int]() // exp는 그냥 표시
        for i in 0..<7 {
            date_S.append(recent7daysExp[i] % 10000)
            exp.append(recent7daysExp[i + 7])
        }
        
        var month: [Int] = [Int]()
        var day: [Int] = [Int]()
        
        for d in date_S {
            month.append(d / 100)
            day.append(d % 100)
        }
        
        dateLabel1.text = sl.getSimpleDateFor7days(month: month[6], day: day[6])
        dateLabel2.text = sl.getSimpleDateFor7days(month: month[5], day: day[5])
        dateLabel3.text = sl.getSimpleDateFor7days(month: month[4], day: day[4])
        dateLabel4.text = sl.getSimpleDateFor7days(month: month[3], day: day[3])
        dateLabel5.text = sl.getSimpleDateFor7days(month: month[2], day: day[2])
        dateLabel6.text = sl.getSimpleDateFor7days(month: month[1], day: day[1])
        dateLabel7.text = sl.getSimpleDateFor7days(month: month[0], day: day[0])

        expLabel1.text = String(exp[6])
        expLabel2.text = String(exp[5])
        expLabel3.text = String(exp[4])
        expLabel4.text = String(exp[3])
        expLabel5.text = String(exp[2])
        expLabel6.text = String(exp[1])
        expLabel7.text = String(exp[0])

        
        let barWidth: [CGFloat] = getBarWidth(exp: exp)
        expBar1_width.constant = barWidth[6]
        expBar2_width.constant = barWidth[5]
        expBar3_width.constant = barWidth[4]
        expBar4_width.constant = barWidth[3]
        expBar5_width.constant = barWidth[2]
        expBar6_width.constant = barWidth[1]
        expBar7_width.constant = barWidth[0]
        
        if(exp[6] == 0) {
            emptyLabel1.isHidden = false
            expLabel1.isHidden = true
        } else {
            emptyLabel1.isHidden = true
            expLabel1.isHidden = false
        }
        if(exp[5] == 0) {
            emptyLabel2.isHidden = false
            expLabel2.isHidden = true
        } else {
            emptyLabel2.isHidden = true
            expLabel2.isHidden = false
        }
        if(exp[4] == 0) {
            emptyLabel3.isHidden = false
            expLabel3.isHidden = true
        } else {
            emptyLabel3.isHidden = true
            expLabel3.isHidden = false
        }
        if(exp[3] == 0) {
            emptyLabel4.isHidden = false
            expLabel4.isHidden = true
        } else {
            emptyLabel4.isHidden = true
            expLabel4.isHidden = false
        }
        if(exp[2] == 0) {
            emptyLabel5.isHidden = false
            expLabel5.isHidden = true
        } else {
            emptyLabel5.isHidden = true
            expLabel5.isHidden = false
        }
        if(exp[1] == 0) {
            emptyLabel6.isHidden = false
            expLabel6.isHidden = true
        } else {
            emptyLabel6.isHidden = true
            expLabel6.isHidden = false
        }
        if(exp[0] == 0) {
            emptyLabel7.isHidden = false
            expLabel7.isHidden = true
        } else {
            emptyLabel7.isHidden = true
            expLabel7.isHidden = false
        }
        
        
        unitLabel.text = "Unit".localized + ": (exp)"
        emptyLabel1.text = "no data".localized
        emptyLabel2.text = "no data".localized
        emptyLabel3.text = "no data".localized
        emptyLabel4.text = "no data".localized
        emptyLabel5.text = "no data".localized
        emptyLabel6.text = "no data".localized
        emptyLabel7.text = "no data".localized
    }
    
    func getBarWidth(exp: [Int]) -> [CGFloat] {
        let longestBarWidth = viewForWidth.bounds.width - 20
        
        var largestExp: Int = exp[0]
        for i in 1..<7 {
            if(largestExp < exp[i]) {
                largestExp = exp[i]
            }
        }
        
        var barWidthRatio: [CGFloat] = [CGFloat]()
        for e in exp {
            var ratio: CGFloat = CGFloat(e) / CGFloat(largestExp)
            if(ratio.isNaN) {
                ratio = 0
            }
            barWidthRatio.append(ratio)
        }
        
        var barWidth: [CGFloat] = [CGFloat]()
        for ratio in barWidthRatio {
            barWidth.append(longestBarWidth * ratio)
        }
        
        return barWidth
    }
    
    func initUI() {
        setExpBarDesign(expBar: expBar1)
        setExpBarDesign(expBar: expBar2)
        setExpBarDesign(expBar: expBar3)
        setExpBarDesign(expBar: expBar4)
        setExpBarDesign(expBar: expBar5)
        setExpBarDesign(expBar: expBar6)
        setExpBarDesign(expBar: expBar7)
        
        cardView.backgroundColor = .white
        leadingBean.layer.cornerRadius = 5
    }
    
    func setExpBarDesign(expBar: UIView) {
        // set bar corner radius
        let layer = expBar.layer
        layer.cornerRadius = 4
    }
}


class MyInfoTableNormalCell: UITableViewCell {
    @IBOutlet weak var leadingBean: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    func setData(type: String, data: String, tagColor: UIColor) {
        typeLabel.text = type
        dataLabel.text = data
        leadingBean.layer.cornerRadius = 5
        leadingBean.backgroundColor = tagColor
    }
}

