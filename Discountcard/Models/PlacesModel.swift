//
//  PlacesModel.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import Foundation
import CoreLocation

protocol PlacesModelDelegate: class {
    func didChange(places: [Place])
    func didChange(_ location: CLLocation?)
    func didSelectItem(_ id: Int?)
    func didChange(text: String, segment: Int)
}

class PlacesModel {
    var delegates = MulticastDelegate<PlacesModelDelegate>()
    private var placesFilter: PlacesFilter
    
    var places: [Place] = []  {
        didSet {
            delegates.invoke { [weak self] vm in
                if let places = self?.places {
                    vm.didChange(places: places)
                }
            }
        }
    }
    
    var latestLoation: CLLocation? {
        didSet {
            delegates.invoke { [weak self] vm in
                if let latestLoation = self?.latestLoation {
                    vm.didChange(latestLoation)
                }
            }
        }
    }
    
    var selectedItem: Int? {
        didSet {
            delegates.invoke { [weak self] vm in
                vm.didSelectItem(self?.selectedItem)
            }
        }
    }
    
    var allPlaces: [Place] {
        return placesFilter.places
    }
    
    init(places: [Place]) {
        self.places = places
        placesFilter = PlacesFilter(items: places)
        sortAlphabetically()
    }
    
    func newSearch(text: String, segment: Int) {
        places = placesFilter.filterBy(searchText: text, typeId: segment)
        delegates.invoke { vm in
            vm.didChange(text: text, segment: segment)
        }
    }
    
    func findItem(by id: Int) -> Place? {
        return placesFilter.findItem(by: id)
    }
    
    func sortAlphabetically() {
        places = placesFilter.sortAlphabetically()
    }
    
    func findArrayIndex(by id: Int) -> Int? {
        guard let index = findIndexInArray(id, places) else {
            return nil
        }
        return index
    }
    
    func findArrayIndex(by id: Int, with array: [Place]) -> Int? {
        guard let index = findIndexInArray(id, array) else {
            return nil
        }
        return index
    }
    
    private func findIndexInArray(_ id: Int, _ array: [Place]) -> Int? {
        for (index, place) in array.enumerated() {
            if place.id == id {
                return index
            }
        }
        return nil
    }
    
    func getCoordinates(of placeId: Int) -> CLLocationCoordinate2D? {
        guard let place = findItem(by: placeId),
            let lat = Double(place.location.latitude),
            let lng = Double(place.location.longitude)
            else {
                return nil
        }
        return CLLocationCoordinate2D( latitude: lat, longitude: lng)
    }
    
    func sortPlaces(by location: CLLocation, with array: [Place]) -> [Place] {
        return placesFilter
            .sortByDistance(places: array, to: location)
    }
    
    func sortAlphabetically(this places: [Place]) -> [Place] {
        return placesFilter.sortAlphabetically(array: places)
    }
    
    func distanceFrom(myLocation: CLLocation, to coordinate: CLLocation) -> Double {
        return placesFilter.distanceFrom(myLocation: myLocation, to: coordinate)
    }
    
    func cloneData() -> [Place]{
        var arrayCopy: [Place] = []
        guard places.count > 0 else {
            return arrayCopy
        }
        
        for place in places {
            arrayCopy.append(place.copy() as! Place)
        }
        return arrayCopy
    }
}
