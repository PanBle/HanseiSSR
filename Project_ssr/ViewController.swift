//
//  ViewController.swift
//  Project_ssr
//
//  Created by KM_TM on 2018. 8. 20..
//  Copyright © 2018년 KM_TM. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSoup
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var minTemLabel: UILabel!
    @IBOutlet weak var maxTemLabel: UILabel!
    
    let lat = "\(UserDefaults.standard.float(forKey: "lat"))"
    let lon = "\(UserDefaults.standard.float(forKey: "lon"))"
    let url = "https://samples.openweathermap.org/data/2.5/weather?lat=%f&lon=%2f&appid=b6907d289e10d714a6e88b30761fae22"
    
    let locationManager:CLLocationManager = CLLocationManager()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        parse_weather()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func parse_weather() {
        let aURL = url.replacingOccurrences(of: "%f", with: lat)
        let apiURL = aURL.replacingOccurrences(of: "%2f", with: lon)
        
        Alamofire.request(apiURL).responseJSON(completionHandler: {res in
            switch res.result {
            case .success(let value):
                let temJSON = JSON(value)
                print(temJSON)
                let temp_min = temJSON["main"]["temp_min"].float! - 273
                let temp_max = temJSON["main"]["temp_max"].float! - 273
                print("\(temp_max),\(temp_min)")
                print("\(self.lat), \(self.lon)")
                
                self.minTemLabel.text = String(format:"%0.1f", temp_min) + "℃"
                self.maxTemLabel.text = String(format:"%0.1f", temp_max) + "℃"
            case .failure(let error):
                print("\(error)")
                
            }
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

