//
//  LanguageViewModel.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//
import Foundation

class LanguageViewModel: SettingsOptionListViewModel  {

    private typealias Data = (lang: AppLanguage, title: String)
    
    private let data: [Data] = [
        (.en, localizedString("LANGUAGE_ENG")),
        (.et, localizedString("LANGUAGE_EST"))
    ]
    
    weak var viewDelegate: SettingsViewModelViewDelegate?
    
    func controllerTitle() -> String {
        return localizedString("TITLE_LANGUAGE")
    }

    func numberOfSections() -> Int {
        return 1
    }

    func numberOfRows(in section: Int) -> Int {
        return data.count
    }

    func title(at indexPath: IndexPath) -> String {
        return data[indexPath.row].title
    }

    func subtitle(at indexPath: IndexPath) -> String? {
        return nil
    }

    func isSelected(at indexPath: IndexPath) -> Bool? {
        return LanguageManager.shared.language == data[indexPath.row].lang
    }

    func didSelectRow(at indexPath: IndexPath) {
        LanguageManager.shared.set(language: data[indexPath.row].lang)
        NotificationCenter.default.post(
            name: .languageChange,
            object: nil
        )
    }
}
