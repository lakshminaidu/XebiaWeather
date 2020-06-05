//
//  WeatherView.swift
//  XebiaWeatherApp
//
//  Created by Lakshminaidu on 04/06/2020.
//  Copyright © 2020 Lakshminaidu. All rights reserved.
//

import UIKit

class WeatherView: UIView {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - ViewModel
    var viewModel: WeatherResponseViewModel? {
        didSet {
            timeLabel.text = viewModel?.timeString
            locationLabel.text = viewModel?.location
            descriptionLabel.text = viewModel?.description
            minTemperatureLabel.text = "Min: " + (viewModel?.mintemp ?? "")
            maxTemperatureLabel.text = "Max: " + (viewModel?.maxTemp ?? "")
            windSpeedLabel.text = "WindSpeed: \(viewModel?.windSpeed ?? "")" + " m/s"
        }
        
    }
    
    func loadViewModel(_ viewModel: WeatherResponseViewModel?) {
        self.viewModel = viewModel
    }
    
    
}
