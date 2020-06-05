//
//  ForecastViewController.swift
//  XebiaWeatherApp
//
//  Created by Lakshminaidu on 04/06/2020.
//  Copyright © 2020 Lakshminaidu. All rights reserved.
//

import UIKit
import CoreLocation

class ForecastViewController: BaseViewController  {

    @IBOutlet weak var tableView: UITableView!
    var viewModel = ForcastViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        startUserLocationService()

        // Do any additional setup after loading the view.
    }
    
    /// start location services
    private func startUserLocationService() {
        let location = LocationService.sharedInstance
        location.delegate = self
        location.startUpdatingLocation()
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
extension ForecastViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.weatherData.keys.sorted().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastDayCell.name) as? ForecastDayCell
        let keys = viewModel.weatherData.keys.sorted()
        let data = viewModel.weatherData[keys[indexPath.section]]!
        cell?.dayForecast = data
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.weatherData.keys.sorted()[section].formatDate()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

extension ForecastViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}



// Location Services
extension ForecastViewController: LocationServiceDelegate {
    
    func locationDidUpdate(_ service: LocationService, location: CLLocation) {
        let url = URL(string: WeatherAPI.with(location : location, isForecast: true))!
        self.showHideLoader()
        viewModel.fetchWeatherForcast(url: url) { [weak self] (success) in
            self?.showHideLoader(show: false)
            self?.title = self?.viewModel.title
            self?.tableView.reloadData()
        }
    }
    
    func locationDidFail(withError error: AppError) {
        switch error.errorCode {
        case .unableToFindLocation:
          showOkAlert(with: "Location Error", message: "Please enable location services")
        default:
            break
        }
    }
    
    
}

// MARK: - ForecastDayCell
class ForecastDayCell: UITableViewCell {
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    var selection: ((String) -> Void)?
    var dayForecast: [WeatherResponse] = [] {
        didSet {
            forecastCollectionView.reloadData()
        }
    }
}

// MARK: ForecastDayCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource

extension ForecastDayCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCell.name , for: indexPath) as? WeatherCell {
            cell.viewModel = WeatherResponseViewModel(with: dayForecast[indexPath.row])
            cell.weatherView.locationLabel.isHidden = true
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}

//MARK: WeatherCell
class WeatherCell: UICollectionViewCell {
    @IBOutlet weak var weatherView: WeatherView!
    var viewModel: WeatherResponseViewModel? {
        didSet {
            weatherView.viewModel = viewModel
        }
    }
}
