//
//  OpeningTime.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import Foundation
import SwiftyJSON

class OpeningTime {
    // MARK: Properties
    
    var mondayOpen: String?
    var mondayClose: String?
    var tuesdayOpen: String?
    var tuesdayClose: String?
    var wednesdayOpen: String?
    var wednesdayClose: String?
    var thursdayOpen: String?
    var thursdayClose: String?
    var fridayOpen: String?
    var fridayClose: String?
    var saturdayOpen: String?
    var saturdayClose: String?
    var sundayOpen: String?
    var sundayClose: String?
    var noData = true
    
    init(mondayOpen: String?, mondayClose: String?, tuesdayOpen: String?, tuesdayClose: String?, wednesdayOpen: String?, wednesdayClose: String?,thursdayOpen: String?, thursdayClose: String?, fridayOpen: String?, fridayClose: String?, saturdayOpen: String?, saturdayClose: String?, sundayOpen: String?, sundayClose: String?) {
        self.mondayOpen = mondayOpen
        self.mondayClose = mondayClose
        self.tuesdayOpen = tuesdayOpen
        self.tuesdayClose = tuesdayClose
        self.wednesdayOpen = wednesdayOpen
        self.wednesdayClose = wednesdayClose
        self.thursdayOpen = thursdayOpen
        self.thursdayClose = thursdayClose
        self.fridayOpen = fridayOpen
        self.fridayClose = fridayClose
        self.saturdayOpen = saturdayOpen
        self.saturdayClose = saturdayClose
        self.sundayOpen = sundayOpen
        self.sundayClose = sundayClose
    }
    
    init(json: JSON) {
        if json != nil {
            noData = false
        }
        self.mondayOpen = json["monday_open"].stringValue
        self.mondayClose = json["monday_close"].stringValue
        self.tuesdayOpen = json["tuesday_open"].stringValue
        self.tuesdayClose = json["tuesday_close"].stringValue
        self.wednesdayOpen = json["wednesday_open"].stringValue
        self.wednesdayClose = json["wednesday_close"].stringValue
        self.thursdayOpen = json["thursday_open"].stringValue
        self.thursdayClose = json["thursday_close"].stringValue
        self.fridayOpen = json["friday_open"].stringValue
        self.fridayClose = json["friday_close"].stringValue
        self.saturdayOpen = json["saturday_open"].stringValue
        self.saturdayClose = json["saturday_close"].stringValue
        self.sundayOpen = json["sunday_open"].stringValue
        self.sundayClose = json["sunday_close"].stringValue
    }
    
    func getOpenToday() -> String {
        if noData {
            return " "
        }
        let todayDate = Date()
        let calendar = NSCalendar(calendarIdentifier: .gregorian)
        let components = calendar?.components(.weekday, from: todayDate)
        let weekday = components?.weekday
        var openString = localizedString("OPEN_TODAY")
        var open: NSMutableString?
        var closed: NSMutableString?
        guard let wd = weekday else {
            return " "
        }
        switch wd {
        case 1:
            if let dayOpen = self.sundayOpen, let dayClosed = self.sundayClose, !dayOpen.isEmpty, !dayClosed.isEmpty {
                open = NSMutableString(string: dayOpen)
                closed = NSMutableString(string: dayClosed)
            }
        case 2:
            if let dayOpen = self.mondayOpen, let dayClosed = self.mondayClose {
                open = NSMutableString(string: dayOpen)
                closed = NSMutableString(string: dayClosed)
            }
        case 3:
            if let dayOpen = self.tuesdayOpen, let dayClosed = self.tuesdayClose {
                open = NSMutableString(string: dayOpen)
                closed = NSMutableString(string: dayClosed)
            }
        case 4:
            if let dayOpen = self.wednesdayOpen, let dayClosed = self.wednesdayClose, !dayOpen.isEmpty, !dayClosed.isEmpty {
                open = NSMutableString(string: dayOpen)
                closed = NSMutableString(string: dayClosed)
            }
        case 5:
            if let dayOpen = self.thursdayOpen, let dayClosed = self.thursdayClose, !dayOpen.isEmpty, !dayClosed.isEmpty {
                open = NSMutableString(string: dayOpen)
                closed = NSMutableString(string: dayClosed)
            }
        case 6:
            if let dayOpen = self.fridayOpen, let dayClosed = self.fridayClose {
                open = NSMutableString(string: dayOpen)
                closed = NSMutableString(string: dayClosed)
            }
        case 7:
            if let dayOpen = self.saturdayOpen, let dayClosed = self.saturdayClose {
                open = NSMutableString(string: dayOpen)
                closed = NSMutableString(string: dayClosed)
            }
        default:
                openString = "Closed today"
        }
        
        if let o = open, let c = closed {
            o.insert(":", at: 2)
            c.insert(":", at: 2)
            return openString + " " + (o as String) + " - " + (c as String)
        }
        return "Closed today"
    }
}
