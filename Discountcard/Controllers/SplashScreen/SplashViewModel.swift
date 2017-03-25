//
//  SplashViewModel.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import UIKit

protocol SplashViewModelCoordinatorDelegate: class {
    func fetchCompleted(with places: [Place])
}

protocol SplashViewModelViewDelegate: class {
    func displayError(message: String)
}

class SplashViewModel {

    weak var coordinatorDelegate: SplashViewModelCoordinatorDelegate?
    weak var viewDelegate: SplashViewModelViewDelegate?
    
    init() {
        getPlaces()
    }
    
    private func getPlaces() {
        NetworkRequestManager.getPlaces{ [weak self] places in
            self?.coordinatorDelegate?.fetchCompleted(with: places)
        }
    }
}
