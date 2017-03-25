//
//  UIColor+CustomColors.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import UIKit

extension UIColor {
    static var sunflowerYellow: UIColor {
        return UIColor(colorLiteralRed: 255.0/255.0, green: 215.0/255.0, blue: 0, alpha: 1)
    }
    
    static var gunmetal: UIColor {
        return UIColor(colorLiteralRed: 85.0/255.0, green: 87.0/255.0, blue: 89.0/255.0, alpha: 1)
    }
    
    static var ceruleanBlue: UIColor {
        return UIColor(colorLiteralRed: 0, green: 127.0/255.0, blue: 235.0/255.0, alpha: 1)
    }
    
    static var whiteTwo: UIColor {
        return UIColor(colorLiteralRed: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1)
    }
    
    static var whiteThree: UIColor {
        return UIColor(colorLiteralRed: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1)
    }
    
    static var textBlack: UIColor {
        return UIColor(colorLiteralRed: 35.0/255.0, green: 33.0/255.0, blue: 33.0/255.0, alpha: 1)
    }
    
    static var textWhite: UIColor {
        return UIColor(colorLiteralRed: 253.0/255.0, green: 253.0/255.0, blue: 253.0/255.0, alpha: 1)
    }
    
    static func generateImage(with color: UIColor) -> UIImage? {
        let image = UIImage()
        let imageSize = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 1)
        color.setFill()
        image.draw(in: CGRect(origin: .zero, size: imageSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
