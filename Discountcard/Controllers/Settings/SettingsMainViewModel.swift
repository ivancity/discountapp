//
//  SettingsMainViewModel.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import Foundation

protocol SettingsMainViewModelCoordinatorDelegate: class {
    func showLanguageOptions()
    func showSortingOptions()
}

class SettingsMainViewModel: SettingsOptionListViewModel {
    
    private enum SettingsTitles: Int {
        case language = 0
        case sorting = 1
    }
    
    private typealias Data = (row: SettingsTitles, title: String)
    
    private let data: [Data] = [
        (.language, localizedString("TITLE_LANGUAGE")),
        (.sorting, localizedString("TITLE_SORTING"))
    ]

    weak var coordinatorDelegate: SettingsMainViewModelCoordinatorDelegate?
    weak var viewDelegate: SettingsViewModelViewDelegate?
    
    private func currentLanguageTitle() -> String {
        switch LanguageManager.shared.language {
        case .en:
            return localizedString("LANGUAGE_ENG")
        case .et:
            return localizedString("LANGUAGE_EST")
        }
    }
    
    private func currentSortTitle() -> String {
        switch SortingManager.currentSorting {
        case .alphabetically:
            return localizedString("SORTING_ALPHABETICAL")
        case .locationBased:
            return localizedString("SORTING_LOCATION")
        }
    }
    
    func controllerTitle() -> String {
        return localizedString("TITLE_SETTINGS")
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
        switch data[indexPath.row].row {
        case .language:
            return  currentLanguageTitle()
        case .sorting:
            return currentSortTitle()
        }
    }

    func isSelected(at indexPath: IndexPath) -> Bool? {
        return nil
    }

    func didSelectRow(at indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            coordinatorDelegate?.showLanguageOptions()
        default:
            coordinatorDelegate?.showSortingOptions()
        }
    }
}
