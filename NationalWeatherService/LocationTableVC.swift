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
    
    //    var locations: [Location] = [Location(name: "Home", location: CLLocation(latitude: 40.6561, longitude: -111.835)), Location(name: "Snowbird", location: CLLocation(latitude: 40.5819, longitude: -111.6544)), Location(name: "Palm Springs", location: CLLocation(latitude: 33.8285, longitude: -116.5067))]
    
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
                NSUserDefaults.standardUserDefaults().removeObjectForKey("currentLocation")
            }
        }
    }
    
    //    let location1 = Location(name: "Home", location: CLLocation(latitude: 40.6561, longitude: -111.835))
    //    let location2 = Location(name: "Snowbird", location: CLLocation(latitude: 40.5819, longitude: -111.6544))
    //    let location3 = Location(name: "Palm Springs", location: CLLocation(latitude: 33.8285, longitude: -116.5067))
    
    internal var selectedLocation: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //        LocationController.sharedController.locationManager.requestLocation()
        //        self.locations = [location1, location2, location3]
        
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
            location0 = Location(name: "Current Location", location: CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
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
            
            let cell = tableView.dequeueReusableCellWithIdentifier("currentLocationCell", forIndexPath: indexPath)
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("savedLocationsCell", forIndexPath: indexPath)
            cell.textLabel?.text = LocationController.sharedController.locations[indexPath.row].name
            return cell
        }
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
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            if indexPath.section != 0 {
                selectedLocation = LocationController.sharedController.locations[indexPath.row]
                if let location = selectedLocation {
                    LocationController.sharedController.removeLocation(location)
                    tableView.reloadData()
                }
            }
            
            //            let person = PersonController.sharedController.people[indexPath.row]
            //            PersonController.sharedController.removePerson(person)
            //            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            //            tableView.reloadData()
        }
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
