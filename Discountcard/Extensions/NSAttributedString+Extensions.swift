//
//  NSAttributedString+Extensions.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import UIKit

extension NSAttributedString {
    static func attributedString(text: String, lineSpacing: CGFloat) -> NSAttributedString? {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        return NSAttributedString(string: text,
                                  attributes: [
                                    NSParagraphStyleAttributeName: paragraphStyle
            ])
    }
}
