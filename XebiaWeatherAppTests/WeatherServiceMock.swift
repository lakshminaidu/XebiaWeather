//
//  WeatherServiceMock.swift
//  XebiaWeatherAppTests
//
//  Created by Lakshminaidu on 12/06/2020.
//  Copyright © 2020 Lakshminaidu. All rights reserved.
//

import Foundation
@testable import XebiaWeatherApp
class WeatherServiceMock: WeatherServiceType {
    
    private (set) var lastUrl: URL?
    var session: MockURLSession
    static let Global = WeatherServiceMock()
    
    init() {
        self.session = MockURLSession()
    }
    func request<T: Codable>(withURL url: URL, completion: @escaping (Envelope<T>) -> ()) {
        let task = session.dataTask(with: url) { (data, response, error) in
            
        }
        task.resume()
    }
}


class MockURLSession: URLSession {
    var cachedUrl: URL?
    override func dataTask(with url: URL, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.cachedUrl = url
        return URLSessionDataTask()
    }
}
