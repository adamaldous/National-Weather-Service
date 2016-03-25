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
    
    static let kCurrentImageString = "Weatherimage"
    static let kCurrentBasicDescription = "Weather"
    static let kCurrentTemp = "Temp"
    static let kLastUpdated = "Date"
    
    //    static let kHighTemp = "name"
    //    static let kLowTemp = ""
    
    lazy var selected: [Bool] = self.basicDescription.map({_ in false })
    var cityName = ""
    var basicDescription: [String] = []
    var detailDescription: [String] = []
    var imageString: [String] = []
    var date: [String] = []
    var temp: [String] = []
    
    var currentImageString: String = ""
    var currentBasicDescription: String = ""
    var currentTemp: String = ""
    var lastUpdated: String = ""
    
    //    var highTemp: [Int] = []
    //    var lowTemp: [Int] = []
    
    init(jsonDictionary: [String : AnyObject]) {
        
        if let cityName = jsonDictionary[Forecast.kCityName] as? String {
            self.cityName = cityName
        }
        
        if let data = jsonDictionary["data"] as? [String: AnyObject],
            basicDescription = data[Forecast.kBasicDescription] as? [String],
            detailDescription = data[Forecast.kDetailDescription] as? [String],
            imageString = data[Forecast.kImageString] as? [String],
            temp = data[Forecast.kTemp] as? [String],
            
            currentobservation = jsonDictionary["currentobservation"] as? [String: AnyObject],
            currentImageString = currentobservation[Forecast.kCurrentImageString] as? String,
            currentBasicDescription = currentobservation[Forecast.kCurrentBasicDescription] as? String,
            currentTemp = currentobservation[Forecast.kCurrentTemp] as? String,
            lastUpdated = currentobservation[Forecast.kLastUpdated] as? String {
            
            self.basicDescription = basicDescription
            self.detailDescription = detailDescription
            self.imageString = imageString
            self.temp = temp
            
            self.currentImageString = currentImageString
            self.currentBasicDescription = currentBasicDescription
            self.currentTemp = currentTemp
            self.lastUpdated = lastUpdated
        }
        
        if let time = jsonDictionary["time"] as? [String: AnyObject],
            date = time[Forecast.KDate] as? [String] {
            
            self.date = date
        }
    }
}









