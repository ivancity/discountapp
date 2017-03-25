//
//  UIApplication+Extension.swift
//  Discountcard
//
//  Created by test on 07/11/16.
//  Copyright © 2016 Mooncascade Ou. All rights reserved.
//

import UIKit

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
