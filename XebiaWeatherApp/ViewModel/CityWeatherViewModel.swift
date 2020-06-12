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
        var citiesCount = cities.count
        cities.forEach { (city) in
            requestWeather(city: city) {
                citiesCount -= 1
                if citiesCount == 0 {
                    completion(true)
                }
            }
        }
    }
    
    func requestWeather(city: String, completion: @escaping (() -> Void)) {
        WeatherService.Global.request(withURL: URL(string: WeatherAPI.with(city: city.trim()).urlEncoded!)!) { [weak self] (result: Envelope<WeatherResponse>) in
            switch result {
            case .success(let weatherResponseModel):
                let viewModel = WeatherResponseViewModel(with: weatherResponseModel)
                self?.weatherData.append(viewModel)
                completion()
            case .failure(_):
                completion()
            }
        }
    }
}

