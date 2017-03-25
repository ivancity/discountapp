//
//  DiscountMapViewController.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//
import UIKit
import GoogleMaps
import SnapKit

private let zoom: Float = 15.0
class DiscountMapViewController: UIViewController {

    fileprivate let inactiveMarker = #imageLiteral(resourceName: "inactive_indicator")
    fileprivate let activeMarker = #imageLiteral(resourceName: "active_indicator")
    fileprivate let viewModel: MapViewModel
    fileprivate let bottomCard = BottomCardView()
    fileprivate let searchHeader = SegmentedSearchView()
    fileprivate let mapView = GMSMapView()
    fileprivate let defaultRangeDistance = 9000.0
    fileprivate var markerSelected: GMSMarker? = nil
    fileprivate var markers: [GMSMarker] = []
    private var cardBottomConstraint: ConstraintMakerEditable? = nil
    private var mapViewBottomConstraint: ConstraintMakerEditable? = nil
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.viewDelegate = self
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .sunflowerYellow
        searchHeader.delegate = viewModel
        
        view.addSubview(searchHeader)
        view.addSubview(mapView)
        view.addSubview(bottomCard)
        
        searchHeader.snp.makeConstraints{ make in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(mapView.snp.top)
        }
        
        mapView.snp.makeConstraints { make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            mapViewBottomConstraint = make.bottom.equalTo(bottomLayoutGuide.snp.top)
            bottomCard.showHideConstraint = mapViewBottomConstraint
        }
        
        bottomCard.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        bottomCard.delegate = self
    }
    
    fileprivate func activateMap(_ marker: GMSMarker ) {
        //check before if there is any marker previously selected and mark as inactive
        if let previousMarker = markerSelected {
            previousMarker.icon = #imageLiteral(resourceName: "inactive_indicator")
            previousMarker.zIndex = 0
        }
        markerSelected = marker
        markerSelected?.zIndex = 1
        markerSelected?.icon = #imageLiteral(resourceName: "active_indicator")
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        hideBottomCard()
    }
}

extension DiscountMapViewController: MapViewModelDelegate {
    
    func loadPlacesToMap(places: [Place]) {
        var marker: GMSMarker
        var coordinate: CLLocationCoordinate2D
        for place in places {
            guard let latitude = Double(place.location.latitude),
                let longitude = Double(place.location.longitude) else {
                    continue
            }
            coordinate = CLLocationCoordinate2DMake(latitude,
                                                    longitude)
            marker = GMSMarker(position: coordinate)
            marker.userData = place.id
            marker.icon = inactiveMarker
            marker.opacity = 1
            marker.map = mapView
            marker.zIndex = 0
            markers.append(marker)
        }
    }
    
    func clearMapMarkers() {
        mapView.clear()
        markers.removeAll()
    }
    
    func moveCamera(to coordinate: CLLocationCoordinate2D,
                    animate: Bool = false,
                    zoom: Float = zoom) {
        let position = GMSCameraPosition(target: coordinate,
                                         zoom: zoom,
                                         bearing: 0,
                                         viewingAngle: 0)
        if animate {
            mapView.animate(to: position)
        } else {
            mapView.camera = position
        }
        
    }
    
    func moveCamera(to coordinate: CLLocationCoordinate2D, animate: Bool) {
        if !animate { moveCamera(to: coordinate) }
        else {
            moveCamera(to: coordinate, animate: animate, zoom: zoom)
        }
    }
    
    func moveCameraToArea(location: CLLocation?) {
        guard markers.count > 0 else {
            return
        }
        if let location = location {
            let inRangeMarkers = filterByDistance(at: location,
                                              this: markers,
                                              in: defaultRangeDistance)
            if inRangeMarkers.count > 1 {
                adjustBounds(with: inRangeMarkers, at: location)
            } else if inRangeMarkers.count == 1 {
                moveCamera(to: markers[0].position, animate: true)
            } else {
                //show out of range by default
                adjustBounds(with: markers, at: location)
            }
        } else {
            adjustBounds(with: markers, at: nil)
        }
    }
    
    private func adjustBounds(with targetMarkers: [GMSMarker], at location: CLLocation?) {
        let path = GMSMutablePath()
        if let location = location {
            path.add(location.coordinate)
        }
        targetMarkers.forEach({ path.add($0.position) })
        let bounds = GMSCoordinateBounds(path: path)
        mapView.animate(with: GMSCameraUpdate.fit(bounds,
                                                  withPadding: 40))
    }
    
    private func filterByDistance(at myLocation: CLLocation,
                          this markers: [GMSMarker],
                          in range: Double) -> [GMSMarker] {
        return markers.filter { marker in
            let distance = viewModel.distanceFrom(
                            myLocation: myLocation,
                            to: CLLocation(
                                latitude: marker.position.latitude,
                                longitude: marker.position.longitude))
            return distance < range
        }
    }
    
    func setMarker(at index: Int) {
        let marker = markers[index]
        activateMap(marker)
    }
    
    func showBottomCard(place: Place) {
        bottomCard.updateCard(with: place)
    }
    
    func hideBottomCard() {
        //prepare bottomCard for dismissal
        markerSelected?.icon = #imageLiteral(resourceName: "inactive_indicator")
        markerSelected = nil
        bottomCard.hideCard()
    }
    
    func isCardOpen(with placeId: Int) -> Bool {
        guard bottomCard.currentPlace?.id == placeId else{
            return false
        }
        return bottomCard.isOpen
    }
    
    func showAlert(message: String) {
        present(
            UIAlertController(message: message),
            animated: true)
    }
    
    func updateSegmentUI(searchText: String, segment: Int) {
        searchHeader.updateUIOn(text: searchText, segment: segment)
    }
}

extension DiscountMapViewController: BottomCardDelegate {
    func cardDidTapClose() {
        viewModel.tapToDismiss()
    }
    
    func directionTap(place: Place) {
        viewModel.goToDirection(at: place)
    }
}

extension DiscountMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        view.endEditing(false)
        activateMap(marker)
        let id = marker.userData as! Int
        viewModel.tappedOn(placeId: id)
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        guard bottomCard.isOpen else {
            return
        }
        viewModel.tapToDismiss()
    }
}
