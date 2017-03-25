//
//  SettingsPlacesSort.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//
import Foundation

private let SettingPlacesSortKey = "SettingPlacesSortKey"

enum SettingsPlaceSort: Int {
    case alphabetically = 0
    case locationBased = 1
    
    static var current: SettingsPlaceSort {
        if let currentSort = SettingsPlaceSort(rawValue: UserDefaults.standard.integer(forKey: SettingPlacesSortKey)) {
            return currentSort
        }
        return .alphabetically
    }
}

struct SortingManager {
    static private(set) var currentSorting = SettingsPlaceSort.current
    
    static func set(sorting: SettingsPlaceSort) {
        currentSorting = sorting
        UserDefaults.standard.set(currentSorting.rawValue, forKey: SettingPlacesSortKey)
    }
}
