//
//  DictionaryView.swift
//  TTS Voca
//
//  Created by 정지환 on 10/07/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import UIKit
import WebKit

class DictionaryView: UIViewController {
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var webView: WKWebView!
    var urlString: String!
    var testURL: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationTitle.title = "Dictionary search".localized
        doneButton.title = "Done".localized
        
        if let url = testURL {
            let requset = URLRequest(url: url)
            webView.load(requset)
        } else {
            let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let url = URL(string: encodedURL)!
            let requset = URLRequest(url: url)
            webView.load(requset)
        }
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
