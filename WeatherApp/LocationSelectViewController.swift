//
//  ViewController.swift
//  WeatherApp
//
//  Created by Justin Chester on 2020-08-02.
//  Copyright © 2020 Justin Chester. All rights reserved.
//

import UIKit
import CoreLocation

class LocationSelectViewController: UIViewController, WeatherControllerDelegate, LocationManagerDelegate {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    var locationManager = LocationManager()
    var weatherController: WeatherController?
    
    var locationString: String? {
        didSet {
            self.locationLabel.text = locationString
            self.weatherController = WeatherController(locationString!)
            self.weatherController?.delegate = self
        }
    }
    
    var weatherString: String? {
        // Can't assign the label text a new value on a background thread
        didSet {
            DispatchQueue.main.async {
                self.weatherLabel.text = self.weatherString
            }
        }
    }
    
    func updateTemperatureLabel(_ temperature: String) {
        self.weatherString = temperature
    }
    
    func updateLocationLabel(_ location: String) {
        self.locationString = location
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get weather at current location
        guard let exposedLocation = self.locationManager.exposedLocation else {
            print("Error with exposedLocation fetch");
            return
        }
        //Convert weather into useful format and display
        self.locationManager.getPlace(for: exposedLocation) { placemark in
            guard let placemark = placemark else { return }
            
            var location = String()
            if let city = placemark.locality {
                location = location + "\(city), "
            }
            if let administrativeArea = placemark.administrativeArea {
                location = location + "\(administrativeArea) "
            }
            if let country = placemark.country {
                location = location + "\(country)"
            }

            self.updateLocationLabel(location);
        }
    }
}

