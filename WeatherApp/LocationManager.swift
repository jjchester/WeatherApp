//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Justin Chester on 2020-09-24.
//  Copyright © 2020 Justin Chester. All rights reserved.
//

import Foundation
import CoreLocation


class LocationManager: NSObject {
    weak var delegate: LocationManagerDelegate?
    
    private let locationManager = CLLocationManager()
    
    public var exposedLocation: CLLocation? {
        return self.locationManager.location
    }
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .notDetermined:
                print("notDetermined")
            case .authorizedWhenInUse:
                print("authorizedWhenInUse")
            case .authorizedAlways:
                print("authorizedAlways")
            case .restricted:
                print("restricted")
            case .denied:
                print("denied")
            @unknown default:
                print("Unknown")
            }
    }
}

extension LocationManager {
    
    func getPlace(for location: CLLocation, completion: @escaping (CLPlacemark?) -> Void) {

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
}

protocol LocationManagerDelegate: AnyObject {
    func updateLocationLabel(_ location: String);
}
