//
//  ViewController.swift
//  TTS Voca
//
//  Created by 정지환 on 16/05/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import UIKit
import TAKUUID

class VocaListNVC: UINavigationController {
    var vocaListDelegate: VocaListDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


public protocol VocaListDelegate {
    func reloadVocaTable()
    func addRightBarAddButton()
}


class VocaListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, VocaListDelegate {
    func reloadVocaTable() {
        setVocaList()
        vocaTable.reloadData()
        
        setVocaEmptyLabel()
    }
    
    func addRightBarAddButton() {
        addRightBarButtonAdd()
    }
    
    @IBOutlet weak var rootViewTitle: UINavigationItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet var rootView: UIView!
    var currentTag: Int = 0
    var currentAlign: Int = 0
    @IBOutlet weak var tagSelector: UIView!
    
    @IBOutlet weak var alignSpace: NSLayoutConstraint!
    @IBOutlet weak var alginTagSpace: NSLayoutConstraint!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var tagLabel0_letter: UILabel!
    @IBOutlet weak var tagLabel0: UIView!
    @IBOutlet weak var tagLabel0_width: NSLayoutConstraint!
    @IBOutlet weak var tagLabel0_height: NSLayoutConstraint!
    @IBOutlet weak var tagLabel1: UIView!
    @IBOutlet weak var tagLabel1_width: NSLayoutConstraint!
    @IBOutlet weak var tagLabel1_height: NSLayoutConstraint!
    @IBOutlet weak var tagLabel2: UIView!
    @IBOutlet weak var tagLabel2_width: NSLayoutConstraint!
    @IBOutlet weak var tagLabel2_height: NSLayoutConstraint!
    @IBOutlet weak var tagLabel3: UIView!
    @IBOutlet weak var tagLabel3_width: NSLayoutConstraint!
    @IBOutlet weak var tagLabel3_height: NSLayoutConstraint!
    @IBOutlet weak var tagLabel4: UIView!
    @IBOutlet weak var tagLabel4_width: NSLayoutConstraint!
    @IBOutlet weak var tagLabel4_height: NSLayoutConstraint!
    @IBOutlet weak var tagLabel5: UIView!
    @IBOutlet weak var tagLabel5_width: NSLayoutConstraint!
    @IBOutlet weak var tagLabel5_height: NSLayoutConstraint!
    
    @IBOutlet weak var alignSelector: UIView!
    @IBOutlet weak var alignLabel: UILabel!
    @IBOutlet weak var reviewPriorityLabel: UIView!
    @IBOutlet weak var reviewPriorityLetter: UILabel!
    @IBOutlet weak var reviewPriority_width: NSLayoutConstraint!
    @IBOutlet weak var reviewPriority_height: NSLayoutConstraint!
    @IBOutlet weak var datePriorityLabel: UIView!
    @IBOutlet weak var datePriorityLetter: UILabel!
    @IBOutlet weak var datePriority_width: NSLayoutConstraint!
    @IBOutlet weak var datePriority_height: NSLayoutConstraint!
    
    @IBOutlet weak var vocaEmptyLabel: UILabel!
    
    let defaultTagWidth: CGFloat = 38, defaultTagHeight: CGFloat = 18
    let selectedTagWidth: CGFloat = 38 * 1.3, selectedTagHeight: CGFloat = 18 * 1.3
    
    let defaultAlignWidth: CGFloat = 90, defaultAlignHeight: CGFloat = 18
    let selectedAlignWidth: CGFloat = 90 * 1.3, selectedAlignHeight: CGFloat = 18 * 1.3
    
    let palette: TagPalette = TagPalette()
    var selectedCellVoca: Voca!
    
    let tagSelectorHeight_F: CGFloat = 40.0
    let alignSelectorHeight_F: CGFloat = 42.0
    let seperatorHeight_F: CGFloat = 1.0
    @IBOutlet weak var tagSelectorHeight: NSLayoutConstraint!
    @IBOutlet weak var seperator1: NSLayoutConstraint!
    @IBOutlet weak var alignSelectorHeight: NSLayoutConstraint!
    @IBOutlet weak var seperator2: NSLayoutConstraint!
    
    @IBOutlet weak var vocaTable: UITableView!
    let vocaListDB: VocaListDB = VocaListDB.getInstance
    var vocaList: Array<Voca> = Array<Voca>()
    
