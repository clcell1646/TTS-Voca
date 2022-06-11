//
//  TTSLanguageConverter.swift
//  TTS Voca
//
//  Created by 정지환 on 28/05/2019.
//  Copyright © 2019 Jihwan Jung. All rights reserved.
//

import Foundation

class TTSData {
    private let languagesToShow = [
        "🇸🇦 Arabic (Saudi Arabia)",
        "🇨🇳 Chinese (China)",
        "🇭🇰 Chinese (Hong Kong SAR China)",
        "🇹🇼 Chinese (Taiwan)",
        "🇨🇿 Czech (Czech Republic)",
        "🇩🇰 Danish (Denmark)",
        "🇧🇪 Dutch (Belgium)",
        "🇳🇱 Dutch (Netherlands)",
        "🇦🇺 English (Australia)",
        "🇮🇪 English (Ireland)",
        "🇿🇦 English (South Africa)",
        "🇬🇧 English (United Kingdom)",
        "🇺🇸 English (United States)",
        "🇫🇮 Finnish (Finland)",
        "🇨🇦 French (Canada)",
        "🇫🇷 French (France)",
        "🇩🇪 German (Germany)",
        "🇬🇷 Greek (Greece)",
        "🇮🇳 Hindi (India)",
        "🇭🇺 Hungarian (Hungary)",
        "🇮🇩 Indonesian (Indonesia)",
        "🇮🇹 Italian (Italy)",
        "🇯🇵 Japanese",
        "🇰🇷 Korean",
        "🇳🇴 Norwegian",
        "🇵🇱 Polish",
        "🇧🇷 Portuguese (Brazil)",
        "🇵🇹 Portuguese (Portugal)",
        "🇷🇴 Romanian (Romania)",
        "🇷🇺 Russian (Russia)",
        "🇸🇰 Slovak (Slovakia)",
        "🇲🇽 Spanish (Mexico)",
        "🇪🇸 Spanish (Spain)",
        "🇸🇪 Swedish (Sweden)",
        "🇹🇭 Thai (Thailand)",
        "🇹🇷 Turkish (Turkey)"
    ]
    private let languages = [
        "Arabic (Saudi Arabia)",
        "Chinese (China)",
        "Chinese (Hong Kong SAR China)",
        "Chinese (Taiwan)",
        "Czech (Czech Republic)",
        "Danish (Denmark)",
        "Dutch (Belgium)",
        "Dutch (Netherlands)",
        "English (Australia)",
        "English (Ireland)",
        "English (South Africa)",
        "English (United Kingdom)",
        "English (United States)",
        "Finnish (Finland)",
        "French (Canada)",
        "French (France)",
        "German (Germany)",
        "Greek (Greece)",
        "Hindi (India)",
        "Hungarian (Hungary)",
        "Indonesian (Indonesia)",
        "Italian (Italy)",
        "Japanese (Japan)",
        "Korean (South Korea)",
        "Norwegian (Norway)",
        "Polish (Poland)",
        "Portuguese (Brazil)",
        "Portuguese (Portugal)",
        "Romanian (Romania)",
        "Russian (Russia)",
        "Slovak (Slovakia)",
        "Spanish (Mexico)",
        "Spanish (Spain)",
        "Swedish (Sweden)",
        "Thai (Thailand)",
        "Turkish (Turkey)"
    ]
    private let codes = [
        "ar-SA",
        "zh-CN",
        "zh-HK",
        "zh-TW",
        "cs-CZ",
        "da-DK",
        "nl-BE",
        "nl-NL",
        "en-AU",
        "en-IE",
        "en-ZA",
        "en-GB",
        "en-US",
        "fi-FI",
        "fr-CA",
        "fr-FR",
        "de-DE",
        "el-GR",
        "hi-IN",
        "hu-HU",
        "id-ID",
        "it-IT",
        "ja-JP",
        "ko-KR",
        "no-NO",
        "pl-PL",
        "pt-BR",
        "pt-PT",
        "ro-RO",
        "ru-RU",
        "sk-SK",
        "es-MX",
        "es-ES",
        "sv-SE",
        "th-TH",
        "tr-TR"
    ]
    /// NAVER DICTIONARY ////////////////////////////////////////////////////////////////////////////////////
    /// NAVER DICTIONARY ////////////////////////////////////////////////////////////////////////////////////
    /// NAVER DICTIONARY ////////////////////////////////////////////////////////////////////////////////////
    private let naverDicPrefix = [
        "https://dict.naver.com/arkodict/#/search?query=", // Arabic (Saudi Arabia)
        "https://zh.dict.naver.com/#/search?query=", // Chinese (China)
        "https://zh.dict.naver.com/#/search?query=", // Chinese (Hong Kong SAR China)
        "https://zh.dict.naver.com/#/search?query=", // Chinese (Taiwan)
        "https://dict.naver.com/cskodict/#/search?query=", // Czech (Czech Republic)
        "none", // Danish (Denmark)
        "none", // Dutch (Belgium)
        "https://dict.naver.com/nlkodict/dutch/#/search?query=", // Dutch (Netherlands)
        "https://endic.naver.com/search.nhn?searchOption=all&query=", // English (Australia)
        "https://endic.naver.com/search.nhn?searchOption=all&query=", // English (Ireland)
        "https://endic.naver.com/search.nhn?searchOption=all&query=", // English (South Africa)
        "https://endic.naver.com/search.nhn?searchOption=all&query=", // English (United Kingdom)
        "https://endic.naver.com/search.nhn?searchOption=all&query=", // English (United States)
        "https://dict.naver.com/fikodict/finnish/#/search?query=", // Finnish (Finland)
        "https://dict.naver.com/frkodict/french/#/search?query=", // French (Canada)
        "https://dict.naver.com/frkodict/french/#/search?query=", // French (France)
        "https://dict.naver.com/dekodict/deutsch/#/search?query=", // German (Germany)
        "https://dict.naver.com/elkodict/moderngreek/#/search?query=", // Greek (Greece)
        "https://dict.naver.com/hikodict/hindi/#/search?query=", // Hindi (India)
        "https://dict.naver.com/hukodict/hungarian/#/search?query=", // Hungarian (Hungary)
        "https://dict.naver.com/idkodict/indonesian/#/search?query=", // Indonesian (Indonesia)
        "https://dict.naver.com/itkodict/italian/#/search?query=", // Italian (Italy)
        "https://ja.dict.naver.com/search.nhn?range=all&q=", // Japanese (Japan)
        "https://ko.dict.naver.com/#/search?query=", // Korean (South Korea)
        "none", // Norwegian (Norway)
        "https://dict.naver.com/plkodict/polish/#/search?query=", // Polish (Poland)
        "https://dict.naver.com/ptkodict/portuguese/#/search?query=", // Portuguese (Brazil)
        "https://dict.naver.com/ptkodict/portuguese/#/search?query=", // Portuguese (Portugal)
        "https://dict.naver.com/rokodict/romanian/#/search?query=", // Romanian (Romania)
        "https://dict.naver.com/rukodict/russian/#/search?query=", // Russian (Russia)
        "none", // Slovak (Slovakia)
        "https://dict.naver.com/eskodict/espanol/#/search?query=", // Spanish (Mexico)
        "https://dict.naver.com/eskodict/espanol/#/search?query=", // Spanish (Spain)
        "https://dict.naver.com/svkodict/swedish/#/search?query=", // Swedish (Sweden)
        "https://dict.naver.com/thkodict/thai/#/search?query=", // Thai (Thailand)
        "https://dict.naver.com/trkodict/turkish/#/search?query=" // Turkish (Turkey)
    ]
    //    ["https://dict.naver.com/arkodict/#/search?query=word&=",
    private let naverDicSuffix = [
        "", // Arabic (Saudi Arabia)
        "", // Chinese (China)
        "", // Chinese (Hong Kong SAR China)
        "", // Chinese (Taiwan)
        "", // Czech (Czech Republic)
        "", // Danish (Denmark)
        "", // Dutch (Belgium)
        "", // Dutch (Netherlands)
        "&=", // English (Australia)
        "&=", // English (Ireland)
        "&=", // English (South Africa)
        "&=", // English (United Kingdom)
        "&=", // English (United States)
        "", // Finnish (Finland)
        "", // French (Canada)
        "", // French (France)
        "", // German (Germany)
        "", // Greek (Greece)
        "", // Hindi (India)
        "&range=all", // Hungarian (Hungary)
        "", // Indonesian (Indonesia)
        "", // Italian (Italy)
        "&sm=jpd_hty", // Japanese (Japan)
        "", // Korean (South Korea)
        "", // Norwegian (Norway)
        "", // Polish (Poland)
        "", // Portuguese (Brazil)
        "", // Portuguese (Portugal)
        "", // Romanian (Romania)
        "", // Russian (Russia)
        "", // Slovak (Slovakia)
        "", // Spanish (Mexico)
        "", // Spanish (Spain)
        "", // Swedish (Sweden)
        "", // Thai (Thailand)
        "" // Turkish (Turkey)
    ]
    /// NAVER DICTIONARY ////////////////////////////////////////////////////////////////////////////////////
    /// NAVER DICTIONARY ////////////////////////////////////////////////////////////////////////////////////
    /// NAVER DICTIONARY ////////////////////////////////////////////////////////////////////////////////////
    
