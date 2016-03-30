//
//  LocationController.swift
//  NationalWeatherService
//
//  Created by Adam Aldous on 3/29/16.
//  Copyright © 2016 Adam Aldous. All rights reserved.
//

import Foundation
import CoreLocation

class LocationController {
        
    private let kLocations = "locations"
    
    var locations: [Location]
    
    init() {
        
        self.locations = []
        
//        locations.append(location1)
//        locations.append(location2)
//        locations.append(location3)
//        
//        self.saveToPersistentStorage()
        
        self.loadFromPersistentStorage()
    }
    
    func addLocation(location: Location) {
        
        locations.append(location)
        
        self.saveToPersistentStorage()
    }
    
    func removeLocation(location: Location) {
        
        if let locationIndex = locations.indexOf(location) {
            locations.removeAtIndex(locationIndex)
            self.saveToPersistentStorage()
        }
    }
    
    func loadFromPersistentStorage() {
        
        if let locationDictionaries = NSUserDefaults.standardUserDefaults().objectForKey(kLocations) as? [[String: AnyObject]] {
        
            self.locations = locationDictionaries.flatMap({Location(dictionary: $0)})
        }
    }
    
    func saveToPersistentStorage() {
        
        let locationDictionaries = self.locations.map({$0.dictionaryCopy})
        
        NSUserDefaults.standardUserDefaults().setObject(locationDictionaries, forKey: kLocations)
    }
}