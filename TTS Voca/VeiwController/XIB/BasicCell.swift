//
//  CustomUITableViewCell.swift
//  TTS Voca
//
//  Created by 정지환 on 07/08/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import UIKit

class BasicCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var iView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(title: String, imageName: String? = nil) {
        self.label.text = title
        if let iName = imageName {
            iView.image = UIImage(named: iName)
            iView.alpha = 1.0
        } else {
            iView.alpha = 0
        }
    }
}
