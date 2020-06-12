//
//  CityWeatherController.swift
//  XebiaWeatherApp
//
//  Created by Lakshminaidu on 04/06/2020.
//  Copyright © 2020 Lakshminaidu. All rights reserved.
//

import UIKit

class CityWeatherController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: CityWeatherViewModel!
    var cities = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CityWeatherViewModel(cities: cities)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        self.showHideLoader()
        viewModel.fetchWeather { [weak self] (success) in
            self?.showHideLoader(show: false)
            self?.tableView.reloadData()
        }

       // fetchWeather(for: cities)
        // Do any additional setup after loading the view.
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

//MARK: UITableViewDataSource
extension CityWeatherController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.weatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CityWeatherCell.name) as? CityWeatherCell
        cell?.viewModel = viewModel.weatherData[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
}

//MARK: UITableViewDelegate
extension CityWeatherController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: CityWeatherCell
class CityWeatherCell: UITableViewCell {
    @IBOutlet weak var weatherView: WeatherView!
    var viewModel: WeatherResponseViewModel? {
        didSet {
            weatherView.viewModel = viewModel
        }
    }
}
