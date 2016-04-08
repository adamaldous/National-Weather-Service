//
//  ForecastTableViewCell.swift
//  NationalWeatherService
//
//  Created by Adam Aldous on 3/22/16.
//  Copyright © 2016 Adam Aldous. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var forecastImage: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var basicDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var forecastBackgroundImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.forecastBackgroundImage.layer.cornerRadius = 8
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

   // func updateWith(
}