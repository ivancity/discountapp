//
//  Notification+Extension.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import Foundation

extension Notification.Name {
    static var languageChange: Notification.Name {
        return Notification.Name("NotificationLanguageChange")
    }
    static var sortLocationChange: Notification.Name { return
        Notification.Name("NotificationSortLocationChange")
    }
    static var sortAlphabetically: Notification.Name {
        return Notification.Name("NotificationSortAlphabetically")
    }
}
