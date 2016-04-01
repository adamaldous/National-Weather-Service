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
    let locationManager = CLLocationManager()
    var locations: [Location]
    static let sharedController = LocationController()
    var delegate: LocationControllerDelegate?
    
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
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {delegate?.locationChanged(nil); return}
        delegate?.locationChanged(location)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location request failed with error: \(error)")
        delegate?.locationChanged(nil)
    }
    
    
}

protocol LocationControllerDelegate {
    func locationChanged(location: CLLocation?)
}
