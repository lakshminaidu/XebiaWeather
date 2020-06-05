//
//  NSObject+Extentions.swift
//  XebiaWeatherApp
//
//  Created by Lakshminaidu on 04/06/2020.
//  Copyright © 2020 Lakshminaidu. All rights reserved.
//

import Foundation

extension NSObject {
    var name: String {
        return String(describing: type(of: self))
    }
    
    static var name: String {
        return String(describing: self)
    }
}
