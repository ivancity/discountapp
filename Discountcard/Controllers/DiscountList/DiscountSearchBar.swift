//
//  DiscountSearchBar.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import UIKit

class DiscountSearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundImage = UIColor.generateImage(with: .sunflowerYellow)
        backgroundColor = .sunflowerYellow
        placeholder = localizedString("SEARCH_LOCATION_HINT")
        tintColor = .gunmetal
        
        let button = UIBarButtonItem.appearance(whenContainedInInstancesOf: [type(of: self)])
        button.title = localizedString("CLOSE")
        button.tintColor = .gunmetal
    }
}
