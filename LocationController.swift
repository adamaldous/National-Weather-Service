//
//  LocationController.swift
//  NationalWeatherService
//
//  Created by Adam Aldous on 3/29/16.
//  Copyright © 2016 Adam Aldous. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class LocationController: NSObject, CLLocationManagerDelegate {
    
    private let kLocations = "locations"
    let locationManager = CLLocationManager()
    var locations: [Location]
    var currentLocation: Location?
    static let sharedController = LocationController()
    var delegate: LocationControllerDelegate?
    var geocoder: CLGeocoder = CLGeocoder()
    
    override init() {
        self.locations = []
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LocationController.requestLocation), name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        //        self.saveToPersistentStorage()
        
        //        self.loadFromPersistentStorage()
    }
    
    func requestLocation() {
        self.locationManager.requestLocation()
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
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            self.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {delegate?.locationChanged(nil); return}
//        delegate?.locationChanged(location)
        
        self.geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print(error)
            } else {
                if let placemarks = placemarks {
                    if placemarks.count > 0 {
                        let topResult: CLPlacemark = placemarks[0]
                        if let country = topResult.country {
                            if country != "United States" {
                                return
                            }
                            self.currentLocation = Location(name: "Current Location", location: location)
                            NSNotificationCenter.defaultCenter().postNotificationName("CurrentLocationNotification", object: nil)
                        }
                    }
                }
            }
        }

        currentLocation = Location(name: "Current Location", location: location)
        NSNotificationCenter.defaultCenter().postNotificationName("CurrentLocationNotification", object: nil)
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location request failed with error: \(error)")
        delegate?.locationChanged(nil)
    }
    
    
}

protocol LocationControllerDelegate {
    func locationChanged(location: CLLocation?)
}
