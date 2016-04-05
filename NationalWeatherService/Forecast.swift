//
//  Forecast.swift
//  NationalWeatherService
//
//  Created by Adam Aldous on 3/22/16.
//  Copyright © 2016 Adam Aldous. All rights reserved.
//

import Foundation

class Forecast {
    
    static let kCityName = "productionCenter"
    static let kBasicDescription = "weather"
    static let kDetailDescription = "text"
    static let kImageString = "iconLink"
    static let KDay = "startPeriodName"
    static let kTemp = "temperature"
    
    static let kCurrentImageString = "Weatherimage"
    static let kCurrentBasicDescription = "Weather"
    static let kCurrentTemp = "Temp"
    static let kLastUpdated = "Date"
    static let kObservationName = "name"
    static let kHumidity = "Relh"
    static let kVisibility = "Visibility"
    static let kWindChill = "WindChill"
    static let kBarometer = "SLP"
    static let kDewpoint = "Dewp"
    static let kWindSpeed = "Winds"
    static let kWindDirection = "Windd"
    
    //    static let kHighTemp = "name"
    //    static let kLowTemp = ""
    
    lazy var selected: [Bool] = self.basicDescription.map({_ in false })
    
    var cityName = ""
    var basicDescription: [String] = []
    var detailDescription: [String] = []
    var imageString: [String] = []
    var day: [String] = []
    var temp: [String] = []
    
    var currentConditionsSelected = false
    var currentImageString: String = ""
    var currentBasicDescription: String = ""
    var currentTemp: String = ""
    var lastUpdated: String = ""
    var observationName: String = ""
    var humidity: String = ""
    var visibility: String = ""
    var windChill: String = ""
    var barometer: String = ""
    var dewpoint: String = ""
    var windSpeed: String = ""
    var windDirectionDegrees: String = ""
    var direction: Int {
        if let direction = Int(windDirectionDegrees) {
        return direction
        } else {
            return 0
        }
    }
    
    var windDirection: String {
        switch (direction) {
            
        case direction where (direction > 337) || (direction <= 22):
            return "N"
        case direction where (direction > 22) && (direction <= 67):
            return "NE"
        case direction where (direction > 67) && (direction <= 112):
            return "E"
        case direction where (direction > 112) && (direction <= 157):
            return "SE"
        case direction where (direction > 157) && (direction <= 202):
            return "S"
        case direction where (direction > 202) && (direction <= 247):
            return "SW"
        case direction where (direction > 247) && (direction <= 292):
            return "W"
        case direction where (direction > 292) && (direction <= 337):
            return "NW"
        default:
            return "-"
        }
    }
    
    //    var highTemp: [Int] = []
    //    var lowTemp: [Int] = []
    
    init?(jsonDictionary: [String : AnyObject]) {
        
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
            lastUpdated = currentobservation[Forecast.kLastUpdated] as? String,
            observationName = currentobservation[Forecast.kObservationName] as? String,
            humidity = currentobservation[Forecast.kHumidity] as? String,
            visibility = currentobservation[Forecast.kVisibility] as? String,
            windChill = currentobservation[Forecast.kWindChill] as? String,
            barometer = currentobservation[Forecast.kBarometer] as? String,
            dewpoint = currentobservation[Forecast.kDewpoint] as? String,
            windSpeed = currentobservation[Forecast.kWindSpeed] as? String,
            windDirectionDegrees = currentobservation[Forecast.kWindDirection] as? String {
            
            self.basicDescription = basicDescription
            self.detailDescription = detailDescription
            self.imageString = imageString
            self.temp = temp
            
            self.currentImageString = currentImageString
            self.currentBasicDescription = currentBasicDescription
            self.currentTemp = currentTemp
            self.lastUpdated = lastUpdated
            self.observationName = observationName
            self.humidity = humidity
            self.visibility = visibility
            self.windChill = windChill
            self.barometer = barometer
            self.dewpoint = dewpoint
            self.windSpeed = windSpeed
            self.windDirectionDegrees = windDirectionDegrees
        }
        
        if let time = jsonDictionary["time"] as? [String: AnyObject],
            day = time[Forecast.KDay] as? [String] {
            
            self.day = day
        }
    }
}









