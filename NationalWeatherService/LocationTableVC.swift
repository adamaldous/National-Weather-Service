//
//  LocationTableVC.swift
//  NationalWeatherService
//
//  Created by Adam Aldous on 3/28/16.
//  Copyright © 2016 Adam Aldous. All rights reserved.
//

import UIKit
import CoreLocation

class LocationTableVC: UITableViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    var locations: [Location] = []
    
//    var location0: Location {
//        get {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.startUpdatingLocation()
//            
//            return Location(name: "Current Location", location: CLLocation(latitude: 40.6561, longitude: -111.835))
//
//        }
//    }
    let location1 = Location(name: "Home", location: CLLocation(latitude: 40.6561, longitude: -111.835))
    let location2 = Location(name: "Snowbird", location: CLLocation(latitude: 40.5819, longitude: -111.6544))
    let location3 = Location(name: "Palm Springs", location: CLLocation(latitude: 33.8285, longitude: -116.5067))
    
    internal var selectedLocation: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locations = [location1, location2, location3]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else {
//            print("No location")
//            locationHandler?(location: nil)
//            return
//        }
//        location0 = location
//    }
//    
//    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//        print("Location request failed with error: \(error)")
//        locationHandler?(location: nil)
//    }

    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = locations[indexPath.row].name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedLocation = locations[indexPath.row]
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
