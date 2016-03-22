//
//  Forecast.swift
//  NationalWeatherService
//
//  Created by Adam Aldous on 3/22/16.
//  Copyright © 2016 Adam Aldous. All rights reserved.
//

import Foundation
import UIKit

class Forecast {
    
    static let kCityName = "productionCenter"
    static let kBasicDescription = "weather"
    static let kDetailDescription = "description"
    static let kImageString = "icon"
    static let KDate = "creationDateLocal"
    static let kHighTemp = "name"
    static let kLowTemp = ""
    
    var cityName = ""
    var basicDescription = ""
    var detailDescription = ""
    var imageString = ""
    var date = ""
    var highTemp = 0
    var lowTemp = 0
    
    init(jsonDictionary: [String : AnyObject]) {
        
        if let cityName = jsonDictionary[Forecast.kCityName] as? String {
            self.cityName = cityName
        }
        
        if let data = jsonDictionary["data"] as? [String: AnyObject], weatherArray = data[Forecast.kBasicDescription] as? [String] {
            if let basicDescription = weatherArray[0] as? String {
                self.basicDescription = basicDescription
            }
        }
    }
}