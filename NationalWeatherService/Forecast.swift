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
    static let kDetailDescription = "text"
    static let kImageString = "iconLink"
    static let KDate = "startPeriodName"
    static let kTemp = "temperature"
    static let kHighTemp = "name"
    static let kLowTemp = ""
    
    var cityName = ""
    var basicDescription: [String] = []
    var detailDescription: [String] = []
    var imageString: [String] = []
    var date: [String] = []
    var temp: [String] = []
    var highTemp: [Int] = []
    var lowTemp: [Int] = []
    
    init(jsonDictionary: [String : AnyObject]) {
        
        if let cityName = jsonDictionary[Forecast.kCityName] as? String {
            self.cityName = cityName
        }
        
        if let data = jsonDictionary["data"] as? [String: AnyObject],
            basicDescription = data[Forecast.kBasicDescription] as? [String],
            detailDescription = data[Forecast.kDetailDescription] as? [String],
            imageString = data[Forecast.kImageString] as? [String],
            temp = data[Forecast.kTemp] as? [String] {
            
            self.basicDescription = basicDescription
            self.detailDescription = detailDescription
            self.imageString = imageString
            self.temp = temp
        }
        
        if let time = jsonDictionary["time"] as? [String: AnyObject],
            date = time[Forecast.KDate] as? [String] {
            
            self.date = date
        }
    }
}