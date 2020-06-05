//
//  ViewController+Extentions.swift
//  XebiaWeatherApp
//
//  Created by Lakshminaidu on 04/06/2020.
//  Copyright © 2020 Lakshminaidu. All rights reserved.
//

import UIKit

//MARK: extensions
extension UIViewController {
    
    func showOkAlert(with title: String?, message: String) {
        let alert = UIAlertController(title: title ?? "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
