//
//  UIImage+Extensions.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import UIKit

extension UIImage {

    func setTintColor(_ color: UIColor) -> UIImage? {
        let curr = withRenderingMode(.alwaysOriginal)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        curr.draw(in: CGRect(origin: .zero, size: size))

        defer { UIGraphicsEndImageContext() }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
