//
//  AppDelegate.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let appCoordinator: AppCoordinator

    override init() {
        let window = UIWindow()
        self.window = window
        appCoordinator = AppCoordinator(window: window)
        super.init()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("asdfAIzaSydsAWIMKGMy91L-Gfj4YyToOJkt9tR1asr1KERAE")

        setupAppearance()

        window?.rootViewController = appCoordinator.start()
        window?.makeKeyAndVisible()
        return true
    }
}

extension AppDelegate {
    fileprivate func setupAppearance() {
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.gunmetal], for: .selected)
    }
}
