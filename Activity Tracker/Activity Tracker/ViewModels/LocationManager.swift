//
//  LocationManager.swift
//  Activity Tracker
//
//  Created by luu van on 3/3/22.
//

import CoreLocation
import CoreLocationUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    @Published var location: CLLocation? {
        didSet {
            if let location = location {
                lookUpPlaces(at: location) { [weak self] place in
                    self?.placemark = place
                }
            }
        }
    }
    
    @Published var placemark: CLPlacemark?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestLocation() {
        placemark = nil
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func resetLocation() {
        location = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
    
    func lookUpPlaces(at location: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void ) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location,
                                        completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                completionHandler(firstLocation)
            }
            else {
                completionHandler(nil)
            }
        })
    }
}
