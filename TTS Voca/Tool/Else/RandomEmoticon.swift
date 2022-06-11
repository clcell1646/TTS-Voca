//
//  RandomEmoticon.swift
//  TTS Voca
//
//  Created by 정지환 on 27/08/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import Foundation

class RandomEmoticon {
    let emoticon: [String] = [ "(ˇ⊖ˇ)",
                               "༼☯﹏☯༽",
                               "^ↀᴥↀ^",
                               "(◕ᴥ◕)",
                               "ʕ⊙ᴥ⊙ʔ",
                               "(´﹃｀)",
                               "༼ꉺɷꉺ༽",
                               "(✿ヘᴥヘ)",
                               "ʕ￫ᴥ￩　ʔ",
                               "(✿╹◡╹)",
                               "(▰∀◕)ﾉ",
                               "(人◕ω◕)",
                               "(ㆁᴗㆁ✿)",
                               "(ﾉ≧ڡ≦)",
                               "ʕ　·ᴥ·ʔ",
                               "(≖ᴗ≖✿)",
                               "(◕‿◕✿)",
                               "（๑♜д♜）",
                               "(✾♛‿♛)",
                               "(*бωб)",
                               "(ᇴ‿ฺᇴ)",
                               "(๑￫ܫ￩)",
                               "(❍ᴥ❍ʋ)",
                               "ʕ·ᴥ·　ʔ",
                               "(✪‿✪)ノ" ]
    
    func getRandom() -> String {
        let idx = Int(arc4random_uniform(UInt32(emoticon.count)))
        return emoticon[idx]
    }
    
}
