//
//  Location.swift
//  NationalWeatherService
//
//  Created by Adam Aldous on 3/25/16.
//  Copyright © 2016 Adam Aldous. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    
    var name: String = ""
    var location: CLLocation?
    
    init(name: String, latLon: String) {
        
        self.name = name
        
    }
}