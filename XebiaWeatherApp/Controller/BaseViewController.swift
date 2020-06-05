//
//  BaseViewController.swift
//  XebiaWeatherApp
//
//  Created by Lakshminaidu on 05/06/2020.
//  Copyright © 2020 Lakshminaidu. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var loaderView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderView = UIActivityIndicatorView(style:.large)
        loaderView.color = .systemBlue
        loaderView.hidesWhenStopped = true
        self.view.addSubview(loaderView)
        loaderView.center = self.view.center
       showHideLoader(show: false)

        // Do any additional setup after loading the view.
    }
    
    func showHideLoader(show: Bool = true) {
        self.view.bringSubviewToFront(loaderView)
        show ? loaderView.startAnimating() : loaderView.stopAnimating()
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