    override func viewDidLoad() {
        (UIApplication.shared.delegate as! AppDelegate).vocaListDelegate = self
        initUI()
        localizing()
        if(UserDB.getInstance.isLoggedin()) {
            if(!HausDAO().isSameUUID()) {
                AlertController().simpleAlert(viewController: self, title: "", message: "Logged-in to another device.".localized)
                UserDB.getInstance.logout()
            }
        }
        
        vocaTable.rowHeight = 140
        vocaTable.dataSource = self
        vocaTable.delegate = self
        vocaTable.allowsMultipleSelectionDuringEditing = true
        vocaTable.contentInset = UIEdgeInsets(top: 84.0, left: 0, bottom: 2.0, right: 0)
        addRightBarButtonAdd()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPressGestureRecognizer:)))
//        longPressRecognizer.minimumPressDuration = 1.0 // default 0.5
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    //Called, when long press occurred
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if(vocaTable.isEditing) { return }
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let point: CGPoint = longPressGestureRecognizer.location(in: vocaTable)
            if let indexPath = vocaTable.indexPathForRow(at: point) {
                startEditing()
                print(indexPath)
                vocaTable.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
            
            countSelectedVoca()
        }
    }
    
    @objc func addButtonAction() {
        let vocaCount = UserDB.getInstance.getVocaCount()
        if(vocaCount >= UserDB.getInstance.getSlotCount()) { // 단어장 개수가 슬롯 갯수보다 많거나 같은 경우
            askPurchase()
        } else {
            performSegue(withIdentifier: "NewVocaSegue", sender: self)
        }
    }
    
    // 구매하시겠습니까?
    func askPurchase() {
        let alert = UIAlertController(title: "", message: "There is not enough slots to make more voca.".localized, preferredStyle: .alert)
        let purchaseAction = UIAlertAction(title: "Expand".localized, style: .default, handler: {(alert: UIAlertAction!) in
            HighlightItem.getInstance.isNecessary = true
            self.tabBarController?.selectedIndex = 2
        })
        let cancelAction = UIAlertAction(title: "Ok".localized, style: .cancel, handler: nil)
        alert.addAction(purchaseAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let appDB: AppDB = AppDB.getInstance
        if(appDB.isFirstLaunch()) {
//            print("isFirstLaunch: true")
            let pCon = PermissionController()
            if(pCon.haveAlertPermission()) {
                SettingDB.getInstance.setEbbinghaus(ebbinghaus: true)
                SettingDB.getInstance.setBeLeftUndoneAlert(beLeftUndoneAlert: true)
                AlertController().simpleAlert(viewController: self, title: "Allow notification".localized, message: "Ebbinghaus notifications have been set.".localized)
            } else {
                SettingDB.getInstance.setEbbinghaus(ebbinghaus: false)
                SettingDB.getInstance.setBeLeftUndoneAlert(beLeftUndoneAlert: false)
                AlertController().simpleAlert(viewController: self, title: "Do not allow notifications".localized, message: "Ebbinghaus notifications are not available.\nPlease check your settings.".localized)
            }
        } else {
//            print("isFirstLaunch: false")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadVisibleCells()
        self.tabBarController?.tabBar.isHidden = false
        
        
        // 슬롯이 부족한가?
        if(vocaListDB.isSlotIsShort()) {
            vocaTable.reloadData()
        }
    }
    
    var lastOffset: CGFloat = 0
    // this delegate is called when the scrollView (i.e your UITableView) will start scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        //        print(offsetY)

        if(offsetY < 0) {
            showSelector()
        } else {
            if(offsetY > lastOffset) { // 원래 +280
                // Downward
                hideSelector()
            } else if(offsetY < lastOffset) { // 원래 -40
                // Upward
                showSelector()
            }
        }
    }
    
    func showSelector() {
        if(tagSelectorHeight.constant == tagSelectorHeight_F) {
            return
        }
        rootView.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: { // duration: 0.2
            self.tagSelector.alpha = 1.0
            self.alignSelector.alpha = 1.0
            self.tagSelectorHeight.constant = self.tagSelectorHeight_F
            self.alignSelectorHeight.constant = self.alignSelectorHeight_F
            self.seperator1.constant = self.seperatorHeight_F
            self.seperator2.constant = self.seperatorHeight_F
            self.rootView.layoutIfNeeded()
        })
    }
    
    func hideSelector() {
        if(tagSelectorHeight.constant == 0.0) {
            return
        }
        rootView.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.tagSelector.alpha = 0.0
            self.alignSelector.alpha = 0.0
            self.tagSelectorHeight.constant = 0
            self.alignSelectorHeight.constant = 0
            self.seperator1.constant = 0
            self.seperator2.constant = 0
            self.rootView.layoutIfNeeded()
        })
    }
    
    func setVocaList() {
        vocaList = Array(vocaListDB.getList(tag: currentTag))
        
        // currentAlign = [ 0: "복습 필요 순", 1: "등록 일자 순" ]
        switch currentAlign {
        case 0:
            vocaList = vocaList.sorted(by: {$0.getE_Date() < $1.getE_Date()})
            break
        case 1:
            vocaList = vocaList.sorted(by: {$0.getCreateDate() < $1.getCreateDate()})
            break
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        endEditing()
        if(segue.identifier == "NewVocaSegue") {
            let viewController: VocaListNVC = segue.destination as! VocaListNVC
            viewController.vocaListDelegate = self
        }
        if(segue.identifier == "VocaDetailSegue") {
            let viewController: VocaDetailPageVC = segue.destination as! VocaDetailPageVC
            viewController.vocaListDelegate = self
            viewController.voca = selectedCellVoca
        }
        if(segue.identifier == "EditVocaInfoSegue") {
            let viewController: EditVocaInfoNVC = segue.destination as! EditVocaInfoNVC
            viewController.voca = selectedCellVoca
            viewController.vocaListDelegate = self
        }
    }

    @IBAction func editButtonAction(_ sender: UIBarButtonItem) {
        if(vocaTable.isEditing) {
            endEditing()
        } else {
            startEditing()
        }
    }
    
    func startEditing() {
        rootViewTitle.title = "Select voca".localized
        editButton.title = "Cancel".localized
        editButton.style = .done
        addRightBarButtonMultipleAction(isEnable: false)
        
        vocaTable.setEditing(true, animated: true)
        for cell in vocaTable.visibleCells {
            cell.selectionStyle = .default
        }
        
    }
    
    func endEditing() {
        rootViewTitle.title = "Voca".localized
        editButton.title = "EditSelect".localized
        editButton.style = .plain
        addRightBarButtonAdd()
        
        vocaTable.setEditing(false, animated: true)
        for cell in vocaTable.visibleCells {
            cell.selectionStyle = .none
        }
        
    }
    
    func reloadVisibleCells() {
        for cell in vocaTable.visibleCells {
            let c = cell as! VocaTableCell
            c.loadMutableData()
        }
    }
    
    func addRightBarButtonAdd() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func addRightBarButtonMultipleAction(isEnable: Bool) {
        let deleteButton = UIButton(frame: CGRect(x: 0, y: 0, width: 53, height: 31))
        deleteButton.addTarget(self, action: #selector(multipleVocaAction), for: .touchUpInside)
        let deleteButtonLabel = UILabel(frame: CGRect(x: 3, y: 5, width: 50, height: 20))
        deleteButtonLabel.text = "Edit".localized
        deleteButtonLabel.font = UIFont(name: "", size: 15.0)
        deleteButtonLabel.textAlignment = .right
        deleteButtonLabel.textColor = UIColor(red: 0.0, green: 122.0 / 255.0, blue: 1.0, alpha: 1.0)
        deleteButtonLabel.backgroundColor = .clear
        deleteButtonLabel.textColor = .black
        deleteButton.addSubview(deleteButtonLabel)
        if(isEnable) {
            deleteButtonLabel.alpha = 1.0
        } else {
            deleteButtonLabel.alpha = 0.4
        }
        let deleteBarButtonItem = UIBarButtonItem(customView: deleteButton)
        deleteBarButtonItem.isEnabled = isEnable
        self.navigationItem.rightBarButtonItem = deleteBarButtonItem
    }
    
    func getSelectedRowsCount() -> Int {
        if let deleteRowsIndexPath = vocaTable.indexPathsForSelectedRows {
            return deleteRowsIndexPath.count
        } else {
            return 0
        }
    }
}


// 다중 선택 관련
extension VocaListVC {
    // 편집 액션
    @objc func multipleVocaAction() {
        if let selectedRowsIndexPath = vocaTable.indexPathsForSelectedRows {
            let alert = UIAlertController(title: "", message: "Please select a task to run.".localized, preferredStyle: .actionSheet)
            let notiOffAction = UIAlertAction(title: "Turn off notifications".localized, style: .default, handler: {(alert: UIAlertAction!) in
                self.multipleVocaNotificationOff(selectedRows: selectedRowsIndexPath)
            })
            let notiOnAction = UIAlertAction(title: "Turn on notifications".localized, style: .default, handler: {(alert: UIAlertAction!) in
                self.multipleVocaNotificationOn(selectedRows: selectedRowsIndexPath)
            })
            let deleteAction = UIAlertAction(title: "Delete".localized, style: .destructive, handler: {(alert: UIAlertAction!) in
                self.multipleVocaDelete(selectedRows: selectedRowsIndexPath)
            })
            let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: {(alert: UIAlertAction!) in
//                self.endEditing()
            })
            
            alert.addAction(notiOnAction)
            alert.addAction(notiOffAction)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
            switch(UIDevice.current.userInterfaceIdiom) {
            case .phone:
                self.present(alert, animated: true, completion: nil)
                break
            case .pad:
                alert.popoverPresentationController?.sourceView = self.view
                
                alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                // hide arrow
                alert.popoverPresentationController?.permittedArrowDirections = []
                self.present(alert, animated: true, completion: nil)
                break
            default:
                break
            }
        } else {
            // 버튼을 비활성화 하므로 이하의 코드는 실행되지 않음 XXX
            // 단어장을 선택한 뒤 다른 태그로 이동하면 우측 상단 버튼이 활성화되어 있는데, 이 때 버튼을 누르면 이하의 코드가 실행됨.
//            AlertController().simpleAlert(viewController: self, title: "", message: "선택된 단어장이 없습니다.")
            showToastMessage(message: "There is no voca selected.".localized)
            endEditing()
        }
    }
    
    @objc func multipleVocaNotificationOn(selectedRows: [IndexPath]) {
        let alert = UIAlertController(title: "", message: "Do you want to turn on notifications for the selected voca?".localized, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "No".localized, style: .default, handler: {(alert: UIAlertAction!) in
//            self.endEditing()
        })
        let deleteAction = UIAlertAction(title: "Yes".localized, style: .default, handler: {(alert: UIAlertAction!) in
            self.setNotificationSelectedVoca(indexPaths: selectedRows, isOn: true)
//            AlertController().simpleAlert(viewController: self, title: "", message: "선택한 단어장의 알림을 켰습니다.")
            self.showToastMessage(message: "You have turned on notifications for the selected voca.".localized)
            self.endEditing()
        })
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func multipleVocaNotificationOff(selectedRows: [IndexPath]) {
        let alert = UIAlertController(title: "", message: "Do you want to turn off notifications for the selected voca?".localized, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "No".localized, style: .default, handler: {(alert: UIAlertAction!) in
//            self.endEditing()
        })
        let deleteAction = UIAlertAction(title: "Yes".localized, style: .default, handler: {(alert: UIAlertAction!) in
            self.setNotificationSelectedVoca(indexPaths: selectedRows, isOn: false)
//            AlertController().simpleAlert(viewController: self, title: "", message: "선택한 단어장의 알림을 껐습니다.")
            self.showToastMessage(message: "You have turned off notifications for the selected voca.".localized)
            self.endEditing()
        })
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setNotificationSelectedVoca(indexPaths: [IndexPath], isOn: Bool) {
        for ip in indexPaths {
            let row = ip.row
            vocaListDB.setNotification(num: vocaList[row].getNum(), isOn: isOn)
        }
        reloadVisibleCells()
    }
    
    // 선택된 단어장들 삭제
    func multipleVocaDelete(selectedRows: [IndexPath]) {
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete\nthe selected vocabulary?".localized, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "No".localized, style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "Yes".localized, style: .destructive, handler: {(alert: UIAlertAction!) in self.deleteSeletedVoca(indexPaths: selectedRows)
            self.showToastMessage(message: "Deleted selected voca.".localized)
        })
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteSeletedVoca(indexPaths: [IndexPath]) {
        endEditing()
        for ip in indexPaths {
            let row = ip.row
            vocaListDB.deleteVoca(num: vocaList[row].getNum())
        }
        
        setVocaList()
        vocaTable.beginUpdates()
        vocaTable.deleteRows(at: indexPaths, with: .left)
        vocaTable.endUpdates()
        if(UserDB.getInstance.getSlotCount() <= vocaList.count) {
            for cell in vocaTable.visibleCells {
                (cell as! VocaTableCell).loadMutableData()
            }
        }
        
        setVocaEmptyLabel()
    }
    
}




// 기본 테이블 뷰 정보들
extension VocaListVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vocaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VocaTableCell = vocaTable.dequeueReusableCell(withIdentifier: "VocaTableCell", for: indexPath) as! VocaTableCell
        let voca: Voca = vocaList[indexPath.row]
        cell.setData(voca: voca)
        cell.initUI()
        cell.loadMutableData()
        if(vocaTable.isEditing) {
            cell.selectionStyle = .default
        } else {
            cell.selectionStyle = .none
        }
        
//        if(!voca.getIsEnable()) {
//            cell.disabledCardUI()
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(vocaTable.isEditing) {
            countSelectedVoca()
        } else {
            selectedCellVoca = vocaList[indexPath.row]
            // 슬롯 초과인 단어장 인지 검증
            if(selectedCellVoca.getIsEnable()) {
                performSegue(withIdentifier: "VocaDetailSegue", sender: self)
            } else {
                AlertController().simpleAlert(viewController: self, title: "", message: "This voca has been deactivated due to lack of slots.\nPlease check your account slot count.".localized)
            }
        }
    }
    
    func countSelectedVoca() {
        if(vocaTable.isEditing) {
            let count = getSelectedRowsCount()
            if(count == 0) {
                rootViewTitle.title = "Select voca".localized
                addRightBarButtonMultipleAction(isEnable: false)
            } else {
                rootViewTitle.title = "\(count)" + " items".localized
                addRightBarButtonMultipleAction(isEnable: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if(vocaTable.isEditing) {
            countSelectedVoca()
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let voca = vocaList[indexPath.row]
        let notiAction = UIContextualAction(style: .normal, title: "", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            if(voca.getNotification()) {
                VocaDB.getInstance.setNotification(voca: voca, notification: false)
                self.showToastMessage(message: "You have turned off notifications for the selected voca.".localized)
            } else {
                VocaDB.getInstance.setNotification(voca: voca, notification: true)
                self.showToastMessage(message: "You have turned on notifications for the selected voca.".localized)
            }
            (self.vocaTable.cellForRow(at: indexPath) as! VocaTableCell).loadMutableData()
            success(true)
        })
        notiAction.backgroundColor = .orange
        if(voca.getNotification()) {
            notiAction.image = UIImage(named: "Alarm_Off")
        } else {
            notiAction.image = UIImage(named: "Alarm_On")
        }
        
        return UISwipeActionsConfiguration(actions: [ notiAction ])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete".localized, handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            let alert = UIAlertController(title: "", message: "Are you sure you want to delete\nthe selected vocabulary?".localized, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "No".localized, style: .default, handler: nil)
            let deleteAction = UIAlertAction(title: "Yes".localized, style: .destructive, handler: {(alert: UIAlertAction!) in
                self.deleteSeletedVoca(indexPaths: [indexPath])
                self.showToastMessage(message: "Deleted selected voca.".localized)
            })
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            self.present(alert, animated: true, completion: nil)
            success(false) // 스와이프한 것이 닫히는가?
        })
        
        let editAction = UIContextualAction(style: .normal, title: "Edit".localized, handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self.selectedCellVoca = self.vocaList[indexPath.row]
            self.performSegue(withIdentifier: "EditVocaInfoSegue", sender: self)
            success(true)
        })
        editAction.backgroundColor = UIColor(red: 0.08, green: 0.37, blue: 1.0, alpha: 1.0)
        
        let shareAction = UIContextualAction(style: .normal, title: "Share".localized, handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            ShareVoca().share(vc: self, voca: self.vocaList[indexPath.row])
            success(false)
        })
        
        return UISwipeActionsConfiguration(actions: [ deleteAction, editAction, shareAction ])
    }
    
    func showToastMessage(message: String) {
        let toastLabel: UILabel = UILabel(frame: CGRect(x: view.frame.size.width / 2 - 150, y: view.frame.size.height - 150, width: 300, height: 40))
        toastLabel.backgroundColor = UIColor.init(red: 50 / 255.0, green: 65 / 255.0, blue: 117 / 255.0, alpha: 1.0)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center
        view.addSubview(toastLabel)
        
        toastLabel.text = message
        toastLabel.font = UIFont.boldSystemFont(ofSize: 15)
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        UIView.animate(withDuration: 1.6, animations: {
            toastLabel.alpha = 0.0
        }, completion: {
            (isBool) -> Void in
            toastLabel.removeFromSuperview()
        })
    }
}








