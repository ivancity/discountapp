//
//  MapViewCoordinator.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import UIKit

class MapViewCoordinator: Coordinator {
    private let viewModel: MapViewModel
    private let mapVC: DiscountMapViewController
    
    init(placesModel: PlacesModel) {
        viewModel = MapViewModel(placesModel: placesModel)
        mapVC = DiscountMapViewController(viewModel: viewModel)
    }
    
    func start() -> UIViewController {
        return mapVC
    }
}
