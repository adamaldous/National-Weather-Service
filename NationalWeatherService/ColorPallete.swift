//
//  ColorPallete.swift
//  NationalWeatherService
//
//  Created by Adam Aldous on 3/29/16.
//  Copyright © 2016 Adam Aldous. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static func sunsetRedColor() -> UIColor {
        
        return UIColor(red: 0.796, green: 0.239, blue: 0.212, alpha: 1.00)
    }
    
    static func sunsetOrangeColor() -> UIColor {
        
        return UIColor(red: 198/255.0, green: 131/255.0, blue: 69/255.0, alpha: 1.00)
    }
    
    static func sunsetYellowColor() -> UIColor {
        
        return UIColor(red: 0.784, green: 0.643, blue: 0.267, alpha: 1.00)
    }
    
    static func NWSRed() -> UIColor {
        
        return UIColor(red: 0.937, green: 0.216, blue: 0.145, alpha: 1.00)
    }
    
    static func NWSBlue() -> UIColor {
        
        return UIColor(red: 0.906, green: 0.960, blue: 1.000, alpha: 1.00)
    }
    
    static func dayColorGood() -> UIColor {
        
        return UIColor(red: 0.906, green: 0.960, blue: 1.000, alpha: 1.00)
    }
    
    static func dayColor() -> UIColor {
        
        return UIColor(red: 0.882, green: 0.961, blue: 0.996, alpha: 1.00)
    }
    
    static func nightColor() -> UIColor {
        
        return UIColor(red: 0.251, green: 0.769, blue: 1.000, alpha: 1.00)
    }
}


//[UIColor colorWithRed:0.882 green:0.961 blue:0.996 alpha:1.00]//
//
//[UIColor colorWithRed:0.251 green:0.769 blue:1.000 alpha:1.00]