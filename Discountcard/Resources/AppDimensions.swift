//
//  AppDimensions.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import UIKit

enum AppDimensions { }

extension AppDimensions {
    enum Margins {
        case regular
        case medium
        case small
    
        var value: CGFloat {
            switch self {
            case .regular: return 20.0
            case .medium: return 15.0
            case .small: return 10.0
            }
        }
    }
}
