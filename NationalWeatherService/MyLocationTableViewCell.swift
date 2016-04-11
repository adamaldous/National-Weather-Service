//
//  CurrentLocationTableViewCell.swift
//  NationalWeatherService
//
//  Created by Adam Aldous on 3/31/16.
//  Copyright © 2016 Adam Aldous. All rights reserved.
//

import UIKit

class MyLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var myLocationView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.myLocationView.layer.cornerRadius = 8
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}