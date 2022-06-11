//
//  SettingVC.swift
//  TTS Voca
//
//  Created by 정지환 on 23/05/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import MessageUI

protocol LoginDelegate {
    func loginSuccess()
}


class HighlightItem {
    static let getInstance = HighlightItem()
    var isNecessary: Bool = false
}


class SettingVC: UITableViewController, LoginDelegate {
    
    func loginSuccess() {
        showAccountInfo(bool: true)
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            let accountCellUnderBarInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            self.accountLoginCell.separatorInset = accountCellUnderBarInset
            self.view.layoutIfNeeded()
        }
        
        // 슬롯에 따라 엔에이블.
        VocaListDB.getInstance.setVocaEnableStatusBySlotCount()
    }
    
    func showAccountInfo(bool: Bool) {
        if(bool) {
            loginButton.isHidden = true
            offerEnpImageView.isHidden = false
            emailLabel.isHidden = false
            emailLabel.text = userDB.getEmail()
            offerEnpImageView.image = UIImage(named: userDB.getOfferEnterprise() + "Logo")
        } else {
            loginButton.isHidden = false
            offerEnpImageView.isHidden = true
            emailLabel.isHidden = true
            
        }
    }
    
    // For localization
    @IBOutlet weak var ebbinghausNotificationLabel: UILabel!
    @IBOutlet weak var ebbinghausExplanationLabel: UILabel!
    @IBOutlet weak var beLeftUndoneNotificationLabel: UILabel!
    @IBOutlet weak var bluPickerPrefixLeading: NSLayoutConstraint!
    @IBOutlet weak var bluPickerPrefix: UILabel!
    @IBOutlet weak var bluPickerSuffix: UILabel!
    @IBOutlet weak var bluPickerPrefixWidth: NSLayoutConstraint!
    @IBOutlet weak var bluPickerSuffixWidth: NSLayoutConstraint!
    @IBOutlet weak var ttsLabel: UILabel!
    @IBOutlet weak var ttsSpeedLabel: UILabel!
    @IBOutlet weak var ttsSpeedSlowLabel: UILabel!
    @IBOutlet weak var ttsSpeedMediumLabel: UILabel!
    @IBOutlet weak var ttsSpeedFastLabel: UILabel!
    @IBOutlet weak var nativeLanguageLabel: UILabel!
    @IBOutlet weak var ttsExplanationLabel: UILabel!
    @IBOutlet weak var shortAnswerLabel: UILabel!
    @IBOutlet weak var settingDictLabel: UILabel!
    @IBOutlet weak var haus50ExplanationLabel: UILabel!
    @IBOutlet weak var haus150ExplanationLabel: UILabel!
    @IBOutlet weak var haus50priceButton: UIButton!
    @IBOutlet weak var haus150priceButton: UIButton!
    @IBOutlet weak var sendEmailButton: UIButton!
    
    
    let hausDAO = HausDAO()
    let userDB = UserDB.getInstance
    
    @IBOutlet weak var ebbinghausSwitch: UISwitch!
    @IBOutlet weak var ttsSwitch: UISwitch!
    @IBOutlet weak var ttsSpeedSlider: UISlider!
    @IBOutlet weak var shortAnswerSwitch: UISwitch!
    @IBOutlet weak var turtleImage: UIImageView!
    @IBOutlet weak var rabbitImage: UIImageView!
    @IBOutlet weak var purchaseButton01: UIButton!
    @IBOutlet weak var purchaseButton02: UIButton!
    @IBOutlet weak var beLeftUndoneSwitch: UISwitch!
    @IBOutlet weak var beLeftUndoneSwitchCell: UITableViewCell!
    @IBOutlet weak var beLeftUndoneTimePicker: UIPickerView!
    @IBOutlet weak var beLeftUndoneContentView: UIView!
    @IBOutlet weak var beLeftUndonePickerViewWidth: NSLayoutConstraint!
    @IBOutlet weak var openPickerViewButton: UIButton!
    
    // 계정 로그인
    @IBOutlet weak var accountLoginCell: UITableViewCell!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    let accountIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    let logoutIndexPath: IndexPath = IndexPath(row: 1, section: 0)
    
    @IBOutlet weak var offerEnpImageView: UIImageView! // offering enteprise logo
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var selectUserTTSLanguageView: UIView!
    @IBOutlet weak var userTTSLanguageLabel: UILabel!
    @IBOutlet weak var dictionarySettingView: UIView!
    
    var targetProductIdentifier: String!
    
    // 밀린 단어장 알림 피커뷰 IndexPath
    let beLeftUndoneIndexPath: IndexPath = IndexPath(row: 1, section: 2)
    var pickerViewOpened: Bool = false
    
    // [ Haus 50, Haus 150 ] 아이템 셀
    let hausItemIndexPath = IndexPath(row: 1, section: 6)
    @IBOutlet weak var haus50Cell: UITableViewCell!
    @IBOutlet weak var haus150Cell: UITableViewCell!
    
    let developerEmailIP = IndexPath(row: 0, section: 7)
    
    
    var ttsService: TTSService = TTSService(language: "en-US")
    let settingDB: SettingDB = SettingDB.getInstance
    let pCon: PermissionController = PermissionController()
    
    var headerTitle: [String] = [ "Account".localized,
                                  "Ebbinghaus".localized,
                                  "Notification".localized,
                                  "TTS".localized,
                                  "Short answer questions".localized,
                                  "Dictionary".localized,
                                  "Additional features".localized,
                                  "Contact us".localized ]
    var footerTitle: [String] = [ "", // "슬롯 개수는 계정에 저장됩니다."
                                  "Essential option for maximum learning.".localized,
                                  "After exiting the app, after the time you set, notification the number of voca need to be reviewed.".localized,
                                  "Please turn off the mute mode of your iPhone.".localized,
                                  "During learning, each word will have three levels: multiple choice(native language selection), multiple choice(foreign language selection), and short answer(foreign language input).".localized,
                                  "You can set a dictionary for each language you want to learn.".localized,
                                  "",
                                  "You must have a mail account registered on your iPhone.".localized ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings".localized
        
        beLeftUndoneTimePicker.dataSource = self
        beLeftUndoneTimePicker.delegate = self
        
        let bluTime = settingDB.getBeLeftUndoneAlertTime()
        openPickerViewButton.setTitle(String(bluTime), for: .normal)
        beLeftUndoneTimePicker.selectRow(bluTime - 1, inComponent: 0, animated: false)
        
        ttsSpeedSlider.isContinuous = false // slider 즉각 반응 해제
        ebbinghausSwitch.isOn = settingDB.getEbbinghaus()
        beLeftUndoneSwitch.isOn = settingDB.getBeLeftUndoneAlert()
        ttsSwitch.isOn = settingDB.getTTS()
        ttsSpeedSlider.value = settingDB.getTTSSpeed() * 10
        shortAnswerSwitch.isOn = settingDB.getShortAnswer()
        if(settingDB.getTTS()) {
            ttsSwitchOn(speak: false)
        } else {
            ttsSwitchOff()
        }
        
        beLeftUndoneTimePicker.isUserInteractionEnabled = false
        beLeftUndoneTimePicker.alpha = 0
        
        // 밀린 단어장 스위치 셀 좌측 하단 세퍼레이터 처리
        let defaultCellInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        self.beLeftUndoneSwitchCell.separatorInset = beLeftUndoneSwitch.isOn ? defaultCellInsets : .zero
        
        let selectUserTTSLanguageActionGesture = UITapGestureRecognizer(target: self, action: #selector(selectUserTTSLanguageAction))
        selectUserTTSLanguageView.addGestureRecognizer(selectUserTTSLanguageActionGesture)
        
//        DictSettingSegue
        let dictionarySettingActionGesture = UITapGestureRecognizer(target: self, action: #selector(dictionarySettingAction))
        dictionarySettingView.addGestureRecognizer(dictionarySettingActionGesture)
        
        
        // Account
        if(userDB.isLoggedin()) {
            showAccountInfo(bool: true)
        } else {
            showAccountInfo(bool: false)
        }
        let accountCellUnderBarInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        accountLoginCell.separatorInset = accountCellUnderBarInset
        
        localizing()
    }
    
    func localizing() {
        loginButton.setTitle("Login".localized, for: .normal)
        logoutButton.setTitle("Logout".localized, for: .normal)
        ebbinghausNotificationLabel.text = "Ebbinghaus notification".localized;
        ebbinghausExplanationLabel.text = "What is the Ebbinghaus Forgetting curve?".localized
        beLeftUndoneNotificationLabel.text = "Delayed voca notification".localized
        bluPickerPrefix.text = "bluPickerPrefix".localized
        bluPickerSuffix.text = "bluPickerSuffix".localized
        ttsLabel.text = "TTSLabelText".localized
        ttsSpeedLabel.text = "TTS speaking speed".localized
        ttsSpeedSlowLabel.text = "Slow".localized
        ttsSpeedMediumLabel.text = "Medium".localized
        ttsSpeedFastLabel.text = "Fast".localized
        nativeLanguageLabel.text = "Native language".localized
        ttsExplanationLabel.text = "What is TTS?".localized
        shortAnswerLabel.text = "Short answer question".localized
        settingDictLabel.text = "Dictionary settings".localized
        haus50ExplanationLabel.text = "Add 50 voca slots.".localized
        haus150ExplanationLabel.text = "Add 150 voca slots.".localized
        haus50priceButton.setTitle("Haus50price".localized, for: .normal)
        haus150priceButton.setTitle("Haus150price".localized, for: .normal)
        sendEmailButton.setTitle("Send".localized, for: .normal)
        
        
        switch Locale.current.languageCode {
        case "ko":
            bluPickerPrefixWidth.constant = 95
            bluPickerSuffixWidth.constant = 40
            break
        case "ja":
            bluPickerPrefixWidth.constant = 95
            bluPickerSuffixWidth.constant = 40
            break
//        case "zh-Hans": // Chinese (Simplified)
//            break
//        case "zh-Hant": // Chinese (Traditional)
//            break
//        case "zh-HK": // Chinese (Hong Kong)
//            break
        default:
            bluPickerPrefixLeading.constant = 10
            bluPickerPrefixWidth.constant = 0
            bluPickerSuffixWidth.constant = 120
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(HighlightItem.getInstance.isNecessary) {
            tableView.scrollToRow(at: developerEmailIP, at: .bottom, animated: false)
            HighlightItem.getInstance.isNecessary = false
            
            haus50Cell.backgroundColor = .orange
            haus150Cell.backgroundColor = .orange
            
            self.tableView.layoutIfNeeded()
            UIView.animate(withDuration: 1.5) {
                self.haus50Cell.backgroundColor = .white
                self.haus150Cell.backgroundColor = .white
                self.tableView.layoutIfNeeded()
            }
        }
        
        if(!pCon.haveAlertPermission()) {
            if(settingDB.getEbbinghaus()) { // DB상 에빙하우스 알림은 켜져있는데 알림 권한이 없을 경우
                ebbinghausSwitch.setOn(false, animated: true)
                settingDB.setEbbinghaus(ebbinghaus: false)
            }
            
            if(settingDB.getBeLeftUndoneAlert()) { // DB상 밀린 단어장 알림은 켜져있는데 알림 권한이 없을 경우
                beLeftUndoneSwitch.setOn(false, animated: true)
                settingDB.setBeLeftUndoneAlert(beLeftUndoneAlert: false)
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
    }
    
    @IBAction func openPickerViewAction(_ sender: UIButton) {
        openPickerView()
    }
    
    func openPickerView() {
        // Relative TableViewCell Height
        pickerViewOpened = true
        tableView.beginUpdates()
        tableView.endUpdates()
        
        
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(fadeInPickerView), userInfo: self, repeats: false)
        // Relative PickerView & Button
        beLeftUndoneContentView.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            // Button
            self.openPickerViewButton.alpha = 0
            self.openPickerViewButton.titleLabel?.textColor = .black
            
            self.beLeftUndonePickerViewWidth.priority = .defaultLow
            
            self.beLeftUndoneContentView.layoutIfNeeded()
        }
        openPickerViewButton.isEnabled = false
        
//        Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(closePickerView), userInfo: self, repeats: false)
    }
    
    @objc func closePickerView() {
        if(!pickerViewOpened) { // 이미 false, 닫혀있다면,
            return
        }
        pickerViewOpened = false
        tableView.beginUpdates()
        tableView.endUpdates()
        
        
        beLeftUndoneTimePicker.isUserInteractionEnabled = true
        beLeftUndoneTimePicker.alpha = 0
        
        beLeftUndoneContentView.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            // Button
            self.openPickerViewButton.alpha = 1.0
            self.openPickerViewButton.titleLabel?.textColor = TagPalette().getBlue()
            
            self.beLeftUndonePickerViewWidth.priority = .defaultHigh
            
            self.beLeftUndoneContentView.layoutIfNeeded()
        }
        openPickerViewButton.isEnabled = true
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        closePickerView()
    }
    
    @objc func fadeInPickerView() {
        beLeftUndoneTimePicker.isUserInteractionEnabled = true
        beLeftUndoneContentView.layoutIfNeeded()
        UIView.animate(withDuration: 0.2) {
            self.beLeftUndoneTimePicker.alpha = 1.0
            self.beLeftUndoneContentView.layoutIfNeeded()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        userTTSLanguageLabel.text = UserDB.getInstance.getUserTTSLanguage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ttsStop()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitle[section]
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return footerTitle[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 밀린 단어장 알림 바로 아래 셀
        if(indexPath == beLeftUndoneIndexPath) {
            if(beLeftUndoneSwitch.isOn) {
                if(pickerViewOpened) {
                    return 100.0
                } else {
                    return 44.0
                }
            } else {
                return CGFloat.leastNormalMagnitude
            }
        }
        
        // 로그인, 계정 이메일 셀
        if(indexPath == accountIndexPath) {
            if(userDB.isLoggedin()) {
                return 64.0
            } else {
                return UITableView.automaticDimension
            }
        }
        // 로그아웃 셀
        if(indexPath == logoutIndexPath) {
            if(userDB.isLoggedin()) {
                // 1. 로그아웃 셀 보이기
                // 2. 로그인 버튼 숨기기
                // 3. 로그인 제공 업체와 계정 이름 표시
                return UITableView.automaticDimension
            } else {
                // 1. 로그아웃 셀 숨기기
                // 2. 로그인 버튼 보이기
                return CGFloat.leastNormalMagnitude
            }
        }
        
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension SettingVC: UIPickerViewDataSource, UIPickerViewDelegate {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // hide pickerview separator
        beLeftUndoneTimePicker.subviews.forEach { $0.isHidden = $0.frame.height < 1.0 }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 1)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 360
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        settingDB.setBeLeftUndoneAlertTime(beLeftUndoneAlertTime: row + 1)
        
        // set UI.
        let bluTime = settingDB.getBeLeftUndoneAlertTime()
        openPickerViewButton.setTitle(String(bluTime), for: .normal)
        beLeftUndoneTimePicker.selectRow(bluTime - 1, inComponent: 0, animated: false)
    }
}

// 기본 설정
extension SettingVC {
    @IBAction func beLeftUndoneSwitchChanged(_ sender: UISwitch) {
        if(beLeftUndoneSwitch.isOn) {
            if(pCon.haveAlertPermission()) {
                // 스위치를 켰고 권한도 있음
                settingDB.setBeLeftUndoneAlert(beLeftUndoneAlert: true)
            } else {
                // 스위치를 켰지만 권한은 없음
                beLeftUndoneSwitch.setOn(false, animated: true)
                settingDB.setBeLeftUndoneAlert(beLeftUndoneAlert: false)
                
                let alert = UIAlertController(title: "Notification not allowed".localized, message: "Delayed voca notification are not available.".localized, preferredStyle: .alert)
                let settingAction = UIAlertAction(title: "Settings".localized, style: .default) { _ in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                }
                let cancelAction = UIAlertAction(title: "Ok".localized, style: .cancel, handler: nil)
                alert.addAction(settingAction)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
            }
        } else {
            // 스위치를 껐음
            settingDB.setBeLeftUndoneAlert(beLeftUndoneAlert: false)
            closePickerView()
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        // 스위치 셀 좌측 하단 세퍼레이터 처리
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            let defaultCellInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            self.beLeftUndoneSwitchCell.separatorInset = self.beLeftUndoneSwitch.isOn ? defaultCellInsets : .zero
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func ebbinghausSwitchChanged(_ sender: UISwitch) {
        if(ebbinghausSwitch.isOn) {
            if(pCon.haveAlertPermission()) {
                // 스위치를 켰고 권한도 있음
                settingDB.setEbbinghaus(ebbinghaus: true)
            } else {
                // 스위치를 켰지만 권한은 없음
                ebbinghausSwitch.setOn(false, animated: true)
                settingDB.setEbbinghaus(ebbinghaus: false)
                
                let alert = UIAlertController(title: "Notification not allowed".localized, message: "Ebbinghaus notifications are not available.".localized, preferredStyle: .alert)
                let settingAction = UIAlertAction(title: "Settings".localized, style: .default) { _ in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                }
                let cancelAction = UIAlertAction(title: "Ok".localized, style: .cancel, handler: nil)
                alert.addAction(settingAction)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
            }
        } else {
            // 스위치를 껐음
            settingDB.setEbbinghaus(ebbinghaus: false)
        }
    }
    
    @IBAction func ttsSwitchChanged(_ sender: UISwitch) {
        settingDB.setTTS(tts: ttsSwitch.isOn)
        if(ttsSwitch.isOn) {
            ttsSwitchOn(speak: true)
        } else {
            ttsSwitchOff()
        }
    }
    
    @IBAction func ttsSpeedSliderChanged(_ sender: UISlider) {
//        let rate: Float = round(ttsSpeedSlider.value) / 10
        var rate: Float = round(ttsSpeedSlider.value)
        rate = sliderValue(rate: rate)
//        print(rate)
        ttsSpeedSlider.value = round(ttsSpeedSlider.value)
        settingDB.setTTSSpeed(ttsSpeed: rate)
        ttsSpeak()
    }
    
    @IBAction func shortAnswerSwitchChanged(_ sender: UISwitch) {
        if(shortAnswerSwitch.isOn == true) {
            settingDB.setShortAnswer(shortAnswer: true)
        } else {
            settingDB.setShortAnswer(shortAnswer: false)
        }
    }
    
    func sliderValue(rate: Float) -> Float {
        var value = rate
        value -= 4
        value /= 2
        value += 4
        value /= 10
        return value
    }
    
    func sliderValueReverse(value: Float) -> Float {
        var rate = value
        rate *= 10
        rate -= 4
        rate *= 2
        rate += 4
        return rate
    }
}


// For Purchase
extension SettingVC {
    @IBAction func purchaseHaus50Action(_ sender: UIButton) {
        if(userDB.isLoggedin()) {
            if(!HausDAO().isSameUUID()) {
                AlertController().simpleAlert(viewController: self, title: "", message: "Logged-in to another device.".localized)
                logoutAccount()
                return
            }
            
            targetProductIdentifier = "com.cloudvoca.haus.50"
            performSegue(withIdentifier: "PurchaseVCSegue", sender: self)
        } else {
            alertLogin()
        }
    }
    @IBAction func purchaseHaus150Action(_ sender: UIButton) {
        if(userDB.isLoggedin()) {
            if(!HausDAO().isSameUUID()) {
                AlertController().simpleAlert(viewController: self, title: "", message: "Logged-in to another device.".localized)
                UserDB.getInstance.logout()
                logoutAccount()
                return
            }
            
            targetProductIdentifier = "com.cloudvoca.haus.150"
            performSegue(withIdentifier: "PurchaseVCSegue", sender: self)
        } else {
            alertLogin()
        }
    }
    
    func alertLogin() {
        let alert = UIAlertController(title: "", message: "Login is required.".localized, preferredStyle: .alert)
        let loginAction = UIAlertAction(title: "Login".localized, style: .default) { _ in
            self.performSegue(withIdentifier: "LoginPageSegue", sender: self)
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(loginAction)
        self.present(alert, animated: true, completion: nil)
    }
}



// For Send Email
extension SettingVC: MFMailComposeViewControllerDelegate {
    @IBAction func sendEmailAction(_ sender: UIButton) {
//        print(MFMailComposeViewController.canSendMail())
        if(MFMailComposeViewController.canSendMail()) {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients(["hausvoca@gmail.com"])
            composeVC.setSubject("")
            composeVC.setMessageBody("", isHTML: false)
            
            present(composeVC, animated: true, completion: nil)
        } else {
            AlertController().simpleAlert(viewController: self, title: "Failed to send email".localized, message: "Please check your device's mail settings.".localized)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// For TTS
extension SettingVC {
    func ttsSwitchOn(speak: Bool) {
        if(speak) {
            ttsSpeak()
        }
        turtleImage.alpha = 1.0
        rabbitImage.alpha = 1.0
        ttsSpeedSlider.isEnabled = true
    }
    
    func ttsSwitchOff() {
        ttsStop()
        turtleImage.alpha = 0.4
        rabbitImage.alpha = 0.4
        ttsSpeedSlider.isEnabled = false
    }
    
    func ttsSpeak() {
        ttsStop()
        let rate: Float = settingDB.getTTSSpeed()
        let sliderValue: Float = sliderValueReverse(value: rate)
        // localization flag
        switch Locale.current.languageCode {
        case "ko":
            ttsService = TTSService(language: "ko-KR")
            ttsService.speech(word: "TTS 말하기 속도는 \(Int(sliderValue))단계 입니다.")
            break
        case "ja":
            ttsService = TTSService(language: "ja-JP")
            ttsService.speech(word: "TTS話す速度は\(Int(sliderValue))段階です。")
            break
        default:
            ttsService = TTSService(language: "en-US")
            ttsService.speech(word: "TTS speaking speed is \(Int(sliderValue)) levels.")
            break
        }
    }
    
    func ttsStop() {
        ttsService.stop()
    }
}


// For Else
extension SettingVC {
    @objc func selectUserTTSLanguageAction() {
        performSegue(withIdentifier: "SelectUserLanguage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SelectUserLanguage") {
            let viewController: SelectLanguageVC = segue.destination as! SelectLanguageVC
            viewController.settingUserLanguageMode = true
        }
        
        if(segue.identifier == "LoginPageSegue") {
            let viewController = segue.destination as! LoginVC
            viewController.loginDelegate = self
        }
        
        if(segue.identifier == "PurchaseVCSegue") {
            let viewController: PurchaseVC = segue.destination as! PurchaseVC
            viewController.targetProductIdentifier = self.targetProductIdentifier
        }
    }
    
    @objc func dictionarySettingAction() {
        performSegue(withIdentifier: "BasicDictionarySelectSegue", sender: self)
    }
}


// Below is realtive with Account
extension SettingVC {
    @IBAction func logoutAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "Do you want to Logout?".localized, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "No".localized, style: .default, handler: nil)
        let logoutAction = UIAlertAction(title: "Yes".localized, style: .destructive, handler: {(alert: UIAlertAction!) in
            self.logoutAccount()
        })
        alert.addAction(cancelAction)
        alert.addAction(logoutAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func logoutAccount() {
        userDB.logout()
        tableView.beginUpdates()
        tableView.endUpdates()
        
        UIView.animate(withDuration: 0.3) {
            let accountCellUnderBarInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.accountLoginCell.separatorInset = accountCellUnderBarInset
            self.view.layoutIfNeeded()
        }
        
        showAccountInfo(bool: false)
        VocaListDB.getInstance.setVocaEnableStatusBySlotCount()
    }
}



// For TTS
class TTSExplanationViewController: UIViewController {
    @IBOutlet weak var tf1: UITextView!
    @IBOutlet weak var tf2: UITextView!
    @IBOutlet weak var tf3: UITextView!
    @IBOutlet weak var tfLink: UITextView!
    
    override func viewDidLoad() {
        self.navigationItem.title = "What is TTS?".localized
        tf1.text = "TTS explanation1".localized;
        tf2.text = "TTS explanation2".localized;
        tf3.text = "TTS explanation3".localized;
        tfLink.text = "TTS Wikipedia link".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
}

// For Ebbinghaus.
class EbbinghausExplanationViewController: UIViewController {
    @IBOutlet weak var surviveDateLabel: UILabel!
    @IBOutlet weak var tf1: UITextView!
    @IBOutlet weak var tf2: UITextView!
    @IBOutlet weak var tf3: UITextView!
    @IBOutlet weak var tfLink: UITextView!
    
    override func viewDidLoad() {
        self.navigationItem.title = "Ebbinghaus Forgetting curve".localized
        surviveDateLabel.text = "Ebbinghaus Survive date".localized
        tf1.text = "Ebbinghaus explanation1".localized;
        tf2.text = "Ebbinghaus explanation2".localized;
        tf3.text = "Ebbinghaus explanation3".localized;
        tfLink.text = "Ebbinghaus Wikipedia link".localized;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
}
