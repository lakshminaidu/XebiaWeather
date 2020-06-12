//
//  WeatherService.swift
//  XebiaWeatherApp
//
//  Created by Lakshminaidu on 04/06/2020.
//  Copyright © 2020 Lakshminaidu. All rights reserved.
//

import Foundation
import UIKit

typealias Envelope<T: Codable> = Result<T>

enum Result <T: Codable>{
    case success(T)
    case failure(AppError)
}

protocol WeatherServiceType: class {
    func request<T: Codable>(withURL url: URL, completion: @escaping (Envelope<T>) -> ())
}


/// Manager for handling all REST API calls
final class WeatherService: WeatherServiceType {
    var session: URLSession
    static let Global = WeatherService()
    //1 creating the session
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = 50
        configuration.httpMaximumConnectionsPerHost = 100
        configuration.timeoutIntervalForRequest = 60.00
        self.session = URLSession(configuration: configuration)
    }
    
    //Data call with request
    func request<T: Codable>(withURL url: URL, completion: @escaping (Envelope<T>) -> ()) {
        print("Service URL: \(url)")
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil, let httpResponse = response as? HTTPURLResponse  else {
                completion(.failure(.networkRequestFailed))
                return
            }
            if httpResponse.statusCode == 200, let responsedata = data {
                do {
                    let weatherResponseModel = try JSONDecoder().decode(T.self, from: responsedata)
                    DispatchQueue.main.async {
                        completion(.success(weatherResponseModel))
                    }
                } catch let error {
                    print(error.localizedDescription)
                    completion(.failure(.jsonParsingFailed))
                }
                
            } else {
                completion(.failure(.networkRequestFailed))
                print("\(String(describing: error))")
            }
        }
        task.resume()
    }
}
