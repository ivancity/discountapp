//
//  UIWindow+Extensions.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import Foundation
import UIKit

extension UIWindow {
    func setRootViewController(new viewController: UIViewController) {
        if rootViewController != nil {
            UIView.transition(with: self,
                              duration: 0.5,
                              options: [.transitionCrossDissolve,
                                        .allowAnimatedContent],
                              animations: {
                                self.rootViewController = viewController
            })
        } else {
            rootViewController = viewController
        }
    }
}
