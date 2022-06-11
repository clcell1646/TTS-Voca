//
//  AlertController.swift
//  TTS Voca
//
//  Created by 정지환 on 10/07/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import UIKit

class AlertController {
    init() {
        
    }
    
    func simpleAlert(viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok".localized, style: .default, handler: nil)
        alert.addAction(alertAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}
