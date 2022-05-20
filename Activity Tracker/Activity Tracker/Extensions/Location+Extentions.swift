//
//  Location+Extentions.swift
//  Activity Tracker
//
//  Created by luu van on 5/20/22.
//

import CoreLocation

extension CLLocation {
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

extension CLPlacemark {
    var descriptiveName: String? {
        var result = ""
        
        if let name = name {
            result = result + name + "\n"
        }
        
        if let city = locality {
            result = result + city
        }
        
        if let postalCode = postalCode {
            result = result + ", " +  postalCode
        }
        
        if let country = country {
            result = result + ", " + country
        }
        
        return result == "" ? nil : result
    }
}

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    print(lhs, rhs)
    return (lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude)
}
