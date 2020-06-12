//
//  XebiaWeatherAppTests.swift
//  XebiaWeatherAppTests
//
//  Created by Lakshminaidu on 04/06/2020.
//  Copyright © 2020 Lakshminaidu. All rights reserved.
//

import XCTest
import CoreLocation
@testable import XebiaWeatherApp

class XebiaWeatherAppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testWeatherResponseModelData() {
        let url = Bundle(for: TestProduct.self).url(forResource: "mock_city", withExtension: "json") ?? URL(fileURLWithPath: "")
        do {
            let jsonData = try Data(contentsOf: url)
            let response = try JSONDecoder().decode(WeatherResponse.self, from: jsonData)
            XCTAssertEqual("JP", response.sys.country)
            let weatherViewModel = WeatherResponseViewModel(with: response)
            XCTAssertEqual(response.sys.country, weatherViewModel.country)
            XCTAssertEqual(weatherViewModel.city, "Shuzenji")
            XCTAssertEqual(weatherViewModel.windSpeed, "\(response.wind.speed)")
            XCTAssertEqual(weatherViewModel.description, response.weather.first?.weatherDescription)
        } catch {
            XCTAssertThrowsError(error)
        }
        
    }
    
    
    func testWeatherAPIs() {
        let weatherService = WeatherServiceMock.Global

        let token = "&appid=564799b60389a0358bade7d74899c4e6"
        
        let cityURL = WeatherAPI.with(city: "xyz")
        XCTAssert(cityURL == "https://api.openweathermap.org/data/2.5/weather?q=xyz" + token, "City url is not parsed")
        weatherService.request(withURL: URL(string: cityURL)!) { (result: Envelope<WeatherResponse>) in}
        XCTAssertEqual(weatherService.session.cachedUrl?.host, "api.openweathermap.org")
        XCTAssertEqual(weatherService.session.cachedUrl!.query, "q=xyz&appid=564799b60389a0358bade7d74899c4e6")
        
        let cityURLForcast = WeatherAPI.with(city: "xyz", isForecast: true)
        XCTAssert(cityURLForcast == "https://api.openweathermap.org/data/2.5/forecast?q=xyz" + token, "City forecast url is not parsed")
        
        let cityCountryURL = WeatherAPI.with(city: "xyz", country: "xyz")
        XCTAssert(cityCountryURL == "https://api.openweathermap.org/data/2.5/weather?q=xyz,xyz" + token, "City&country url is not parsed")
        let cityCountryURLForcast = WeatherAPI.with(city: "xyz", country: "xyz", isForecast: true)
        XCTAssert(cityCountryURLForcast == "https://api.openweathermap.org/data/2.5/forecast?q=xyz,xyz" + token, "City&country forecast url is not parsed")
        
        let latlong = WeatherAPI.with(lattitude: "11.11", and: "22.22")
        XCTAssert(latlong == "https://api.openweathermap.org/data/2.5/weather?lat=11.11&lon=22.22" + token, "lanlong url is not parsed")
        let latlongForecast = WeatherAPI.with(lattitude: "11.11", and: "22.22", isForecast: true)
        XCTAssert(latlongForecast == "https://api.openweathermap.org/data/2.5/forecast?lat=11.11&lon=22.22" + token, "lanlong forecast url is not parsed")
        
        let location = CLLocation(latitude: 11.11, longitude: 22.22)
        let locationURL = WeatherAPI.with(location: location)
        XCTAssert(locationURL == "https://api.openweathermap.org/data/2.5/weather?lat=11.11&lon=22.22" + token, "lanlong url is not parsed")
        let locationURLForecast = WeatherAPI.with(location: location, isForecast: true)
        XCTAssert(locationURLForecast == "https://api.openweathermap.org/data/2.5/forecast?lat=11.11&lon=22.22" + token, "lanlong forecast url is not parsed")
        weatherService.request(withURL: URL(string: locationURL)!) { (result: Envelope<WeatherForcast>) in}
        XCTAssertEqual(weatherService.session.cachedUrl?.host, "api.openweathermap.org")
        XCTAssertEqual(weatherService.session.cachedUrl!.query, "lat=11.11&lon=22.22&appid=564799b60389a0358bade7d74899c4e6")
    }
    
    func testTemperatureConvertions() {
        XCTAssertEqual(TemperatureConverter.kelvinToCelsius(200), -73)
        XCTAssertEqual(TemperatureConverter.kelvinToFahrenheit(200), -100)
        XCTAssertEqual(TemperatureConverter.celsiusToFahrenheit(celsius: 200), 392)
        XCTAssertEqual(TemperatureConverter.fahrenheitToCelsius(fahrenheit: 392), 200)
    }
    
    func testCitieService() {
        let weatherService = WeatherServiceMock.Global
        let url = URL(string: WeatherAPI.with(city: "city").urlEncoded!)!
        weatherService.request(withURL: url) { (result: Envelope<WeatherResponse>) in}
        XCTAssertEqual(weatherService.session.cachedUrl?.host, "api.openweathermap.org")
        XCTAssertEqual(weatherService.session.cachedUrl!.query, "q=city&appid=564799b60389a0358bade7d74899c4e6")
    }
    
    func testForeCastService() {
        let weatherService = WeatherServiceMock.Global
        let cityurl = URL(string: WeatherAPI.with(city: "city",isForecast: true).urlEncoded!)!
        weatherService.request(withURL: cityurl) { (result: Envelope<WeatherResponse>) in}
        XCTAssertEqual(weatherService.session.cachedUrl?.host, "api.openweathermap.org")
        XCTAssertEqual(weatherService.session.cachedUrl!.query, "q=city&appid=564799b60389a0358bade7d74899c4e6")
        let urlForecast = URL(string: WeatherAPI.with(city: "city",isForecast: true).urlEncoded!)!
        weatherService.request(withURL: urlForecast) { (result: Envelope<WeatherForcast>) in}
        XCTAssertEqual(weatherService.session.cachedUrl?.host, "api.openweathermap.org")
        XCTAssertEqual(weatherService.session.cachedUrl?.absoluteString, "https://api.openweathermap.org/data/2.5/forecast?q=city&appid=564799b60389a0358bade7d74899c4e6")
        XCTAssertEqual(weatherService.session.cachedUrl!.query, "q=city&appid=564799b60389a0358bade7d74899c4e6")
    }
    
    func testCityWeatherViewModel() {
        let cityViewModel = CityWeatherViewModel(cities: ["aaa"])
        XCTAssertEqual(cityViewModel.cities.count, 1)
        let expection = XCTestExpectation(description: "service should called.")
        cityViewModel.fetchWeather(completion: { (finished) in
            let url = Bundle(for: TestProduct.self).url(forResource: "mock_city", withExtension: "json") ?? URL(fileURLWithPath: "")
            do {
                let jsonData = try Data(contentsOf: url)
                let response = try JSONDecoder().decode(WeatherResponse.self, from: jsonData)
                let weatherViewModel = WeatherResponseViewModel(with: response)
                cityViewModel.weatherData.append(weatherViewModel)
                expection.fulfill()
            } catch {
                XCTAssertThrowsError(error)
            }
        })
        wait(for: [expection], timeout: 5)
        XCTAssertEqual(cityViewModel.cities.count, 1)

        let weatherService = WeatherServiceMock.Global
        let url = URL(string: WeatherAPI.with(city: "city",isForecast: true).urlEncoded!)!
        weatherService.request(withURL: url) { (result: Envelope<WeatherResponse>) in}
        XCTAssertEqual(weatherService.session.cachedUrl?.host, "api.openweathermap.org")
        XCTAssertEqual(weatherService.session.cachedUrl!.query, "q=city&appid=564799b60389a0358bade7d74899c4e6")
    }
    
    func testForecastWeatherViewModel() {
        let forecastViewModel = ForcastViewModel()
        let location = CLLocation(latitude: 11.11, longitude: 22.22)
        let url = URL(string: WeatherAPI.with(location : location, isForecast: true))!
        let expection = XCTestExpectation(description: "service should called.")
        forecastViewModel.fetchWeatherForcast(url: url) { (finished) in
            let url = Bundle(for: TestProduct.self).url(forResource: "mock_forecast", withExtension: "json") ?? URL(fileURLWithPath: "")
            do {
                let jsonData = try Data(contentsOf: url)
                let response = try JSONDecoder().decode(WeatherForcast.self, from: jsonData)
                _ = forecastViewModel.grouptheData(forecastData: response)
                expection.fulfill()
            } catch {
                XCTAssertThrowsError(error)
            }
        }
        
        wait(for: [expection], timeout: 5)
        XCTAssertEqual(forecastViewModel.title, "San Francisco, US")
    }
    
    func testDateForamtter() {
       let forammted  = "2020-06-12".formatDate()
        XCTAssertEqual(forammted, "12 Jun, 2020")
    }

}
