//
//  PlacesManager.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import Foundation
import SwiftyJSON

class PlacesManager {
    
    var placesArray = [Place]()
    private let fileName = "cache.places"
    
    
    init(data: Data?) {
        let json: JSON
        if let raw = data {
            json = JSON(data: raw)
            savePlacesToFile(data: raw)
        }
        else {
            json = readPlacesFromFile()
        }
        var id = 0
        
        let places = json["places"].arrayValue
        for place in places {
            let placeName = place["name"].stringValue
            let placeID = place["id"].intValue
            let placeTypeID = place["type_id"].stringValue
            let locations = place["location"].arrayValue
            let descriptionEst = place["desc_est"].stringValue
            let descriptionEng = place["desc_eng"].stringValue
            let facebook = place["facebook"].stringValue
            let homepage = place["homepage"].stringValue
            
            for location in locations{
                let locationID = location["id"].intValue
                let locationLatitude = location["lat"].stringValue
                let locationLongitude = location["lon"].stringValue
                let phone = location["phone"].stringValue
                let city = location["city"].stringValue
                let streetName = location["street_name"].stringValue
                let streetNumber = location["street_number"].stringValue
                let openingTimes = OpeningTime(json: location["opening_time"])
                
                let locationObject = Location(id: locationID, latitude: locationLatitude, longitude: locationLongitude, phone: phone, city: city, streetName: streetName, streetNumber: streetNumber)
                
                let placeObject = Place(id: id, name: placeName, placeID: placeID, typeID: Int(placeTypeID)!, location: locationObject, openingTimes: openingTimes, descriptionEng: descriptionEng, descriptionEst: descriptionEst, facebook: facebook, homepage: homepage)
                placesArray.append(placeObject)
                id += 1
            }
        }
    }
    
    func savePlacesToFile(data: Data?) {
        if let toSave = data {
            FileManager.saveToFile(to: fileName, data: toSave)
        }
    }
    
    func readPlacesFromFile() -> JSON {
        if let data = FileManager.readFromFile(from: fileName) {
            return JSON(data: data)
        }
        return JSON("")
    }
    
}
