//
//  Location.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import Foundation

class Location{
    
    var id: Int
    var latitude: String
    var longitude: String
    var phone: String?
    var city: String?
    var streetName: String?
    var streetNumber: String?
    
    init(id: Int, latitude: String, longitude: String, phone: String?, city: String?, streetName: String?, streetNumber: String?) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.phone = phone
        self.city = city
        self.streetName = streetName
        self.streetNumber = streetNumber
    }
}