class VocaTableCell: UITableViewCell {
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var languageWordCount: UILabel!
    @IBOutlet weak var learningCount: UILabel!
    @IBOutlet weak var cardBadge: UIView!
    @IBOutlet weak var cardBadgeImage: UIImageView!
    @IBOutlet weak var cardBadgeImageHeight: NSLayoutConstraint!
    @IBOutlet weak var cardBadgeImageWidth: NSLayoutConstraint!
    @IBOutlet weak var cardBadgeLabel: UILabel!
    @IBOutlet weak var e_Progress: UILabel!
    @IBOutlet weak var e_bar1: UIView!
    @IBOutlet weak var e_bar2: UIView!
    @IBOutlet weak var e_bar3: UIView!
    @IBOutlet weak var e_bar4: UIView!
    @IBOutlet weak var e_bar5: UIView!
    var voca: Voca!
    
    func setData(voca: Voca) {
        self.voca = voca
    }
    
    func initUI() {
        let cornerRadius: CGFloat = 1.5
        e_bar1.layer.cornerRadius = cornerRadius
        e_bar2.layer.cornerRadius = cornerRadius
        e_bar3.layer.cornerRadius = cornerRadius
        e_bar4.layer.cornerRadius = cornerRadius
        e_bar5.layer.cornerRadius = cornerRadius
    }
    
