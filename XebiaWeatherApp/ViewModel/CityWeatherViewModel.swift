//
//  CityWeatherViewModel.swift
//  XebiaWeatherApp
//
//  Created by Lakshminaidu on 05/06/2020.
//  Copyright © 2020 Lakshminaidu. All rights reserved.
//

import Foundation

class CityWeatherViewModel {
    var cities = [String]()
    var weatherData = [WeatherResponseViewModel]()
    
    required init(cities: [String]) {
        self.cities = cities
    }
    
    
    func fetchWeather(completion: @escaping ((Bool) -> Void)) {
        let cityUrls = self.cities.map{URL(string: WeatherAPI.with(city: $0.trim()).urlEncoded!)!}
        var citiesCount = cities.count
        cityUrls.forEach { (cityApi) in
            WeatherService.Global.fetch(withURL: cityApi) { [weak self] (result: Envelope<WeatherResponse>) in
                citiesCount -= 1
                switch result {
                case .success(let weatherResponseModel):
                    let viewModel = WeatherResponseViewModel(with: weatherResponseModel)
                    self?.weatherData.append(viewModel)
                    if citiesCount == 0 {
                        completion(true)
                    }
                default: break
                }
            }
        }
    }
}

