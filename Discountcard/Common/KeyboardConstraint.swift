//
//  KeyboardConstraint.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import UIKit

class KeyboardConstraint:  NSLayoutConstraint {
    
    var offset: CGFloat = 0.0
    var onChange: ((Bool) -> Void)?
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        let value = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        if let h = (value as? CGRect)?.height {
            let height = h - offset
            constant = height
            onChange?(true)
            animateContraint()
        }
    }
 
    @objc private func keyboardWillHide(notification: Notification) {
        constant = 0
        onChange?(false)
        animateContraint()
    }
    
    private func animateContraint() {
        UIView.animate(withDuration: 0.3, animations: {
            self.secondItem?.superview??.layoutIfNeeded()
        })
    }
}

extension NSLayoutConstraint {
    convenience init(firstItem: Any, firstAttribute: NSLayoutAttribute = .bottom, secondItem: Any, secondAttribute: NSLayoutAttribute = .bottom) {
        self.init(item: firstItem, attribute: firstAttribute, relatedBy: .equal, toItem: secondItem, attribute: secondAttribute, multiplier: 1, constant: 0)
    }
}