    func disabledCardUI() {
        card.backgroundColor = .lightGray
        cardBadge.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
    }
    
    func loadMutableData() {
        let title_S = voca.getTitle()
        title.text = title_S
        
        var languageWordCount_S: String = ""
        languageWordCount_S.append(voca.getLanguage())
        languageWordCount_S.append(", ")
        languageWordCount_S.append(String(voca.getWordCount()))
        languageWordCount_S.append(" words".localized)
        languageWordCount.text = languageWordCount_S
        
        var learningCount_S: String = ""
        learningCount_S.append("Total learnings".localized + " : ")
        learningCount_S.append(String(voca.getLearningCount()))
        learningCount_S.append(" times".localized)
        learningCount.text = learningCount_S
        
        // 에빙하우스 보유곡선에 따라 학습해야하는 날짜가 지남
        cardBadge.layer.cornerRadius = cardBadge.bounds.height / 2
        if(voca.getE_Date() < Date()) {
            let palette: TagPalette = TagPalette()
            cardBadge.backgroundColor = palette.getBadgeColor(tag: voca.getTag())
            if(voca.getE_Status() == 0) {
                if(voca.getNum() < 0) { // 기본 단어장은 "새 단어장" 뱃지 표시 안함.
                    cardBadge.isHidden = true
                } else {
//                    cardBadgeImage.image = UIImage(named: "N_origin")
//                    cardBadgeImageHeight.constant = 7.5
//                    cardBadgeImageWidth.constant = 7.5
                    switch Locale.current.languageCode {
                    case "ko":
                        cardBadgeLabel.text = "New voca".localized
                        break
                    case "ja":
                        cardBadgeLabel.text = "New voca".localized
                        break
                    default:
                        cardBadgeLabel.text = "New voca"
                        break
                    }
                    cardBadgeImage.isHidden = true
                    cardBadge.isHidden = false
                }
            } else {
                cardBadgeImageHeight.constant = 8
                cardBadgeImageWidth.constant = 8
                if(voca.getNotification()) {
                    cardBadgeImage.image = UIImage(named: "Alarm_On")
                } else {
                    cardBadgeImage.image = UIImage(named: "Alarm_Off")
                }
                
                cardBadgeLabel.text = "Review".localized
                cardBadgeImage.isHidden = false
                cardBadge.isHidden = false
            }
        } else {
            cardBadge.isHidden = true
        }
        
        if(voca.getIsEnable()) {
            TagPalette().setBackground(card: card, tag: voca.getTag())
        } else {
            disabledCardUI()
        }

        let e_Status = voca.getE_Status()
        if(e_Status < 1) {
            e_Progress.alpha = 0
            e_bar1.alpha = 0
        } else {
            e_Progress.alpha = 1.0
            e_bar1.alpha = 1.0
        }
        if(e_Status < 2) {
            e_bar2.alpha = 0
        } else {
            e_bar2.alpha = 1.0
        }
        if(e_Status < 3) {
            e_bar3.alpha = 0
        } else {
            e_bar3.alpha = 1.0
        }
        if(e_Status < 4) {
            e_bar4.alpha = 0
        } else {
            e_bar4.alpha = 1.0
        }
        if(e_Status < 5) {
            e_bar5.alpha = 0
        } else {
            e_bar5.alpha = 1.0
        }
    }
}


    // Related with Tag
