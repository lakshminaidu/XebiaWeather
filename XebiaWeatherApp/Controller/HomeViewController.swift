//
//  HomeViewController.swift
//  XebiaWeatherApp
//
//  Created by Lakshminaidu on 04/06/2020.
//  Copyright © 2020 Lakshminaidu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: View Outlets
    @IBOutlet weak var textView: UITextView!

    // MARK: ViewlifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    // MARK: IBActions
    @IBAction func showWeatherAction(sender: UIButton) {
        let cities = textView.text.trim().components(separatedBy: ",")
        if cities.count < 3 {
            showOkAlert(with: "Alert", message: "Please enter minimum 3 cities")
        } else if cities.count > 7 {
            showOkAlert(with: "Alert", message: "Please enter maximum 7 cities")
        } else {
            let controller = self.storyboard?.instantiateViewController(identifier: CityWeatherController.name ) as! CityWeatherController
            controller.cities = cities
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func currentLocationAction(sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(identifier: ForecastViewController.name ) as! ForecastViewController
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        textView.resignFirstResponder()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
