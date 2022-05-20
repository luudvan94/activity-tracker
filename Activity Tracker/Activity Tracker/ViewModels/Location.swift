//
//  Location.swift
//  Activity Tracker
//
//  Created by luu van on 5/20/22.
//

import CoreData
import CoreLocation

extension Location: Entity {
    static var entityName = "Location"
    static var eventType = "Location"
}

extension Location {
    func configure(coordinate: CLLocationCoordinate2D, address: String? = nil, areaOfInterest: String? = nil) {
        latitute_ = coordinate.latitude
        longitude_ = coordinate.longitude
        address_ = address
        areaOfInterest_ = areaOfInterest
    }
    
    var displayingaddress: String {
        var result = ""
        if let areaOfInterest = areaOfInterest_, areaOfInterest != "" {
            result = result + areaOfInterest + "\n"
        }
        
        if let address = address_, address != "" { return result + address }
        
        return Labels.noAddressAtThisLocation
    }
    
    var coordinate: CLLocationCoordinate2D? {
        get {
            if latitute_ == 0 && longitude_ == 0 { return nil }
            return CLLocationCoordinate2D(latitude: latitute_, longitude: longitude_)
        } set {
            if let coordinate = newValue {
                latitute_ = coordinate.latitude
                longitude_ = coordinate.longitude
            }
        }
    }
}
