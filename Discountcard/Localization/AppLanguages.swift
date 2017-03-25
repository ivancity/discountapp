//
//  AppLanguages.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import Foundation

private let discountCardAppLanguageKey = "discountCardAppLanguageKey"

enum AppLanguage: String {
    case en = "en"
    case et = "et"
    
    static var current: AppLanguage {
        guard let saved = UserDefaults.standard.string(forKey: discountCardAppLanguageKey),
            let currentLang = AppLanguage(rawValue: saved) else {
                return .en
        }
        return currentLang
    }
}

class LanguageManager {
    
    static let shared = LanguageManager()
    var language = AppLanguage.current
    
    func set(language: AppLanguage) {
        UserDefaults.standard.set(language.rawValue, forKey: discountCardAppLanguageKey)
        self.language = language
    }
}
