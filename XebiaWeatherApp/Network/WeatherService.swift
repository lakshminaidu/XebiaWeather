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

enum Result <T>{
    case success(T)
    case error(reason: String)
}

/// Manager for handling all REST API calls
final class WeatherService {
    
    static let Global = WeatherService ()
    
    private let reachability = Reachability()
    
    private var isConnectedToInternet: Bool {
        return Reachability.isConnectedToNetwork()
    }
    //1 creating the session
    private let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        configuration.timeoutIntervalForRequest = 60.00
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    //Data call with request

    func fetch<T: Codable>(withURL url: URL, completionHandler completion: @escaping (Envelope<T>) -> ()) {
        print("Service URL: \(url)")
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let httpResponse = response as? HTTPURLResponse  else {
                completion(.error(reason:"Network is not avialable"))
                return
            }
            if httpResponse.statusCode == 200, let responsedata = data {
                do {
                    let weatherResponseModel = try JSONDecoder().decode(T.self, from: responsedata)
                    DispatchQueue.main.async {
                        print("response finished")
                        completion(.success(weatherResponseModel))
                    }
                } catch let error {
                    print("Response Json Error")
                    print(error.localizedDescription)
                    completion(.error(reason: "Response is not valid"))
                }
                
            } else {
                completion(.error(reason: "Response is not valid"))
                print("\(String(describing: error))")
            }
        }
        task.resume()
    }
    

    
   
}