extension VocaListVC {
    func initUI() {
        tagSelector.layer.masksToBounds = true
        alignSelector.layer.masksToBounds = true
        
        tagLabel1.backgroundColor = palette.getBlue()
        tagLabel2.backgroundColor = palette.getGreen()
        tagLabel3.backgroundColor = palette.getYellow()
        tagLabel4.backgroundColor = palette.getRed()
        tagLabel5.backgroundColor = palette.getPurple()
        setLayer(label: tagLabel0)
        setLayer(label: tagLabel1)
        setLayer(label: tagLabel2)
        setLayer(label: tagLabel3)
        setLayer(label: tagLabel4)
        setLayer(label: tagLabel5)
        
        selectTag(at: 0)
        selectAlign(at: 0)
        
        setLayer(label: reviewPriorityLabel)
        setLayer(label: datePriorityLabel)
        
        setVocaEmptyLabel()
        
        switch(UIDevice.current.userInterfaceIdiom) {
        case .phone:
            let array = tabBarController?.customizableViewControllers
            for controller in array! {
                controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            }
            print("this is phone.")
            alignSpace.constant = 5
            alginTagSpace.constant = 0
            break
        case .pad:
            print("this is pad.")
            alignSpace.constant = 58
            alginTagSpace.constant = 20
            break
        default:
            break
        }
    }
    
