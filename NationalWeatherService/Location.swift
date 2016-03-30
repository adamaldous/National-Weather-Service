//
//  Location.swift
//  NationalWeatherService
//
//  Created by Adam Aldous on 3/25/16.
//  Copyright © 2016 Adam Aldous. All rights reserved.
//

import Foundation
import CoreLocation

class Location: Equatable {

    var name: String
    let location: CLLocation
    var latlon: String {
        return "lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)"
    }
    var dictionaryCopy: [String: AnyObject] {
        return ["name": self.name, "lat": self.location.coordinate.latitude, "lon": self.location.coordinate.longitude]
    }
    
    init(name: String, location: CLLocation) {
        
        self.name = name
        self.location = location
    }
    
    init?(dictionary: [String: AnyObject]) {
        guard let name = dictionary["name"] as? String,
            lat = dictionary["lat"] as? CLLocationDegrees,
            lon = dictionary["lon"] as? CLLocationDegrees else {return nil}
        self.name = name
        self.location = CLLocation(latitude: lat, longitude: lon)
    }
}

func == (lhs: Location, rhs: Location) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}