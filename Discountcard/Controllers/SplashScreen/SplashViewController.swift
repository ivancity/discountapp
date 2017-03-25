//
//  SplashViewController.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import UIKit
import SwiftyJSON

class SplashViewController: UIViewController {
    
    //  MARK: Properties
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    private let viewModel: SplashViewModel
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.viewDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .gunmetal
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
}

extension SplashViewController: SplashViewModelViewDelegate {
    func displayError(message: String) {
        present(
            UIAlertController(message: message),
            animated: true)
    }
}


