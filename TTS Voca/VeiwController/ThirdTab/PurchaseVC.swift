//
//  PurchaseVC.swift
//  TTS Voca
//
//  Created by 정지환 on 10/08/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

class PurchaseVC: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    @IBOutlet weak var barButtonCancel: UIBarButtonItem!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    var targetProductIdentifier: String!
    
    let productIdentifiers = Set([ "com.cloudvoca.haus.50", "com.cloudvoca.haus.150" ])
    var product: SKProduct?
    var productsArray = Array<SKProduct>()

    @IBOutlet weak var activityIndicatorBackgroundView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    override func viewDidLoad() {
        navigationTitle.title = "Attempt payment".localized
        barButtonCancel.title = "Cancel".localized
        
        activityIndicatorBackgroundView.layer.cornerRadius = 12
        SKPaymentQueue.default().add(self)
        requestProductData()
        
    }
    
    func requestProductData() {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers:
                self.productIdentifiers as Set<String>)
            request.delegate = self
            request.start()
        } else {
            // 인앱결제가 활성화되어있지않습니다. 설정을 확인해주세요.
            let alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { alertAction in
                alert.dismiss(animated: true, completion: nil)
                
                let url: URL? = URL(string: UIApplication.openSettingsURLString)
                if(url != nil) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { alertAction in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        var products = response.products
        
        if(products.count != 0) {
            for i in 0..<products.count {
                product = products[i]
                productsArray.append(product!)
            }
        } else {
            print("No products found")
        }
        
        buyProduct()
    }
    
    func buyProduct() {
        for pd in productsArray {
            if(pd.productIdentifier == targetProductIdentifier) {
                let payment = SKPayment(product: pd)
                SKPaymentQueue.default().add(payment)
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
//                print("Transaction Approved")
//                print("Product Identifier: \(transaction.payment.productIdentifier)")
                deliverProduct(transaction: transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case SKPaymentTransactionState.failed:
//                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
                dismissView()
            default:
                break
            }
        }
    }
    
    func deliverProduct(transaction:SKPaymentTransaction) {
        switch transaction.payment.productIdentifier {
        case "com.cloudvoca.haus.50":
            let userDB = UserDB.getInstance
            userDB.setSlotCount(slotCount: userDB.getSlotCount() + 50)
            
            if(HausDAO().updateSlot(email: UserDB.getInstance.getEmail(), buySlot: 50)) {
//                print("DB Update Success")
            } else {
                // 사용자가 결제는 완료하였지만 DB에 접속하여 슬롯 기록은 실패함
                // 3번 더 시도
                for _ in 0..<3 {
                    if(HausDAO().updateSlot(email: UserDB.getInstance.getEmail(), buySlot: 50)) {
                        break
                    }
                }
                
//                print("DB Update Fail.")
//                AlertController().simpleAlert(viewController: self, title: "", message: "DB 슬롯 저장에 실패했습니다.\n스크린샷을 찍어서 이메일로 보내주세요.\n\(userDB.getEmail()): Haus50")
            }
            break
        case "com.cloudvoca.haus.150":
            let userDB = UserDB.getInstance
            userDB.setSlotCount(slotCount: userDB.getSlotCount() + 150)
            
            if(HausDAO().updateSlot(email: UserDB.getInstance.getEmail(), buySlot: 150)) {
//                print("DB Update Success")
            } else {
                // 사용자가 결제는 완료하였지만 DB에 접속하여 슬롯 기록은 실패함
                // 3번 더 시도
                for _ in 0..<3 {
                    if(HausDAO().updateSlot(email: UserDB.getInstance.getEmail(), buySlot: 150)) {
                        break
                    }
                }
                
//                print("DB Update Fail.")
//                AlertController().simpleAlert(viewController: self, title: "", message: "DB 슬롯 저장에 실패했습니다.\n스크린샷을 찍어서 이메일로 보내주세요.\n\(userDB.getEmail()): Haus150")
            }
            break
        default:
            break
        }
        dismissView()
    }
    @IBAction func transactionCancelButtonAction(_ sender: UIBarButtonItem) {
        dismissView()
    }
    
    func dismissView() {
        activityIndicatorView.stopAnimating()
        activityIndicatorBackgroundView.isHidden = true
        self.dismiss(animated: true, completion: nil)
//        progressLabelTimer?.invalidate()
//        progressLabelTimer = nil
    }
}


