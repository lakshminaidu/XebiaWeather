//
//  WeatherResponseViewModel.swift
//  XebiaWeatherApp
//
//  Created by Lakshminaidu on 04/06/2020.
//  Copyright © 2020 Lakshminaidu. All rights reserved.
//

import Foundation

//MARK: WeatherResponseViewModel
struct WeatherResponseViewModel {
    
    let city: String
    let country: String
    let timeString: String
    let mintemp: String
    let maxTemp: String
    let location: String
    var description: String?
    var windSpeed: String?
    
    
    init(with resonseModel: WeatherResponse) {
        city = resonseModel.name ?? ""
        country = resonseModel.sys.country ?? ""
        location = city + ", " + country
        mintemp = Temperature(country: country, openWeatherMapDegrees: resonseModel.main.tempMin).degrees
        maxTemp = Temperature(country: country, openWeatherMapDegrees: resonseModel.main.tempMax).degrees
        timeString = ResponseDateTime(date: resonseModel.dt, timeZone: TimeZone.current).shortTime
        description = resonseModel.weather.first?.weatherDescription
        windSpeed = "\(resonseModel.wind.speed)"
    }
}



struct Temperature {
    let degrees: String
    
    init(country: String, openWeatherMapDegrees: Double) {
        if country == "US" {
            degrees = String(TemperatureConverter.kelvinToFahrenheit(openWeatherMapDegrees)) + "\u{f045}"
        } else {
            degrees = String(TemperatureConverter.kelvinToCelsius(openWeatherMapDegrees)) + "\u{f03c}"
        }
    }
}

// MARK: TemperatureConverter

struct TemperatureConverter {
    
    // Convert from K to C (Integer)
    static func kelvinToCelsius(_ degrees: Double) -> Double {
        return round(degrees - 273.15)
    }
    
    // Convert from K to F (Integer)
    static func kelvinToFahrenheit(_ degrees: Double) -> Double {
        return round(degrees * 9 / 5 - 459.67)
    }
    
    // Convert from F to C (Integer)
    static func fahrenheitToCelsius(fahrenheit:Int) ->Int {
        let celsius = (fahrenheit - 32) * 5 / 9
        return celsius as Int
    }
    
    // Convert from C to F (Integer)
    static func celsiusToFahrenheit(celsius:Int) ->Int {
        let fahrenheit = (celsius * 9/5) + 32
        return fahrenheit as Int
    }
    
}

// MARK: TemperatureConverter
// Response Date time
struct ResponseDateTime {
    let rawDate: Double
    let timeZone: TimeZone
    
    init(date: Double, timeZone: TimeZone) {
        self.timeZone = timeZone
        self.rawDate = date
    }
    
    var shortTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "h:mm a"
        let date = Date(timeIntervalSince1970: rawDate)
        return dateFormatter.string(from: date)
    }
}
