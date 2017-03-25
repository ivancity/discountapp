//
//  PlacesFilter.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import Foundation
import CoreLocation
struct PlacesFilter {
    var cacheDictionary: [Int : Place] = [:]
    var places: [Place] = []
    var sortedPlaces: [Place] = []
    init(items: [Place]) {
        guard !items.isEmpty else {
            return
        }
        places = items
        for place in items {
            cacheDictionary[place.id] = place
        }
    }
    
    func findItem(by id: Int) -> Place? {
        if let place = cacheDictionary[id] {
            return place
        } 
        return nil
    }
    
    mutating func filterBy(searchText: String, typeId: Int) -> [Place]{
        sortedPlaces = places.filter {
            s in
            let typeMatch = typeId == 0 || typeId == s.typeID
            let found = typeMatch && (s.name.range(of: searchText, options: .caseInsensitive) != nil || searchText.isEmpty)
            return found
        }
        sortedPlaces = sortedPlaces.sorted(by: sortFunc)
        return sortedPlaces
    }
    
    public func sortByDistance(places: [Place], to myLocation: CLLocation?) -> [Place]{
        
        guard let myLocation = myLocation else {
            return places
        }
        
        var sortedPlaces = places
        
        sortedPlaces.sort(by: {
            distanceFrom(myLocation: myLocation, to: $0.0.location)
            < distanceFrom(myLocation: myLocation, to: $0.1.location)
        })
        return sortedPlaces
    }
    
    private func distanceFrom(myLocation: CLLocation, to location: Location) -> Double{
        guard let latitude = Double(location.latitude),
            let longitude = Double(location.longitude) else {
            return 0
        }
        
        let placeCoordinate = CLLocation(latitude: latitude,
                                         longitude: longitude)
        return myLocation.distance(from: placeCoordinate)
    }
    
    func distanceFrom(myLocation: CLLocation, to location: CLLocation)
        -> Double {
        return myLocation.distance(from: location)
    }

    mutating func sortAlphabetically() -> [Place] {
        sortedPlaces = places.sorted(by: sortFunc)
        return sortedPlaces
    }
    
    func sortAlphabetically(array: [Place]) -> [Place] {
        return array.sorted(by: sortFunc)
    }
    
    private func sortFunc(placeA: Place, placeB: Place) -> Bool {
        return placeA.name < placeB.name
    }
}
