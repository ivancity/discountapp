//
//  SettingsViewModel.swift
//  Discountcard
//
//  Created by MC_test on 15/11/16.
//  Copyright © 2016 Mooncascade Ou. All rights reserved.
//

import Foundation

protocol SettingsViewModelViewViewDelegate: class {
    func realoadContents()
}

protocol SettingsViewModelViewDelegate: class {
    func didUpdateSorting()
}

class SettingsViewModel {
    weak var delegate: SettingsViewModelViewDelegate?
    weak var viewDelegate: SettingsViewModelViewViewDelegate?

    let languageViewModel = LanguageViewModel()
    
    
    let languages = [
        localizedString("LANGUAGE_EST"),
        localizedString("LANGUAGE_ENG")
    ]
    private let languageCodes = ["et", "en"]
    private var deviceLanguage = ""
    private let sortingKeys = ["SORTING_ALPHABETICAL", "SORTING_LOCATION"]
    let sortingMethods = [
        localizedString("SORTING_ALPHABETICAL"),
        localizedString("SORTING_LOCATION")
    ]
    private var currentSortingMethod: String {
        get {
            if let value = UserDefaults.standard.string(forKey: "sortingMethod") {
                return localizedString(value)
            }
            else{
                return ""
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "sortingMethod")
            UserDefaults.standard.synchronize()
        }
    }
    
    init() {
        getCurrentValues()
    }
    
    private func getCurrentValues() {
        if let index = languageCodes.index(of: LanguageManager.shared.language.rawValue) {
            deviceLanguage = languages[index]
        }
        else {
            deviceLanguage = languages[1]
        }
    }
    
    func settingsDetailText(for forRow: Int) -> String {
        switch forRow {
        case 0:
            return deviceLanguage
        case 1:
            return currentSortingMethod
        default:
            return ""
        }
    }
    
    func languageSelected(at atRow: Int) -> Bool {
        if languages[atRow] == deviceLanguage {
            return true
        }
        return false
    }
    
    func sortingSelected(at atRow: Int) -> Bool {
        if sortingMethods[atRow] == currentSortingMethod {
            return true
        }
        return false
    }
    
    func didSelectLanguage(at atRow: Int) {
        if let chosenLang = AppLanguage(rawValue: languageCodes[atRow]){
            //update deviceLanguage with new langauge selected
            deviceLanguage = languages[atRow]
            LanguageManager.shared.set(language: chosenLang)
            NotificationCenter.default.post(
                name: .languageChange,
                object: nil
            )
        }
    }
    
    func didSelectSorting(at atRow: Int) {
        currentSortingMethod = sortingKeys[atRow]
        viewDelegate?.realoadContents()
        delegate?.didUpdateSorting()
        if currentSortingMethod == "Location based" {
            NotificationCenter.default.post(
                name: .sortLocationChange,
                object: nil
            )
        } else {
            NotificationCenter.default.post(
                name: .sortAlphabetically,
                object: nil
            )
        }
    }
}
