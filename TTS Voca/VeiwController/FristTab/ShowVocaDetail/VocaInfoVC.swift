//
//  VocaInfoVC.swift
//  TTS Voca
//
//  Created by 정지환 on 10/06/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import UIKit


class VocaInfoVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let sl = SpecialLocalizer()
    var delegate: StopArrowTimerDelegate!
    var barButtonItemDelegate: BarButtonItemDelegate!
    
    @IBOutlet weak var infoTable: UITableView!
    let palette: TagPalette = TagPalette()
    var voca: Voca!
    let type: [String] = [ "Creation date".localized,
                           "Language".localized,
                           "Word count".localized,
                           "Total learnings".localized,
                           "Total learning time".localized,
                           "Due date".localized,
                           "Ebbinghaus level".localized ]
    var data: [String]!
    
    var tagColor: UIColor!
    
    override func viewDidAppear(_ animated: Bool) {
        delegate.stopArrowTimer()
        barButtonItemDelegate.addShareBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setData()
        infoTable.reloadData()
    }
    
    override func viewDidLoad() {
        infoTable.dataSource = self
        infoTable.delegate = self
        infoTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 25.0, right: 0)
        tagColor = palette.getTagColor(tag: voca.getTag())
        initUI()
        setData()
    }
    
    func setData() {
        // data 초기화
        data = [String]()
        
        // 생성 일자
        let dc: DateConverter = DateConverter()
        let data1 = dc.DtoS_global(date: voca.getCreateDate())
//        let data1 = dc.DtoS_create(date: voca.getCreateDate())
        data.append(data1)
        
        // 언어
        let lang = voca.getLanguage()
        data.append(lang)
        
        // 단어 개수
        let wordCount = voca.getWordCount()
        data.append("\(String(wordCount))" + " words".localized)
        
        // 총 학습 횟수
        var data2 = ""
        data2.append(String(voca.getLearningCount()))
        data2.append(" times".localized)
        data.append(data2)
        
        // 총 학습 시간
        let timeConverter = TimeConverter()
        let data3 = timeConverter.ItoS(learningTime: voca.getLearningTime())
        data.append(data3)
        
        // 학습 예정일
        let e_Status: Int = voca.getE_Status()
        let e_Date: Date = voca.getE_Date()
        if(e_Status == 0) {
            data.append("Undecided".localized)
        } else {
            data.append(dc.DtoS_dueDate(date: e_Date))
//            data.append(dc.DtoS_learn(date: e_Date))
        }
        
        // 에빙하우스 단계
        let data5: Int = voca.getE_Status()
        var data5_S: String = ""
        switch data5 {
        case 0:
            data5_S = "Unlearned".localized
            break
        case 1:
            data5_S = sl.localize(string: "Level 1")
            break
        case 2:
            data5_S = sl.localize(string: "Level 2")
            break
        case 3:
            data5_S = sl.localize(string: "Level 3")
            break
        case 4:
            data5_S = sl.localize(string: "Level 4")
            break
        default:
            data5_S = sl.localize(string: "Level 5")
            break
        }
        data.append(data5_S)
    }
    
    func initUI() {
        infoTable.rowHeight = 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0) {
            return 0
        } else if(section == 1) {
            return 0
        } else {
            return 10
        }
    }
    
    // For Background Color
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: UIView = UIView()
        return header
    }
    
    // [ 생성 일자, 총 학습 횟수, 총 학습 시간, 에빙하우스 단계, 다음 에빙하우스 학습 일자 ]
    func numberOfSections(in tableView: UITableView) -> Int {
        return type.count + 2 // Type-Data Cell + Info cell + Switch Cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        case 0: // 첫번째 셀
            let cell: InfoCell = infoTable.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
            cell.setColor(color: tagColor)
            return cell
        case 1: // 두번째 셀
            let cell: EbbinghausSwitchCell = infoTable.dequeueReusableCell(withIdentifier: "EbbinghausSwitchCell", for: indexPath) as! EbbinghausSwitchCell
            cell.setData(voca: voca, borderColor: tagColor)
            return cell
        default:
            let cell: InfoTableCell = infoTable.dequeueReusableCell(withIdentifier: "InfoTableCell", for: indexPath) as! InfoTableCell
            cell.setData(type: type[section - 2], data: data[section - 2], borderColor: tagColor)
            if(type[section - 2] == "Due date".localized && voca.getE_Status() != 0 && voca.getE_Date() < Date()) { // 학습 예정일 셀, 미학습이 아닌 경우, 이미 지났을 때
                cell.setTextColorRed() // 학습 예정일이 지났으면 글자 색이 red가 된다.
            }
            return cell
        }
    }
}


class InfoTableCell: UITableViewCell {
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    func setData(type: String, data: String, borderColor: UIColor) {
        typeLabel.text = type
        dataLabel.text = data

        card.layer.cornerRadius = 4
        card.layer.borderWidth = 2
        card.layer.borderColor = borderColor.cgColor
    }
    
    func setTextColorRed() {
        dataLabel.textColor = .red
    }
}


class InfoCell: UITableViewCell {
    @IBOutlet weak var infoLabel: UILabel!
    func setColor(color: UIColor) {
        infoLabel.textColor = color
    }
}


class EbbinghausSwitchCell: UITableViewCell {
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var ebbinghausSwitch: UISwitch!
    @IBOutlet weak var card: UIView!
    
    var voca: Voca!
    
    func setData(voca: Voca, borderColor: UIColor) {
        self.voca = voca
        ebbinghausSwitch.isOn = voca.getNotification()
        ebbinghausSwitch.tintColor = borderColor
        ebbinghausSwitch.onTintColor = borderColor
        card.layer.cornerRadius = 4
        card.layer.borderWidth = 2
        card.layer.borderColor = borderColor.cgColor
        
        notificationLabel.text = "Notification".localized
    }
    
    @IBAction func ebbinghausSwitchChanged(_ sender: UISwitch) {
        VocaDB.getInstance.setNotification(voca: voca, notification: ebbinghausSwitch.isOn)
    }
}
