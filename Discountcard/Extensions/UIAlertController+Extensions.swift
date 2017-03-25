//
//  UIAlertController+Extensions.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import Foundation
import UIKit

extension UIAlertController {
    convenience init(title: String? = localizedString("OOPS"),
                     message: String?,
                     okTappedHandler: (() -> Void)? = nil)
    {
        self.init(title: title,
                  message: message,
                  preferredStyle: UIAlertControllerStyle.alert)
        addAction(UIAlertAction(title: localizedString("OK"),
                                     style: UIAlertActionStyle.default) { action in
                okTappedHandler?()
            })
    }
}