    /// DAUM DICTIONARY /////////////////////////////////////////////////////////////////////////////////////
    /// DAUM DICTIONARY /////////////////////////////////////////////////////////////////////////////////////
    /// DAUM DICTIONARY /////////////////////////////////////////////////////////////////////////////////////
    private let daumDicPrefix = [
        "https://dic.daum.net/search.do?q=", // Arabic (Saudi Arabia)
        "https://dic.daum.net/search.do?q=", // Chinese (China)
        "https://dic.daum.net/search.do?q=", // Chinese (Hong Kong SAR China)
        "https://dic.daum.net/search.do?q=", // Chinese (Taiwan)
        "https://dic.daum.net/search.do?q=", // Czech (Czech Republic)
        "none", // Danish (Denmark)
        "none", // Dutch (Belgium)
        "https://alldic.daum.net/search.do?q=", // Dutch (Netherlands)
        "https://alldic.daum.net/search.do?q=", // English (Australia)
        "https://alldic.daum.net/search.do?q=", // English (Ireland)
        "https://alldic.daum.net/search.do?q=", // English (South Africa)
        "https://alldic.daum.net/search.do?q=", // English (United Kingdom)
        "https://alldic.daum.net/search.do?q=", // English (United States)
        "none", // Finnish (Finland)
        "https://dic.daum.net/search.do?q=", // French (Canada)
        "https://dic.daum.net/search.do?q=", // French (France)
        "none", // German (Germany)
        "none", // Greek (Greece)
        "https://dic.daum.net/search.do?q=", // Hindi (India)
        "https://dic.daum.net/search.do?q=", // Hungarian (Hungary)
        "https://dic.daum.net/search.do?q=", // Indonesian (Indonesia)
        "https://dic.daum.net/search.do?q=", // Italian (Italy)
        "https://dic.daum.net/search.do?q=", // Japanese (Japan)
        "https://dic.daum.net/search.do?q=", // Korean (South Korea)
        "none", // Norwegian (Norway)
        "https://dic.daum.net/search.do?q=", // Polish (Poland)
        "https://dic.daum.net/search.do?q=", // Portuguese (Brazil)
        "https://dic.daum.net/search.do?q=", // Portuguese (Portugal)
        "https://dic.daum.net/search.do?q=", // Romanian (Romania)
        "https://dic.daum.net/search.do?q=", // Russian (Russia)
        "none", // Slovak (Slovakia)
        "none", // Spanish (Mexico)
        "none", // Spanish (Spain)
        "https://dic.daum.net/search.do?q=", // Swedish (Sweden)
        "https://dic.daum.net/search.do?q=", // Thai (Thailand)
        "https://dic.daum.net/search.do?q=" // Turkish (Turkey)
    ]
    private let daumDicSuffix = [
        "&dic=ar", // Arabic (Saudi Arabia)
        "&dic=ch", // Chinese (China)
        "&dic=ch", // Chinese (Hong Kong SAR China)
        "&dic=ch", // Chinese (Taiwan)
        "&dic=cs", // Czech (Czech Republic)
        "", // Danish (Denmark)
        "", // Dutch (Belgium)
        "&dic=nl", // Dutch (Netherlands)
        "&dic=eng", // English (Australia)
        "&dic=eng", // English (Ireland)
        "&dic=eng", // English (South Africa)
        "&dic=eng", // English (United Kingdom)
        "&dic=eng", // English (United States)
        "", // Finnish (Finland)
        "&dic=fr", // French (Canada)
        "&dic=fr", // French (France)
        "", // German (Germany)
        "", // Greek (Greece)
        "&dic=hi", // Hindi (India)
        "&dic=hu", // Hungarian (Hungary)
        "&dic=id", // Indonesian (Indonesia)
        "&dic=it", // Italian (Italy)
        "&dic=jp", // Japanese (Japan)
        "&dic=kor", // Korean (South Korea)
        "", // Norwegian (Norway)
        "&dic=pl", // Polish (Poland)
        "&dic=pt", // Portuguese (Brazil)
        "&dic=pt", // Portuguese (Portugal)
        "&dic=ro", // Romanian (Romania)
        "&dic=ru", // Russian (Russia)
        "", // Slovak (Slovakia)
        "", // Spanish (Mexico)
        "", // Spanish (Spain)
        "&dic=sv", // Swedish (Sweden)
        "&dic=th", // Thai (Thailand)
        "&dic=tr" // Turkish (Turkey)
    ]
    /// DAUM DICTIONARY /////////////////////////////////////////////////////////////////////////////////////
    /// DAUM DICTIONARY /////////////////////////////////////////////////////////////////////////////////////
    /// DAUM DICTIONARY /////////////////////////////////////////////////////////////////////////////////////

