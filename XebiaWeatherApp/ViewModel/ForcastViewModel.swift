//
//  ForcastViewModel.swift
//  XebiaWeatherApp
//
//  Created by Lakshminaidu on 05/06/2020.
//  Copyright © 2020 Lakshminaidu. All rights reserved.
//

import Foundation

//MARK: ForcastViewModel
class ForcastViewModel {
    
    var weatherData = [String: [WeatherResponse]]()
    var title: String = ""
    
    func grouptheData(forecastData: WeatherForcast) -> [String: [WeatherResponse]] {
        var weatherInfo = [String: [WeatherResponse]]()
        self.title = forecastData.city.name + ", " + forecastData.city.country
        let format = "yyyy-MM-dd"
        let list = forecastData.list
        let group =  Dictionary(grouping: list, by: {String($0.dtText?.prefix(format.count) ?? "")})
        let keys = group.keys.sorted()
        keys.forEach { (date) in
            weatherInfo[date] = list.filter{String($0.dtText?.prefix(format.count) ?? "") == date}
        }
        return weatherInfo
    }
    
    func fetchWeatherForcast(url: URL, completion: @escaping ((Bool) -> Void)) {
        WeatherService.Global.request(withURL: url) { [weak self] (result: Envelope<WeatherForcast>) in
            switch result {
            case .success(let forecastData):
                self?.weatherData = self?.grouptheData(forecastData: forecastData) ?? [:]
                 completion(true)
            case.failure(_):
                completion(false)
            }
        }
    }
    
}
