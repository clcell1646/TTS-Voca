//
//  EditVocaInfo.swift
//  TTS Voca
//
//  Created by 정지환 on 27/07/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import UIKit

class EditVocaInfoNVC: UINavigationController {
    var voca: Voca!
    var vocaListDelegate: VocaListDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        (viewControllers.first! as! NewVocaVC).editMode = true
        (viewControllers.first! as! NewVocaVC).voca = voca
    }
}
