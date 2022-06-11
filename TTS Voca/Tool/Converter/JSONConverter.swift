//
//  JSONConverter.swift
//  TTS Voca
//
//  Created by 정지환 on 04/09/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import Foundation

class JSONConverter {
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
