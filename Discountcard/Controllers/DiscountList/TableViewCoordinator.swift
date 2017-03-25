//
//  TableViewCoordinator.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import UIKit

protocol TableViewCoordinatorCoordinatorDelegate: class {
    func openMapViewTab()
}

class TableViewCoordinator: Coordinator {
    weak var coordinatorDelegate: TableViewCoordinatorCoordinatorDelegate?
    fileprivate let viewModel: TableViewModel
    private let listVc: DiscountListViewController

    init(placesModel: PlacesModel) {
        viewModel = TableViewModel(placesModel: placesModel)
        listVc = DiscountListViewController(viewModel: viewModel)
        viewModel.coordinatorDelegate = self
    }
    
    func start() -> UIViewController {
        return listVc
    }
}

extension TableViewCoordinator: TableViewModelCoordinatorDelegate {
    func openMapViewTab() {
        coordinatorDelegate?.openMapViewTab()
    }
}
