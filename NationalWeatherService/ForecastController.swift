//
//  ForecastController.swift
//  NationalWeatherService
//
//  Created by Adam Aldous on 3/22/16.
//  Copyright © 2016 Adam Aldous. All rights reserved.
//

import Foundation

class ForecastController {
    
    static func weatherBySearchCity(city: String, completion:(result: Forecast?) -> Void) {
        
        let url = NetworkController.searchURLByCity(city)
        
        NetworkController.dataAtURL(url) { (resultData) -> Void in
            
            guard let resultData = resultData
                else {
                    print("NO DATA RETURNED")
                    completion(result: nil)
                    return
            }
            
            do {
                let weatherAnyObject = try NSJSONSerialization.JSONObjectWithData(resultData, options: NSJSONReadingOptions.AllowFragments)
                
                var weatherModelObject: Forecast?
                
                if let weatherDictionary = weatherAnyObject as? [String : AnyObject] {
                    weatherModelObject = Forecast(jsonDictionary: weatherDictionary)
                }
                
                completion(result: weatherModelObject)
                
            } catch {
                completion(result: nil)
            }
            
        }
    }
    
//    static func weatherIconForIconCode(iconCode: String, completion:(image: UIImage?) -> Void) {
//        let url = NetworkController.urlForIcon(iconCode)
//        
//        NetworkController.dataAtURL(url) { (resultData) -> Void in
//            guard let resultData = resultData
//                else {
//                    print("NO DATA RETURNED")
//                    completion(image: nil)
//                    return
//            }
//            completion(image: UIImage(data: resultData))
//        }
//    }
}