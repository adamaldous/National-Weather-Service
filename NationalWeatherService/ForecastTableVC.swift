//
//  ForecastTableVC.swift
//  NationalWeatherService
//
//  Created by Adam Aldous on 3/22/16.
//  Copyright © 2016 Adam Aldous. All rights reserved.
//

import UIKit

class ForecastTableVC: UITableViewController {
    
    var mockCell:[String] = ["Today", "Tomorrow", "The next day"]
    
    var forecast: Forecast?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ForecastController.weatherBySearchCity("rrr") { (result) -> Void in
            guard let weatherResult = result else { return }
            self.forecast = weatherResult
            
            dispatch_async(dispatch_get_main_queue()) { () in
                
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
        
        return 1
        } else {
            if let cellForecast = forecast {
                return cellForecast.basicDescription.count
            } else {
                return 13
            }
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("currentWeatherCell", forIndexPath: indexPath) as! CurrentWeatherTableViewCell
        
        if let cellForecast = forecast {
            
//            cell.dateLabel.text = cellForecast.date[indexPath.row]
//            cell.basicDescriptionLabel.text = cellForecast.basicDescription[indexPath.row]
//            cell.tempLabel.text = cellForecast.temp[indexPath.row]
//            
//            cell.forecastImage.image = UIImage(named: "Location")
        }
        
        return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("forecastCell", forIndexPath: indexPath) as! ForecastTableViewCell
            
            if let cellForecast = forecast {
                
                cell.dateLabel.text = cellForecast.date[indexPath.row]
                cell.basicDescriptionLabel.text = cellForecast.basicDescription[indexPath.row]
                cell.detailDescriptionLabel.text = cellForecast.detailDescription[indexPath.row]
                cell.tempLabel.text = cellForecast.temp[indexPath.row]
                
                cell.forecastImage.image = UIImage(named: "Location")
            }
            
            return cell

        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
