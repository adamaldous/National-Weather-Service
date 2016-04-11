//
//  LocationTableVC.swift
//  NationalWeatherService
//
//  Created by Adam Aldous on 3/28/16.
//  Copyright © 2016 Adam Aldous. All rights reserved.
//

import UIKit
import CoreLocation

class LocationTableVC: UITableViewController, CLLocationManagerDelegate, LocationControllerDelegate {
    
    var delegate : whenCellSelected? = nil
    
    
    var location0: Location? {
        get {
            if let locationDictionary = NSUserDefaults.standardUserDefaults().objectForKey("myLocation") as? [String: AnyObject],
                latitude = locationDictionary["lat"] as? CLLocationDegrees,
                longitude = locationDictionary["lon"] as? CLLocationDegrees ,
                name = locationDictionary["name"] as? String {
                return Location(name: name, location:CLLocation(latitude: latitude, longitude: longitude))
            } else {
                return nil
            }
        }
        set {
            if let location = newValue {
                let locationDictionary = location.dictionaryCopy
                NSUserDefaults.standardUserDefaults().setObject(locationDictionary, forKey: "myLocation")
            } else {
                NSUserDefaults.standardUserDefaults().removeObjectForKey("myLocation")
            }
        }
    }
    
    internal var selectedLocation: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        LocationController.sharedController.delegate = self
        LocationController.sharedController.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        LocationController.sharedController.loadFromPersistentStorage()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationChanged(location: CLLocation?) {
        if let location = location {
            location0 = Location(name: "My Location", location: CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        } else {
            LocationController.sharedController.locationManager.requestLocation()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        return LocationController.sharedController.locations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("myLocationCell", forIndexPath: indexPath) as! MyLocationTableViewCell
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("savedLocationsCell", forIndexPath: indexPath) as! SavedLocationsTableViewCell
            cell.savedLocationLabel.text = LocationController.sharedController.locations[indexPath.row].name
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        var selectedLocation = location0
        if indexPath.section != 0 {
            selectedLocation = LocationController.sharedController.locations[indexPath.row]
            (self.navigationController?.viewControllers.first as? ForecastTableVC)?.location = LocationController.sharedController.locations[indexPath.row]
        } else {
            selectedLocation = LocationController.sharedController.currentLocation
            (self.navigationController?.viewControllers.first as? ForecastTableVC)?.location = LocationController.sharedController.currentLocation
        }
        delegate?.locationSelected()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section != 0 {
            if editingStyle == .Delete {
                selectedLocation = LocationController.sharedController.locations[indexPath.row]
                if let location = selectedLocation {
                    LocationController.sharedController.removeLocation(location)
                    tableView.reloadData()
                }
            }
        }
    }
}

protocol whenCellSelected {
    func locationSelected()
}