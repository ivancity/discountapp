//
//  Place.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import SwiftyJSON
import UIKit

class Place: NSObject, NSCopying{
    
    // MARK: Properties
    
    var id: Int
    var placeID: Int
    var name: String
    var typeID: Int
    var typeIcon: UIImage
    var location: Location
    var openingTimes: OpeningTime
    var descriptionEng: String?
    var descriptionEst: String?
    var facebook: String?
    var homepage: String?
    
    init(id: Int, name: String, placeID: Int, typeID: Int, location: Location, openingTimes: OpeningTime, descriptionEng: String?, descriptionEst: String?, facebook: String?, homepage: String?) {
        self.id = id
        self.name = name.localizedUppercase
        self.placeID = placeID
        self.typeID = typeID
        self.location = location
        self.openingTimes = openingTimes
        self.descriptionEng = descriptionEng
        self.descriptionEst = descriptionEst
        self.facebook = facebook
        self.homepage = homepage
        
        switch typeID {
        case 1:
            typeIcon = #imageLiteral(resourceName: "type_food")
        case 2:
            typeIcon = #imageLiteral(resourceName: "type_health")
        default:
            typeIcon = #imageLiteral(resourceName: "type_other")
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Place(id: id,
                         name: name,
                         placeID: placeID,
                         typeID: typeID,
                         location: location,
                         openingTimes: openingTimes,
                         descriptionEng: descriptionEng,
                         descriptionEst: descriptionEst,
                         facebook: facebook,
                         homepage: homepage)
        return copy
    }
}
