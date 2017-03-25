//
//  AppCoordinator.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//
import UIKit

class AppCoordinator: Coordinator {

    fileprivate let window: UIWindow
    fileprivate var currentCoordinator: Coordinator?
    
    init(window: UIWindow) {
        self.window = window
        NotificationCenter.default.addObserver(self, selector: #selector(appLanguageChanged), name: .languageChange, object: nil)
    }
    
    func start() -> UIViewController {
        let splashCoordinator = SplashCoordinator()
        splashCoordinator.delegate = self
        currentCoordinator = splashCoordinator
        return splashCoordinator.start()
    }
    
    @objc private func appLanguageChanged() {
        window.setRootViewController(new: start())
    }
}

extension AppCoordinator: SplashCoordinatorDelegate {
    func splashCoordinatorFinished(with places: [Place]) {
        let tabBarCoordinator = TabBarCoordinator(places: places)
        currentCoordinator = tabBarCoordinator
        window.setRootViewController(new: tabBarCoordinator.start())
    }
}
