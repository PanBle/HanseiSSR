//
//  menuViewController.swift
//  Project_ssr
//
//  Created by KM_TM on 2018. 8. 22..
//  Copyright © 2018년 KM_TM. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSoup
import CoreLocation

class menuViewController: UIViewController, CLLocationManagerDelegate {
    
    var lat:String = ""
    var lon:String = ""
    let locationManager:CLLocationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        YMD = parseDate()
        scrape_site()
        
    }
    //Mark
    var htmllocation = ""
    var xpathlo = ""
    var YMD:String = ""
    var today = Date()
    //Mark : IBOutlet
    @IBOutlet weak var datelabel1: UILabel!
    @IBOutlet weak var datelabel2: UILabel!
    @IBOutlet weak var lunchlabel: UILabel!
    
    func parseDate() -> String
    {
        
        let realtime = DateFormatter()
        realtime.locale = Locale(identifier: "ko_kr")
        realtime.timeZone = TimeZone(abbreviation: "KST")
        realtime.dateFormat = "yyyyMMdd"
        
        let kr = realtime.string(from: today)
    
        realtime.dateFormat = "yyyy년"
        self.datelabel1.text = realtime.string(from: today)
        realtime.dateFormat = "MM dd"
        self.datelabel2.text = realtime.string(from: today)
        
        return kr
    }
    
    //   https://stu.sen.go.kr/sts_sci_md00_001.do?schulCode=B100000662&schulCrseScCode=4&schulKndScCode=04
    func scrape_site() {
        let apiURL = "http://stu.sen.go.kr/sts_sci_md01_001.do?schulCode=B100000662&schulCrseScCode=4&schulKndScCode=04&schMmealScCode=2&schYmd=%s"
        let newurl = apiURL.replacingOccurrences(of: "%s", with: YMD)
        
        let cal = Calendar(identifier: .gregorian)
        let comps = cal.dateComponents([.weekday], from: today)

        Alamofire.request(newurl).responseString { response in
            print(" lunch : \(response.result.isSuccess)")
            if let html = response.result.value {
                self.parseHTML(html: html,weekday: comps.weekday)
            }
        }
    }
    
    func parseHTML(html:String, weekday:Int?) -> Void {
        do {
            let doc = try SwiftSoup.parse(html)
            do {
                let element1 = try doc.select("tr").get(2)
                let element2 = try element1.select("td").get(weekday! - 1)
                let element3:String = try element2.outerHtml()
                if weekday == 0
                {
                    self.lunchlabel.text = "급식이 없어오"
                    return
                }
                let element4 = element3.replacingOccurrences(of: "<td class=\"textC\">", with: "")
                if element4 == ""
                {
                    self.lunchlabel.text = "급식이 없어오"
                    return
                }
                let element5 = element4.replacingOccurrences(of: "<br>", with: "\n")
                let element6 = element5.replacingOccurrences(of: "</td>", with: "")
                let element7 = element6.replacingOccurrences(of: "*", with: "")
                let element8 = element7.replacingOccurrences(of: ".", with: "")
                let element9 = element8.replacingOccurrences(of: "1", with: "")
                let element10 = element9.replacingOccurrences(of: "2", with: "")
                let element11 = element10.replacingOccurrences(of: "3", with: "")
                let element12 = element11.replacingOccurrences(of: "4", with: "")
                let element13 = element12.replacingOccurrences(of: "5", with: "")
                let element14 = element13.replacingOccurrences(of: "6", with: "")
                let element15 = element14.replacingOccurrences(of: "7", with: "")
                let element16 = element15.replacingOccurrences(of: "8", with: "")
                let element17 = element16.replacingOccurrences(of: "9", with: "")
                let element18 = element17.replacingOccurrences(of: "0", with: "")
                let element19 = element18.replacingOccurrences(of: "<td class=\"textC last\">", with: "급식이 없어오")
                lunchlabel.numberOfLines = 0
                self.lunchlabel.text = element19
                print(element19)
            }catch {
                self.lunchlabel.text = "급식이 없어오"
            }
        } catch {
            self.lunchlabel.text = "급식이 없어오"
        }
        
    }
    
    @IBAction func leftButton(_ sender: Any) {
        today = Date(timeInterval: -86400, since: today)
        YMD = parseDate()
        scrape_site()
    }
    
    @IBAction func rightButton(_ sender: Any) {
        today = Date(timeInterval: 86400, since: today)
        YMD = parseDate()
        scrape_site()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastestLocation:CLLocation = locations[locations.count - 1]
        
        lat = String(format:"%0.6f", lastestLocation.coordinate.latitude)
        lon = String(format:"%0.6f", lastestLocation.coordinate.longitude)
        
        UserDefaults.standard.set(lat, forKey: "lat")
        UserDefaults.standard.set(lon, forKey: "lon")
    }

}