    func getLanguage() -> [String] {
        return languages
    }
    
    func getLanguageToShow() -> [String] {
        return languagesToShow
    }
    
    func getCodes() -> Array<String> {
        return codes
    }
    
    // show to lang
    func StoL(languageToShow: String) -> String {
        var i: Int = 0
        for langToShow in languagesToShow {
            if(langToShow == languageToShow) {
                return languages[i]
            }
            i += 1
        }
        return "nil"
    }
    // lang to show
    func LtoS(language: String) -> String {
        var i: Int = 0
        for lang in languages {
            if(lang == language) {
                return languagesToShow[i]
            }
            i += 1
        }
        return "nil"
    }
    
    // lang to code
    func LtoC(language: String) -> String {
        var i: Int = 0
        for lang in languages {
            if(lang == language) {
                return codes[i]
            }
            i += 1
        }
        return "nil"
    }
    
    // code to lang
    func CtoL(code: String) -> String {
        var i: Int = 0
        for co in codes {
            if(co == code) {
                return languages[i]
            }
            i += 1
        }
        return "nil"
    }
    
    func getNaverDictionary(language: String) -> Dictionary {
        var i: Int = 0
        for lang in languages {
            if(lang == language) {
                break
            }
            i += 1
        }
        let dict = Dictionary()
        dict.setTitle(title: "사전검색")
        dict.prefix = naverDicPrefix[i]
        dict.suffix = naverDicSuffix[i]
        return dict
    }
    
    func getDaumDictionary(language: String) -> Dictionary {
        var i: Int = 0
        for lang in languages {
            if(lang == language) {
                break
            }
            i += 1
        }
        let dict = Dictionary()
        dict.setTitle(title: "사전검색")
        dict.prefix = daumDicPrefix[i]
        dict.suffix = daumDicSuffix[i]
        return dict
    }
    
    func StoN(languageToShow: String) -> Int {
        var i: Int = 0
        for langToShow in languagesToShow {
            if(langToShow == languageToShow) {
                return i
            }
            i += 1
        }
        return -1
    }
    
    func LtoN(language: String) -> Int {
        var i: Int = 0
        for lang in languages {
            if(lang == language) {
                return i
            }
            i += 1
        }
        return -1
    }
}
