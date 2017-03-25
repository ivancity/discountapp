//
//  SortingViewModel.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import Foundation
import CoreLocation

protocol SortingViewModelCoordinatorDelegate: class {
    func didUpdateSorting()
}

class SortingViewModel: SettingsOptionListViewModel {
    
    private typealias Data = (sortMethod: SettingsPlaceSort, title: String)
    
    private let data: [Data] = [
        (.alphabetically, localizedString("SORTING_ALPHABETICAL")),
        (.locationBased, localizedString("SORTING_LOCATION"))
    ]
    
    weak var coordinatorDelegate: SortingViewModelCoordinatorDelegate?
    weak var viewDelegate: SettingsViewModelViewDelegate?
    
    func controllerTitle() -> String {
        return localizedString("TITLE_SORTING")
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

    func subtitle(at indexPath: IndexPath) -> String? { return nil }

    func isSelected(at indexPath: IndexPath) -> Bool? {
        return SortingManager.currentSorting == data[indexPath.row].sortMethod
    }

    func didSelectRow(at indexPath: IndexPath) {
        let sortMethod = data[indexPath.row].sortMethod
        switch sortMethod {
        case .locationBased:
            if !CLLocationManager.locationServicesEnabled() ||
                CLLocationManager.authorizationStatus() == .denied {
                SortingManager.set(sorting: .alphabetically)
                NotificationCenter.default.post(name: .sortAlphabetically, object: nil)
                //User disabled from Settings the location services for this app
                viewDelegate?.showAlert( message: localizedString("ERROR_ENABLE_LOCATION"))
                { [weak self] in
                    self?.popController()
                }
                return
            }
            NotificationCenter.default.post(name: .sortLocationChange, object: nil)
        default:
            NotificationCenter.default.post(name: .sortAlphabetically, object: nil)
        }
        SortingManager.set(sorting: sortMethod)
        popController()
    }

    private func popController() {
        coordinatorDelegate?.didUpdateSorting()
        viewDelegate?.reloadData()
    }
}
