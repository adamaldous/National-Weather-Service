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
    
    var locations: [Location] = []
    
    var location0: Location? {
        get {
            if let locationDictionary = NSUserDefaults.standardUserDefaults().objectForKey("currentLocation") as? [String: AnyObject],
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
                NSUserDefaults.standardUserDefaults().setObject(locationDictionary, forKey: "currentLocation")
            } else {
                NSUserDefaults.standardUserDefaults().removeObjectForKey("location")
            }
        }
    }
    
    let location1 = Location(name: "Home", location: CLLocation(latitude: 40.6561, longitude: -111.835))
    let location2 = Location(name: "Snowbird", location: CLLocation(latitude: 40.5819, longitude: -111.6544))
    let location3 = Location(name: "Palm Springs", location: CLLocation(latitude: 33.8285, longitude: -116.5067))
    
    internal var selectedLocation: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationController.sharedController.delegate = self
        LocationController.sharedController.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        LocationController.sharedController.locationManager.requestLocation()
        self.locations = [location1, location2, location3]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationChanged(location: CLLocation?) {
        if let location = location {
            location0 = Location(name: "Current Location", location: location)
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
        return locations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("currentLocationCell", forIndexPath: indexPath)
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("savedLocationsCell", forIndexPath: indexPath)
            cell.textLabel?.text = locations[indexPath.row].name
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedLocation = location0
        if indexPath.section != 0 {
            selectedLocation = locations[indexPath.row]
        }
        (self.navigationController?.viewControllers.first as? ForecastTableVC)?.location = selectedLocation
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