    func setVocaEmptyLabel() {
        if(vocaList.count == 0) {
            vocaEmptyLabel.isHidden = false
        } else {
            vocaEmptyLabel.isHidden = true
        }
    }
    
    func setLayer(label: UIView) {
        let layer = label.layer
        layer.cornerRadius = 4
    }
    
    @IBAction func tagAction0(_ sender: UITapGestureRecognizer) {
        selectTag(at: 0)
    }
    @IBAction func tagAction1(_ sender: UITapGestureRecognizer) {
        selectTag(at: 1)
    }
    @IBAction func tagAction2(_ sender: UITapGestureRecognizer) {
        selectTag(at: 2)
    }
    @IBAction func tagAction3(_ sender: UITapGestureRecognizer) {
        selectTag(at: 3)
    }
    @IBAction func tagAction4(_ sender: UITapGestureRecognizer) {
        selectTag(at: 4)
    }
    @IBAction func tagAction5(_ sender: UITapGestureRecognizer) {
        selectTag(at: 5)
    }
    
    func selectTag(at: Int) {
        endEditing()

        currentTag = at
        setVocaList()
        vocaTable.reloadData()
        
        tagSelector.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            if(at == 0) {
                self.selectedTagUI(view: self.tagLabel0, width: self.tagLabel0_width, height: self.tagLabel0_height)
                self.setFontAffineLarge(label: self.tagLabel0_letter)
//                self.selectedLetterUI(label: self.tagLabel0_letter)
            } else {
                self.defaultTagUI(view: self.tagLabel0, width: self.tagLabel0_width, height: self.tagLabel0_height)
                self.setFontAffineSmall(label: self.tagLabel0_letter)
//                self.defaultLetterUI(label: self.tagLabel0_letter)
            }
            if(at == 1) {
                self.selectedTagUI(view: self.tagLabel1, width: self.tagLabel1_width, height: self.tagLabel1_height)
            } else {
                self.defaultTagUI(view: self.tagLabel1, width: self.tagLabel1_width, height: self.tagLabel1_height)
            }
            if(at == 2) {
                self.selectedTagUI(view: self.tagLabel2, width: self.tagLabel2_width, height: self.tagLabel2_height)
            } else {
                self.defaultTagUI(view: self.tagLabel2, width: self.tagLabel2_width, height: self.tagLabel2_height)
            }
            if(at == 3) {
                self.selectedTagUI(view: self.tagLabel3, width: self.tagLabel3_width, height: self.tagLabel3_height)
            } else {
                self.defaultTagUI(view: self.tagLabel3, width: self.tagLabel3_width, height: self.tagLabel3_height)
            }
            if(at == 4) {
                self.selectedTagUI(view: self.tagLabel4, width: self.tagLabel4_width, height: self.tagLabel4_height)
            } else {
                self.defaultTagUI(view: self.tagLabel4, width: self.tagLabel4_width, height: self.tagLabel4_height)
            }
            if(at == 5) {
                self.selectedTagUI(view: self.tagLabel5, width: self.tagLabel5_width, height: self.tagLabel5_height)
            } else {
                self.defaultTagUI(view: self.tagLabel5, width: self.tagLabel5_width, height: self.tagLabel5_height)
            }
            self.tagSelector.layoutIfNeeded()
        })
    }
    
    func selectedTagUI(view: UIView, width: NSLayoutConstraint, height: NSLayoutConstraint) {
        width.constant = selectedTagWidth
        height.constant = selectedTagHeight
    }
    
    func defaultTagUI(view: UIView, width: NSLayoutConstraint, height: NSLayoutConstraint) {
        width.constant = defaultTagWidth
        height.constant = defaultTagHeight
    }
    
    @IBAction func reviewPriority(_ sender: UITapGestureRecognizer) {
        selectAlign(at: 0)
    }
    
    @IBAction func datePriority(_ sender: UITapGestureRecognizer) {
        selectAlign(at: 1)
    }
    
    func selectAlign(at: Int) {
        endEditing()
        
        currentAlign = at
        setVocaList()
        vocaTable.reloadData()
        
        alignSelector.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            if(at == 0) {
                self.selectedAlignUI(view: self.reviewPriorityLabel, width: self.reviewPriority_width, height: self.reviewPriority_height)
                self.setFontAffineLarge(label: self.reviewPriorityLetter)
            } else {
                self.defaultAlignUI(view: self.reviewPriorityLabel, width: self.reviewPriority_width, height: self.reviewPriority_height)
                self.setFontAffineSmall(label: self.reviewPriorityLetter)
            }
            if(at == 1) {
                self.selectedAlignUI(view: self.datePriorityLabel, width: self.datePriority_width, height: self.datePriority_height)
                self.setFontAffineLarge(label: self.datePriorityLetter)
            } else {
                self.defaultAlignUI(view: self.datePriorityLabel, width: self.datePriority_width, height: self.datePriority_height)
                self.setFontAffineSmall(label: self.datePriorityLetter)
            }
            self.alignSelector.layoutIfNeeded()
        })
    }
    
    func selectedLetterUI(label: UILabel) {
        label.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
    }
    
    func defaultLetterUI(label: UILabel) {
        label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    func selectedAlignUI(view: UIView, width: NSLayoutConstraint, height: NSLayoutConstraint) {
        width.constant = selectedAlignWidth
        height.constant = selectedAlignHeight
    }
    
    func defaultAlignUI(view: UIView, width: NSLayoutConstraint, height: NSLayoutConstraint) {
        width.constant = defaultAlignWidth
        height.constant = defaultAlignHeight
    }
    
    func setFontAffineSmall(label: UILabel) {
        label.transform = CGAffineTransform(scaleX: 10 / 13, y: 10 / 13)
    }
    
    func setFontAffineLarge(label: UILabel) {
        label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
}


extension VocaListVC {
    func localizing() {
        tagLabel.text = "Tag".localized
        alignLabel.text = "Align".localized
        tagLabel0_letter.text = "All".localized
        reviewPriorityLetter.text = "Align Review required".localized
        datePriorityLetter.text = "Align Creation date".localized
        vocaEmptyLabel.text = "There is no voca. Try adding voca!".localized
    }
}
