//
//  AppConstants.swift
//  XebiaWeatherApp
//
//  Created by Lakshminaidu on 04/06/2020.
//  Copyright © 2020 Lakshminaidu. All rights reserved.
//

import UIKit
import CoreLocation

// MARK: - Internal constants

internal let Token = "564799b60389a0358bade7d74899c4e6"
internal let emptyString = ""

// MARK: - AppError constants
struct AppError {
    enum Code: Int {
        case urlError                 = -6000
        case networkRequestFailed     = -6001
        case jsonSerializationFailed  = -6002
        case jsonParsingFailed        = -6003
        case unableToFindLocation     = -6004
    }
    
    let errorCode: Code
}


// MARK: - WeatherAPI constants
enum WeatherFetchType: Int {
    case userLocation = 0
    case userCity = 1
}

struct WeatherAPI {
    
    private static let iconURL = "https://openweathermap.org/img/w/"
    private static let day = "https://api.openweathermap.org/data/2.5/weather?"
    private static let forecast = "https://api.openweathermap.org/data/2.5/forecast?"
    private static let AppID = "&appid=" + Token
    
    static func with(city: String, isForecast: Bool = false) -> String {
        return  (isForecast ? WeatherAPI.forecast : WeatherAPI.day) + "q=\(city)" + WeatherAPI.AppID
    }
    
    static func with(city: String,  country: String, isForecast: Bool = false) -> String {
        return (isForecast ? WeatherAPI.forecast : WeatherAPI.day) + "q=\(city),\(country)" + WeatherAPI.AppID
        
    }
    
    static func with(lattitude lat: String, and long: String, isForecast: Bool = false) -> String {
        return (isForecast ? WeatherAPI.forecast : WeatherAPI.day) + "lat=\(lat)&lon=\(long)"  + WeatherAPI.AppID
        
    }
    
    static func with( location loc: CLLocation, isForecast: Bool = false) -> String {
        let lat = String(loc.coordinate.latitude)
        let long = String(loc.coordinate.longitude)
        return  WeatherAPI.with(lattitude: lat, and: long, isForecast: isForecast)
        
    }
    
}
