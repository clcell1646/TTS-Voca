//
//  TablePalette.swift
//  TTS Voca
//
//  Created by 정지환 on 01/06/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import UIKit

class TagPalette {
    private let blue: UIColor = UIColor(red: 0.23, green: 0.45, blue: 0.95, alpha: 1.0)
    private let green: UIColor = UIColor(red: 0.17, green: 0.69, blue: 0.60, alpha: 1.0)
    private let yellow: UIColor = UIColor(red: 0.97, green: 0.75, blue: 0.12, alpha: 1.0)
    private let red: UIColor = UIColor(red: 0.98, green: 0.31, blue: 0.30, alpha: 1.0)
    private let purple: UIColor = UIColor(red: 0.63, green: 0.53, blue: 0.82, alpha: 1.0)
    
    private let badgeBlue: UIColor = UIColor(red: 0.18, green: 0.40, blue: 0.90, alpha: 1.0)
    private let badgeGreen: UIColor = UIColor(red: 0.12, green: 0.64, blue: 0.56, alpha: 1.0)
    private let badgeYellow: UIColor = UIColor(red: 0.92, green: 0.70, blue: 0.07, alpha: 1.0)
    private let badgeRed: UIColor = UIColor(red: 0.93, green: 0.26, blue: 0.25, alpha: 1.0)
    private let badgePurple: UIColor = UIColor(red: 0.58, green: 0.48, blue: 0.77, alpha: 1.0)
    
    private let buttonBlue: UIColor = UIColor(red: 0.23, green: 0.45, blue: 0.95, alpha: 1.0)
    private let buttonGreen: UIColor = UIColor(red: 0.17, green: 0.69, blue: 0.60, alpha: 1.0)
    private let buttonYellow: UIColor = UIColor(red: 0.97, green: 0.75, blue: 0.12, alpha: 1.0)
    private let buttonRed: UIColor = UIColor(red: 0.98, green: 0.31, blue: 0.30, alpha: 1.0)
    private let buttonPurple: UIColor = UIColor(red: 0.63, green: 0.53, blue: 0.82, alpha: 1.0)
    
    private let complementaryBlue: UIColor = UIColor(red: 0.23, green: 0.45, blue: 0.95, alpha: 1.0)
    private let complementaryGreen: UIColor = UIColor(red: 0.17, green: 0.69, blue: 0.60, alpha: 1.0)
    private let complementaryYellow: UIColor = UIColor(red: 0.97, green: 0.75, blue: 0.12, alpha: 1.0)
    private let complementaryRed: UIColor = UIColor(red: 0.98, green: 0.31, blue: 0.30, alpha: 1.0)
    private let complementaryPurple: UIColor = UIColor(red: 0.63, green: 0.53, blue: 0.82, alpha: 1.0)
    
    
    init() {
        
    }
    
    func getTagColor(tag: Int) -> UIColor{
        switch tag {
        case 1:
            return blue
        case 2:
            return green
        case 3:
            return yellow
        case 4:
            return red
        case 5:
            return purple
        default:
            return UIColor.black
        }
    }
    
    func getBadgeColor(tag: Int) -> UIColor{
        switch tag {
        case 1:
            return badgeBlue
        case 2:
            return badgeGreen
        case 3:
            return badgeYellow
        case 4:
            return badgeRed
        case 5:
            return badgePurple
        default:
            return UIColor.black
        }
    }
    
    func getButtonColor(tag: Int) -> UIColor {
        switch tag {
        case 1:
            return buttonBlue
        case 2:
            return buttonGreen
        case 3:
            return buttonYellow
        case 4:
            return buttonRed
        case 5:
            return buttonPurple
        default:
            return UIColor.black
        }
    }
    
    func getComplementaryColor(tag: Int) -> UIColor {
        switch tag {
        case 1:
            return complementaryBlue
        case 2:
            return complementaryGreen
        case 3:
            return complementaryYellow
        case 4:
            return complementaryRed
        case 5:
            return complementaryPurple
        default:
            return UIColor.black
        }
    }
    
    func setBackground(card: UIView, tag: Int) {
//        card.roundCorners(radius: 10)
        card.layer.cornerRadius = 10 // 원래 6 -> 10
        
        var color: UIColor!
        switch tag {
        case 1:
            color = blue
            break
        case 2:
            color = green
            break
        case 3:
            color = yellow
            break
        case 4:
            color = red
            break
        case 5:
            color = purple
            break
        default:
            break
        }
        card.backgroundColor = color
    }

    func getBlue() -> UIColor {
        return blue
    }
    func getGreen() -> UIColor {
        return green
    }
    func getYellow() -> UIColor {
        return yellow
    }
    func getRed() -> UIColor {
        return red
    }
    func getPurple() -> UIColor {
        return purple
    }
    func getBadgeBlue() -> UIColor {
        return badgeBlue
    }
    func getBadgeGreen() -> UIColor {
        return badgeGreen
    }
    func getBadgeYellow() -> UIColor {
        return badgeYellow
    }
    func getBadgeRed() -> UIColor {
        return badgeRed
    }
    func getBadgePurple() -> UIColor {
        return badgePurple
    }
}
