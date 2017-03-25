//
//  UITabBar+Extensions.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import UIKit

extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 65
        return sizeThatFits
    }
}
