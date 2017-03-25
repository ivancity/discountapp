//
//  MapViewModel.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import Foundation
import CoreLocation
import UIKit

protocol MapViewModelDelegate: class {
    func loadPlacesToMap(places: [Place])
    func clearMapMarkers()
    func moveCamera(to coordinate: CLLocationCoordinate2D, animate: Bool)
    func moveCamera(to coordinate: CLLocationCoordinate2D, animate: Bool, zoom: Float)
    func moveCameraToArea(location: CLLocation?)
    func setMarker(at index: Int)
    func showBottomCard(place: Place)
    func hideBottomCard()
    func isCardOpen(with placeId: Int) -> Bool
    func showAlert(message: String)
    func updateSegmentUI(searchText: String, segment: Int)
}

class MapViewModel: NSObject {
    fileprivate let locationManager = CLLocationManager()
    fileprivate var isBroadcastingLocation = false
    fileprivate var latestLocation: CLLocation? = nil {
        didSet {
            guard isBroadcastingLocation else {
                return
            }
            placesModel.latestLoation = latestLocation
        }
    }
    fileprivate var placesModel: PlacesModel
    
    weak var viewDelegate: MapViewModelDelegate? {
        didSet {
            populateMap()
        }
    }
    
    init(placesModel: PlacesModel) {
        self.placesModel = placesModel
        super.init()
        initializeLocationManager()
        placesModel.delegates.add(self)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sortByLocation),
            name: .sortLocationChange, object: nil
        )
        
        if SortingManager.currentSorting == SettingsPlaceSort.locationBased{
            isBroadcastingLocation = true
        }
    }
    
    private func initializeLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
    }
    
    fileprivate func startLocationUpdates() {
        guard CLLocationManager.locationServicesEnabled() else {
            //User disabled from Settings the location services for this app
            viewDelegate?.showAlert(
                message: localizedString("ERROR_ENABLE_LOCATION"))
            handleCameraOnError()
            return
        }
        
        //start listening for location updates
        locationManager.startUpdatingLocation()
    }
    
    fileprivate func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    private func populateMap() {
        viewDelegate?.loadPlacesToMap(places: placesModel.places)
    }
    
    fileprivate func filterResultsBy(searchText: String, typeId: Int) {
        placesModel.newSearch(text: searchText, segment: typeId)
        reloadContent()
    }
    
    func distanceFrom(myLocation: CLLocation, to coordinate: CLLocation)
        -> Double {
        return placesModel.distanceFrom(myLocation: myLocation, to: coordinate)
    }
    
    func resetMap() {
        filterResultsBy(searchText: "", typeId: 0)
    }
    
    fileprivate func reloadContent() {
        viewDelegate?.clearMapMarkers()
        viewDelegate?.loadPlacesToMap(places: placesModel.places)
        viewDelegate?.moveCameraToArea(location: latestLocation)
    }
    
    func findAndShow(placeId: Int) {
        guard let viewDelegate = viewDelegate,
            !viewDelegate.isCardOpen(with: placeId) else {
            return
        }
        guard let place = placesModel.findItem(by: placeId) else {
            return
        }
        viewDelegate.showBottomCard(place: place)
    }
    
    func tapToDismiss() {
        viewDelegate?.hideBottomCard()
        broadcastSelectedItem(id: nil)
    }
    
    func tappedOn(placeId id: Int) {
        findAndShow(placeId: id)
        broadcastSelectedItem(id: id)
    }
    
    fileprivate func handleCameraOnError() {
        if let _ = latestLocation {
            return
        }
        let estoniaCoordinates = CLLocationCoordinate2D(
            latitude: Double(58.5953),
            longitude: Double(25.0136))
        viewDelegate?.moveCamera(to: estoniaCoordinates, animate: false, zoom: 6.5)
    }
    
    func goToDirection(at place: Place) {
        let location = place.location
        var url: String
        
        guard let coordinates = latestLocation?.coordinate else {
            //no current location available
            viewDelegate?.showAlert(
                message: localizedString("ERROR_ENABLE_LOCATION"))
            return
        }
        
        //always send a start coordinate it will load the direction much faster on the next app
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            //open google maps app
            url = "comgooglemaps://?saddr=" + coordinates.latitude.description + "," + coordinates.longitude.description + "&daddr=" + location.latitude + "," + location.longitude + "&zoom=15"
        } else {
            //open apple maps app
            url = "http://maps.apple.com/?saddr=" + coordinates.latitude.description + "," + coordinates.longitude.description + "&daddr=" + location.latitude + "," + location.longitude
        }
        
        if let url = URL(string: url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    
    }
    
    func broadcastSelectedItem(id: Int?) {
        placesModel.selectedItem = id
    }
    
    @objc private func sortByLocation(){
        isBroadcastingLocation = true
    }
}

extension MapViewModel: SegmentedSearchViewDelegate {
    func updateSearch(searchText: String, forSegment: Int) {
        tapToDismiss()
        filterResultsBy(searchText: searchText, typeId: forSegment)
    }
}

extension MapViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse: startLocationUpdates()
        case .denied, .notDetermined: handleCameraOnError()
        default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //trying to stop location update might cause issues with google maps sdk
        if let location = locations.last {
            if latestLocation == nil {
                viewDelegate?.moveCamera(to: location.coordinate, animate: false)
            }
            latestLocation = location
        }
    }    
}

extension MapViewModel: PlacesModelDelegate {
    func didChange(places: [Place]) {
        reloadContent()
    }
    
    func didChange(_ location: CLLocation?) {
        guard let _ = location else {
            return
        }
        isBroadcastingLocation = false
    }
    
    func didSelectItem(_ id: Int?) {
        guard let placeId = id else {
            viewDelegate?.hideBottomCard()
            return
        }
        findAndShow(placeId: placeId)
        
        guard let index = placesModel.findArrayIndex(by: placeId),
            let placeCoordinate = placesModel.getCoordinates(of: placeId) else {
            return
        }
        viewDelegate?.setMarker(at: index)
        viewDelegate?.moveCamera(to: placeCoordinate, animate: true)
    }
    
    func didChange(text: String, segment: Int) {
        viewDelegate?.updateSegmentUI(searchText: text, segment: segment)
    }
}
