///Users/mc_test/Development/discountcard-ios/Discountcard.xcodeproj
//  SettingsViewCoordinator.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import UIKit

class SettingsViewCoordinator: Coordinator {
    
    fileprivate let navController: UINavigationController
    fileprivate let mainVC: SettingOptionViewController
    fileprivate let langVc = SettingOptionViewController(viewModel: LanguageViewModel())
    fileprivate let sortVC: SettingOptionViewController
    
    init() {
        let mainViewModel = SettingsMainViewModel()
        let sortViewModel = SortingViewModel()
        mainVC = SettingOptionViewController(viewModel: mainViewModel)
        sortVC = SettingOptionViewController(viewModel: sortViewModel)
        navController = UINavigationController(rootViewController: mainVC)
        
        mainViewModel.coordinatorDelegate = self
        sortViewModel.coordinatorDelegate = self
    }
    
    func start() -> UIViewController {
        return navController
    }
    
    private func setupNavController() {
        navController.navigationBar.barStyle = .black
        navController.navigationBar.barTintColor = .sunflowerYellow
        navController.navigationBar.tintColor = .gunmetal
    }
}

extension SettingsViewCoordinator: SettingsMainViewModelCoordinatorDelegate {
    func showLanguageOptions() {
        navController.pushViewController(langVc, animated: true)
    }
    func showSortingOptions() {
        navController.pushViewController(sortVC, animated: true)
    }
}

extension SettingsViewCoordinator: SortingViewModelCoordinatorDelegate {
    func didUpdateSorting() {
        navController.popViewController(animated: true)
        if let mainController = navController.topViewController as? SettingOptionViewController {
            mainController.reloadData()
        }
    }
}
