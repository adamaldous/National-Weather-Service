//
//  ForecastTableVC.swift
//  NationalWeatherService
//
//  Created by Adam Aldous on 3/22/16.
//  Copyright © 2016 Adam Aldous. All rights reserved.
//

import UIKit

class ForecastTableVC: UITableViewController {
    
    var selectedIndexes: [Int] = []
    
    var forecast: Forecast?
    
    var latLon: String = ""
    
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        ForecastController.getWeather("lat=40.6561&lon=-111.835") { (result) -> Void in
            guard let result = result else { return }
            self.forecast = result
            
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
                
                cell.backgroundColor = UIColor.NWSBlue()
                
                cell.currentTempLabel.text = forecast.currentTemp
                cell.currentTempLabel.text = forecast.currentTemp
                cell.lastUpdatedLabel.text = forecast.lastUpdated
                
                cell.currentWeatherImage.image = UIImage(named: "Location")
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
                    cell.backgroundColor = UIColor.whiteColor()
                    cell.tempLabel.textColor = UIColor.blueColor()
                } else {
                    cell.backgroundColor = UIColor.NWSBlue()
                    cell.tempLabel.textColor = UIColor.redColor()
                }
                
                cell.dayLabel.text = forecast.day[indexPath.row]
                cell.basicDescriptionLabel.text = forecast.basicDescription[indexPath.row]
                cell.detailDescriptionLabel.text = forecast.detailDescription[indexPath.row]
                cell.tempLabel.text = forecast.temp[indexPath.row]
                
                ForecastController.getIcons(forecast.imageString[indexPath.row], completion: { (image) in
                    
                    dispatch_async(dispatch_get_main_queue()) { () in
                        cell.forecastImage.image = image
                    }
                    
                    
                })
            }
            
            return cell
            
        }
        
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    
    //
    //    func calculateHeightForString(inString:String) -> CGFloat {
    //        let messageString = inString
    //        let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(19.0)]
    //        let attrString:NSAttributedString? = NSAttributedString(string: messageString, attributes: attributes)
    //        let rect:CGRect = attrString!.boundingRectWithSize(CGSizeMake(300.0,CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context:nil )//hear u will get nearer height not the exact value
    //        let requredSize:CGRect = rect
    //        return requredSize.height  //to include button's in your tableview
    //
    //    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? ForecastTableViewCell,
            forecast = forecast {
            tableView.beginUpdates()
            forecast.selected[indexPath.row] = !forecast.selected[indexPath.row]
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.endUpdates()
            //tableView.reloadData()
            
        }
    }
    
    //    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    //        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? ForecastTableViewCell {
    //
    //            tableView.beginUpdates()
    //            //            for index in selectedIndexes {
    //            //                if indexPath.row == index {
    //            //                    selectedIndexes.removeAtIndex(index)
    //            //                }
    //            //            }
    //            selectedIndexes = selectedIndexes.filter{$0 != indexPath.row}
    //
    //            tableView.endUpdates()
    //            //            cell.detailDescriptionLabel.numberOfLines = 1
    //            //            cell.detailDescriptionLabel.hidden = true
    //        }
    //    }
    //
    
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
