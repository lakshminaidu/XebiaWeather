//
//  WeatherResponseModel.swift
//  XebiaWeatherApp
//
//  Created by Lakshminaidu on 04/06/2020.
//  Copyright © 2020 Lakshminaidu. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    var weather: [Weather]
    let main: Main
    let wind: Wind
    let dt: Double
    let sys: Sys
    var name: String?
    var dtText: String?
    
    enum CodingKeys: String, CodingKey {
        case dtText = "dt_txt"
        case name
        case weather
        case main
        case wind
        case dt
        case sys
    }
}

// MARK: - Main
struct Main: Codable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: - Sys
struct Sys: Codable {
    var country: String? = ""
}

// MARK: - Weather
struct Weather: Codable {
    let weatherDescription, icon: String
    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
}

//MARK: WeatherForcast
struct WeatherForcast: Codable {
    let cod: String
    let message, cnt: Int
    let list: [WeatherResponse]
    let city: City
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let country: String
}
