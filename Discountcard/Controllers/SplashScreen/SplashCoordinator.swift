//
//  SplashCoordinator.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import UIKit

protocol SplashCoordinatorDelegate: class {
    func splashCoordinatorFinished(with places: [Place])
}

class SplashCoordinator: Coordinator {

    weak var delegate: SplashCoordinatorDelegate?
    
    private let splashVc: SplashViewController
    private let viewModel: SplashViewModel
    
    init() {
        viewModel = SplashViewModel()
        splashVc = SplashViewController(viewModel: viewModel)
        viewModel.coordinatorDelegate = self
    }
    
    func start() -> UIViewController {
        return splashVc
    }
}

extension SplashCoordinator: SplashViewModelCoordinatorDelegate {
    func fetchCompleted(with places: [Place]) {
        delegate?.splashCoordinatorFinished(with: places)
    }
}
