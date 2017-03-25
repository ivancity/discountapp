//
//  UIStoryboard+Extensions.swift
//  Discountcard
//
//  Created by test on 27/10/16.
//  Copyright © 2016 Mooncascade Ou. All rights reserved.
//

import UIKit

enum Storyboard {
    case main
    
    var board: UIStoryboard {
        switch self {
        case .main:
            return UIStoryboard(name: "Main", bundle: nil)
        }
    }
}

extension UIStoryboard {
    func instantiate<T: UIViewController>() -> T {
        return instantiateViewController(withIdentifier: T.className) as! T
    }
}


