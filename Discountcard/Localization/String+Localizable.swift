//
//  String+Localizable.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import Foundation

func localizedString(_ name: String) -> String {
    return NSLocalizedString(name, tableName: nil, bundle: currentBundle(), value: "", comment: "")
}

private func currentBundle(for appLanguage: AppLanguage = LanguageManager.shared.language) -> Bundle {
    guard let path = Bundle.main.path(forResource: appLanguage.rawValue, ofType: "lproj", inDirectory: ""),
        let bundle = Bundle(path: path) else {
            return Bundle.main
    }
    return bundle
}
