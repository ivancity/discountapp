//
//  IndexPath+Extensions.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import Foundation

extension IndexPath {
    var next: IndexPath {
        return offset(1)
    }
    
    var previous: IndexPath {
        return offset(-1)
    }
    
    private func offset(_ by: Int) -> IndexPath {
        return IndexPath(row: row + by, section: section)
    }
}
