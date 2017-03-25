//
//  NSObject+Extensions.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import Foundation

extension NSObject {
    
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
