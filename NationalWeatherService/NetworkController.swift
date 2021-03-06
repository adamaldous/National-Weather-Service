//
//  NetworkController.swift
//  NationalWeatherService
//
//  Created by Adam Aldous on 3/22/16.
//  Copyright © 2016 Adam Aldous. All rights reserved.
//

import Foundation

class NetworkController {
    
//    private static let API_KEY = "4e63f48bb2d090d7fb7d80f6447ace6a"
    
    static let baseURL = "http://forecast.weather.gov/MapClick.php?"
    
    static func getURL(latLon: String) -> NSURL {
        
        return NSURL(string: baseURL + latLon + "&FcstType=json")!
    }
    
    static func getIconURL(imageString: String) -> NSURL {
        return NSURL(string: imageString)!
    }
    
    static func dataAtURL(url: NSURL, completion:(resultData: NSData?) -> Void) {
        let session = NSURLSession.sharedSession()
        
        let dataTask = session.dataTaskWithURL(url) { (data, _, error) -> Void in
            
            guard let data = data else {
                print(error?.localizedDescription)
                completion(resultData: nil)
                return
            }
            
            completion(resultData: data)
        }
        
        dataTask.resume()
    }
}