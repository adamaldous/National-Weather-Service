//
//  ForecastTableVC.swift
//  NationalWeatherService
//
//  Created by Adam Aldous on 3/22/16.
//  Copyright © 2016 Adam Aldous. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ForecastTableVC: UITableViewController, CLLocationManagerDelegate, whenCellSelected {
    
    let kCurrentWeatherImage = "http://forecast.weather.gov/newimages/medium/"
    let locationManager = LocationController.sharedController.locationManager
    var forecast: Forecast?
    var loadingView: UILabel = UILabel()
    
    var location: Location? {
        get {
            if let locationDictionary = NSUserDefaults.standardUserDefaults().objectForKey("location") as? [String: AnyObject],
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
                NSUserDefaults.standardUserDefaults().setObject(locationDictionary, forKey: "location")
            } else {
                NSUserDefaults.standardUserDefaults().removeObjectForKey("location")
            }
        }
    }
    
    func locationSelected() {
        self.forecast?.basicDescription = []
        tableView.reloadData()
    }
    
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        loadingView.font = UIFont(name: "Helvetica", size: 50)
        loadingView.textColor = UIColor.whiteColor()
        loadingView.textAlignment = .Center
        loadingView.text = "Loading..."
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ForecastTableVC.updateCurrentLocation), name: "CurrentLocationNotification", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if location != nil {
            makeNetworkCall()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.NotDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        } else if status == CLAuthorizationStatus.Denied {
            self.locationManager.requestWhenInUseAuthorization()
        } else if status == CLAuthorizationStatus.AuthorizedWhenInUse {
        }
    }
    
    func updateCurrentLocation() {
        if location == nil {
            self.location = LocationController.sharedController.currentLocation
            makeNetworkCall()
        }
    }
    
    func makeNetworkCall() {
        
        guard let location = location else {return}
        self.navigationController?.view.addSubview(loadingView)
        navigationItem.title = location.name
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        ForecastController.getWeather(location.latlon) { (result) -> Void in
            guard let result = result else { return }
            self.forecast = result
            dispatch_async(dispatch_get_main_queue()) { () in
                self.loadingView.removeFromSuperview()
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        }
    }
    
    @IBAction func userPulledRefresh(sender: AnyObject) {
        if location == nil {
            LocationController.sharedController.locationManager.requestLocation()
        } else {
            makeNetworkCall()
        }
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            if let _ = forecast {
                if forecast?.basicDescription.count > 0{
                    return 1
                }else{
                    return 0
                }
            } else {
                return 0
            }
        } else {
            if let forecast = forecast {
                return forecast.basicDescription.count
            } else {
                return 0
            }
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("currentWeatherCell", forIndexPath: indexPath) as! CurrentWeatherTableViewCell
            
            if let forecast = forecast {
                
                if forecast.currentConditionsSelected {
                    cell.currentConditionsStackView.hidden = false
                    cell.lastUpdatedLabel.hidden = false
                } else {
                    cell.currentConditionsStackView.hidden = true
                    cell.lastUpdatedLabel.hidden = true
                }
                
                cell.backgroundColor = UIColor.currrentColor()
                cell.currentTempLabel.text = "\(forecast.currentTemp)"
                cell.currentBasicDescriptionLabel.text = forecast.currentBasicDescription
                cell.windLabel.text = "Wind: \(forecast.windDirection) at \(forecast.windSpeed) MPH"
                cell.barometerLabel.text = "Barometer: \(forecast.barometer) in"
                cell.dewpointLabel.text = "Dewpoint: \(forecast.dewpoint)°F"
                cell.windChillLabel.text = "Wind Chill: \(forecast.windChill)°F"
                cell.visibilityLabel.text = "Visibility: \(forecast.visibility) mi"
                cell.humidityLabel.text = "Humidity: \(forecast.humidity)%"
                cell.lastUpdatedLabel.text = "Last Observed: \(forecast.lastUpdated) at \(forecast.observationName)"
                
                if forecast.currentImageString == "NULL" {
                    cell.currentWeatherImage.image = UIImage(named: "WeatherIcon")
                } else {
                    ForecastController.getIcon(kCurrentWeatherImage + forecast.currentImageString, completion: { (image) in
                        
                        dispatch_async(dispatch_get_main_queue()) { () in
                            cell.currentWeatherImage.image = image
                        }
                    })
                }
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("forecastCell", forIndexPath: indexPath) as! ForecastTableViewCell
            
            if let forecast = forecast {
                
                if forecast.selected[indexPath.row] {
                    cell.detailDescriptionLabel.hidden = false
                    cell.basicDescriptionLabel.hidden = true
                } else {
                    cell.detailDescriptionLabel.hidden = true
                    cell.basicDescriptionLabel.hidden = false
                }
                
                if forecast.day[indexPath.row].containsString("Tonight") || forecast.day[indexPath.row].containsString(" Night") {
                    cell.tempLabel.textColor = UIColor.blueColor()
                    //                    cell.backgroundColor = UIColor.nightColor()
                    cell.forecastBackgroundImage.backgroundColor = UIColor.nightColor()
                } else {
                    cell.tempLabel.textColor = UIColor.redColor()
                    //                    cell.backgroundColor = UIColor.dayColor()
                    cell.forecastBackgroundImage.backgroundColor = UIColor.dayColor()
                }
                
                cell.dayLabel.text = forecast.day[indexPath.row]
                cell.basicDescriptionLabel.text = forecast.basicDescription[indexPath.row]
                cell.detailDescriptionLabel.text = forecast.detailDescription[indexPath.row]
                cell.tempLabel.text = "\(forecast.temp[indexPath.row])"
                
                ForecastController.getIcon(forecast.imageString[indexPath.row], completion: { (image) in
                    
                    dispatch_async(dispatch_get_main_queue()) { () in
                        cell.forecastImage.image = image
                    }
                })
            }
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let _ = tableView.cellForRowAtIndexPath(indexPath) as? ForecastTableViewCell,
            forecast = forecast {
            tableView.beginUpdates()
            forecast.selected[indexPath.row] = !forecast.selected[indexPath.row]
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.endUpdates()
        }
        
        if let _ = tableView.cellForRowAtIndexPath(indexPath) as? CurrentWeatherTableViewCell,
            forecast = forecast {
            tableView.beginUpdates()
            forecast.currentConditionsSelected = !forecast.currentConditionsSelected
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.endUpdates()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toLocations"{
            self.refreshControl?.endRefreshing()
            let destinationVC = segue.destinationViewController as! LocationTableVC
            destinationVC.delegate = self
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
