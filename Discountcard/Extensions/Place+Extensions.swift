//
//  Place+Extensions.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import Foundation

extension Place {
    var localizedDescription: String? {
        switch LanguageManager.shared.language {
        case .et: return descriptionEst ?? descriptionEng
        default: return descriptionEng ?? descriptionEst
        }
    }
    
    var formattedAddress: String {
        if location.streetName != nil
            && location.streetNumber != nil
            && location.streetName != ""
            && location.streetNumber != "" {
            return (location.streetName != nil ? location.streetName! : "")
                + " " + (location.streetNumber != nil ? location.streetNumber! : "")
                + ", " + (location.city != nil ? location.city!: "")
        }
        return ""
    }
}
