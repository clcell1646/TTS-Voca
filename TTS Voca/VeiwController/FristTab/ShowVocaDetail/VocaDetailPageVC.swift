//
//  VocaDetailPageVC.swift
//  TTS Voca
//
//  Created by 정지환 on 07/06/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import UIKit
import CommonCrypto

protocol BarButtonItemDelegate {
    func addEditBarButton()
    func addShareBarButton()
}


class VocaDetailPageVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, BarButtonItemDelegate {
    var pageViewData: [UIViewController] = [UIViewController]()
    var vocaListDelegate: VocaListDelegate!
    var voca: Voca!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = voca.getTitle()
        addEditBarButton()
        
        self.dataSource = self
        self.delegate = self
        
        let wordListVC: WordListVC = self.loadVC(name: "WordListVC") as! WordListVC
        wordListVC.voca = self.voca
        wordListVC.vocaListDelegate = self.vocaListDelegate
        wordListVC.barButtonItemDelegate = self
        pageViewData.append(wordListVC)
        
        let vocaInfoVC: VocaInfoVC = self.loadVC(name: "VocaInfoVC") as! VocaInfoVC
        vocaInfoVC.voca = self.voca
        vocaInfoVC.barButtonItemDelegate = self
        pageViewData.append(vocaInfoVC)
        
        setViewControllers([pageViewData.first!], direction: .forward, animated: false, completion: nil)
        
        let backgroundView = UIView(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = UIColor.white
        view.insertSubview(backgroundView, at: 0)
    }
    
    func addEditBarButton() {
        let editButton = UIButton(frame: CGRect(x: 0, y: 0, width: 53, height: 31))
        editButton.addTarget(self, action: #selector(editVoca), for: .touchUpInside)
        let editButtonLabel = UILabel(frame: CGRect(x: 3, y: 5, width: 50, height: 20))
        editButtonLabel.text = "Edit".localized
        editButtonLabel.font = UIFont(name: "", size: 15.0)
        editButtonLabel.textAlignment = .right
        editButtonLabel.textColor = UIColor(red: 0.0, green: 122.0 / 255.0, blue: 1.0, alpha: 1.0)
        editButtonLabel.backgroundColor = .clear
        editButtonLabel.textColor = .black
        editButton.addSubview(editButtonLabel)
        let editBarButtonItem = UIBarButtonItem(customView: editButton)
        self.navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    @objc func editVoca() {
        performSegue(withIdentifier: "EditVocaWordSegue", sender: self)
    }
    
    func addShareBarButton() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareVoca))
        self.navigationItem.rightBarButtonItem = shareButton
    }
    
    @objc func shareVoca() {
        ShareVoca().share(vc: self, voca: voca)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "EditVocaWordSegue") {
            let viewController: EditVocaWordVC = segue.destination as! EditVocaWordVC
            viewController.voca = voca
            viewController.wordTableDelegate = viewControllers![0] as? WordTableDelegate
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if(viewController == pageViewData[0]) {
            return nil
        } else {
            return pageViewData[0]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        (pageViewData[1] as! VocaInfoVC).delegate = pageViewData[0] as? StopArrowTimerDelegate
        if(viewController == pageViewData[0]) {
            return pageViewData[1]
        } else {
            return nil
        }
    }
    
    func loadVC(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        (pageViewData[0] as! WordListVC).ttsService.stop()
        vocaListDelegate.addRightBarAddButton()
    }
}
