//
//  TableViewModel.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import UIKit
import Foundation
import CoreLocation

protocol TableViewModelViewDelegate: class {
    func reloadContents()
    func updateSegmentUI(searchText: String, segment: Int)
    
    func closeItem(at indexPath: IndexPath)
    func openItem(at indexPath: IndexPath)
    
    func selectRow(at indexPath: IndexPath)
    func deSelectRow(at indexPath: IndexPath)
    
    func setButton(enabled: Bool)
    
    func showRecommendedConfirmAction(title: String?, message: String, completion: ((Bool) -> Void)?)
    func showPlaceRecommendedAlert(title: String?, message: String)
}

protocol TableViewModelCoordinatorDelegate: class {
    func openMapViewTab()
}

protocol ListViewModel {
    associatedtype Value
    func numberOfSections() -> Int
    func numberOfRowsInSection(in section: Int) -> Int
    func row(at indexPath: IndexPath) -> Value
}

class TableViewModel {
    
    enum Row {
        case place(Place)
        case description(Place)
    }

    weak var viewDelegate: TableViewModelViewDelegate?
    weak var coordinatorDelegate: TableViewModelCoordinatorDelegate?

    var hasResults: Bool { return places.count > 0 }
    var noResultText: String? {
        if(placesModel.allPlaces.isEmpty) {
            return localizedString("LIST_EMPTY")
        }
        if(!placesModel.allPlaces.isEmpty && placesModel.places.isEmpty) {
            return localizedString("NO_RESULTS")
        }
        return nil
    }

    fileprivate let placesModel: PlacesModel
    fileprivate var places: [Place] = []
    fileprivate var currentSelectedIndexPath: IndexPath?

    init(placesModel: PlacesModel) {
        self.placesModel = placesModel
        places = placesModel.places
        placesModel.delegates.add(self)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sortAlphabetically),
            name: .sortAlphabetically,
            object: nil
        )
    }

    func selectRow(at indexPath: IndexPath) {
        if let current = currentSelectedIndexPath,
            current == indexPath {
            placesModel.selectedItem = nil
        } else {
            let place = places[indexPath.row]
            placesModel.selectedItem = place.id
        }
    }

    fileprivate func closeRow() {
        if let current = currentSelectedIndexPath,
            places.count - 1 > current.row {
            places.remove(at: current.row)
            currentSelectedIndexPath = nil
            viewDelegate?.closeItem(at: current.next)
        }
    }

    fileprivate func correctIndexPath(for indexPath: IndexPath) -> IndexPath {
        if let current = currentSelectedIndexPath {
            if current.row < indexPath.row {
                return indexPath.previous
            }
        }
        return indexPath
    }

    fileprivate func openRow(at indexPath: IndexPath) {
        let corrected = correctIndexPath(for: indexPath)
        closeRow()
        currentSelectedIndexPath = corrected
        places.insert(places[corrected.row], at: corrected.row)
        viewDelegate?.openItem(at: corrected.next)
        viewDelegate?.selectRow(at: corrected)
    }

    fileprivate func handleSelectedPlace(by id: Int?) {
        if let id = id,
            let index = placesModel.findArrayIndex(by: id, with: places) {
            openRow(at: IndexPath(row: index, section: 0))
        } else {
            if let currentSelectedIndexPath = currentSelectedIndexPath {
                viewDelegate?.deSelectRow(at: currentSelectedIndexPath)
            }
            closeRow()
        }
    }
    
    fileprivate func sortPlaces(by location: CLLocation?) {
        guard let location = location else {
            return
        }
        places = placesModel.sortPlaces(by: location, with: places)
        viewDelegate?.reloadContents()
    }
    
    @objc private func sortAlphabetically() {
        places = placesModel.sortAlphabetically(this: places)
        viewDelegate?.reloadContents()
    }
    
    func openMapViewTab() {
        coordinatorDelegate?.openMapViewTab()
    }
    
    func recommendPlace(name: String) {
        guard !name.isEmpty else {
            return
        }
        viewDelegate?.setButton(enabled: false)

        viewDelegate?.showRecommendedConfirmAction(
            title: localizedString("RECOMMEND"),
            message: name + localizedString("RECOMMEND_MESSAGE"))
        { [weak self] result in
            if result {
                NetworkRequestManager.postRecommendation(name: name) {
                    [weak self] (ServerResponse) in
                    self?.viewDelegate?.setButton(enabled: true)
                    if ServerResponse.error != nil {
                        self?.viewDelegate?.showPlaceRecommendedAlert(
                            title: nil,
                            message: localizedString("TRY_AGAIN"))
                        return
                    }
                    self?.viewDelegate?.showPlaceRecommendedAlert(
                        title: localizedString("RECOMMEND"),
                        message: localizedString("SUGGESTION_SENT"))
                }
            } else {
                self?.viewDelegate?.setButton(enabled: true)
            }
        }
    }
}

extension TableViewModel: ListViewModel {
    func numberOfSections() -> Int {
        return 1
    }

    func numberOfRowsInSection(in section: Int) -> Int {
        return places.count
    }

    func row(at indexPath: IndexPath) -> Row {
        if let current = currentSelectedIndexPath,
            indexPath == current.next {
            return .description(places[indexPath.row])
        }
        return .place(places[indexPath.row])
    }
}

extension TableViewModel: SegmentedSearchViewDelegate {
    func updateSearch(searchText: String, forSegment: Int) {
        placesModel.newSearch(text: searchText, segment: forSegment)
        currentSelectedIndexPath = nil
    }
}

extension TableViewModel: PlacesModelDelegate {
    func didChange(places: [Place]) {
        self.places = places
        
        if SortingManager.currentSorting == SettingsPlaceSort.locationBased {
            sortPlaces(by: placesModel.latestLoation)
        }
        
        viewDelegate?.reloadContents()
    }    

    func didChange(_ location: CLLocation?) {
        sortPlaces(by: location)
    }
    
    func didSelectItem(_ id: Int?) {
        handleSelectedPlace(by: id)
    }
    
    func didChange(text: String, segment: Int) {
        viewDelegate?.updateSegmentUI(searchText: text, segment: segment)
    }
}
