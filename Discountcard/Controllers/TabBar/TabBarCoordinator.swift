//
//  TabBarCoordinator.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import UIKit
import CoreLocation

class TabBarCoordinator: Coordinator {
    
    fileprivate let tableViewCoordinator: TableViewCoordinator
    private let mapViewCoordinator: MapViewCoordinator
    private let settingsCoordinator: SettingsViewCoordinator
    private let placesModel: PlacesModel
    fileprivate let tabBar = UITabBarController()

    init(places: [Place]) {
        placesModel = PlacesModel(places: places)
        tableViewCoordinator = TableViewCoordinator(placesModel: placesModel)
        mapViewCoordinator = MapViewCoordinator(placesModel: placesModel)
        settingsCoordinator = SettingsViewCoordinator()

        tableViewCoordinator.coordinatorDelegate = self
    }

    func start() -> UIViewController {
        return tabBarController()
    }
    
    private func tabBarController() -> UITabBarController {
        
        let icon1 = UITabBarItem(
            title: localizedString("TAB_LIST"),
            image: #imageLiteral(resourceName: "tab_item_list").withRenderingMode(.alwaysOriginal),
            selectedImage: #imageLiteral(resourceName: "tab_item_list_selected")
        )
        let icon2 = UITabBarItem(
            title: localizedString("TAB_CARD"),
            image: #imageLiteral(resourceName: "tab_item_card").withRenderingMode(.alwaysOriginal),
            selectedImage: #imageLiteral(resourceName: "tab_item_card_selected")
        )
        let icon3 = UITabBarItem(
            title: localizedString("TAB_MAP"),
            image: #imageLiteral(resourceName: "tab_item_map").withRenderingMode(.alwaysOriginal),
            selectedImage: #imageLiteral(resourceName: "tab_item_map_selected")
        )
        let icon4 = UITabBarItem(
            title: localizedString("TAB_SETTINGS"),
            image: #imageLiteral(resourceName: "tab_item_settings").withRenderingMode(.alwaysOriginal),
            selectedImage: #imageLiteral(resourceName: "tab_item_settings_selected")
        )

        [icon1, icon2, icon3, icon4].forEach({
            $0.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -7)
        })

        let cardController = DiscountCardViewController(viewModel: DiscountCardViewModel())
        cardController.tabBarItem = icon2

        let tableViewVc = tableViewCoordinator.start()
        tableViewVc.tabBarItem = icon1

        let mapViewVc = mapViewCoordinator.start()
        mapViewVc.tabBarItem = icon3

        let settingsViewVc = settingsCoordinator.start()
        settingsViewVc.tabBarItem = icon4

        tabBar.tabBar.barTintColor = .sunflowerYellow
        tabBar.tabBar.tintColor = .gunmetal
        tabBar.viewControllers = [
            tableViewVc,
            mapViewVc,
            cardController,
            settingsViewVc
        ]
 
        defer {
            tabBar.viewControllers?.forEach({ _ = $0.view })
        }
        
        return tabBar
    }
}

extension TabBarCoordinator: TableViewCoordinatorCoordinatorDelegate {
    func openMapViewTab() {
        tabBar.selectedIndex = 1
    }
}
