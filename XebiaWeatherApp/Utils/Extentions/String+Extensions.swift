//
//  StringExtensions.swift
//  XebiaWeatherApp
//
//  Created by Lakshminaidu on 04/06/2020.
//  Copyright © 2020 Lakshminaidu. All rights reserved.
//


import Foundation

/// Extensions to the String class.
extension String {
 
    /**
     Returns an URL encoded string of this string.
     
     - returns: String that is an URL-encoded representation of this string.
     */
    public var urlEncoded: String? {
        get {
            return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        }
    }
    /**
     Returns an trimmed string
     
     - returns: String that is trimmed string.
     */
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // change date formate from -> to format
    func formatDate(from: String = "yyyy-MM-dd", to: String = "dd MMM, yyyy") -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = from
        let date = dateformatter.date(from: self)
        dateformatter.dateFormat = to
        return dateformatter.string(from: date ?? Date())
    }

}
