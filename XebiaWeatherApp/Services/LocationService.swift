//
//  LocationService.swift
//  XebiaWeatherApp
//
//  Created by Lakshminaidu on 04/06/2020.
//  Copyright © 2020 Lakshminaidu. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: class {
    func locationDidUpdate(_ service: LocationService, location: CLLocation)
    func locationDidFail(withError error: AppError)
}

class LocationService: NSObject {
    
    var delegate: LocationServiceDelegate?

    static let sharedInstance = LocationService()
    
    fileprivate let locationManager = CLLocationManager()

    private override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
        locationManager.distanceFilter = 200 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
        locationManager.delegate = self
        authorizeUser()
    }
    // MARK: Helper
    
    func authorizeUser(){
        locationManager.requestWhenInUseAuthorization()
    }
    // to start location services
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
    }

}

//MARK: CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let userLocation = locations.first else {
            return
        }
        print("Current location: \(userLocation)")
        delegate?.locationDidUpdate(self, location: userLocation)
        stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        // do on error
        delegate?.locationDidFail(withError: .unableToFindLocation)
        print("Error finding location: \(error.localizedDescription)")
    }
}
