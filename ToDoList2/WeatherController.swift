//
//  WeatherController.swift
//  ToDoList2
//
//  Created by Dayna Grigsby on 9/12/21.
//

import UIKit
import CoreLocation

//creates the struct for the weather API
public struct Forecast: Codable {
    struct Daily: Codable {
        let dt: Date
        struct Temp: Codable {
            let min: Double
            let max: Double
        }
        let temp: Temp
        let humidity: Int
        struct Weather: Codable {
            let id: Int
            let description: String
            let icon: String
            var weatherIconURL: URL {
                let urlString = "ttp://openweathermap.org/img/wn/\(icon)@2x.png"
                return URL(string: urlString)!
            }
        }
        let weather: [Weather]
        let clouds: Int
    }
}

//how to find the lat and long from city name
//CLGeocoder().geocodeAddresssString("Vancouver") { (placemarks, error) in
//    if let error = error {
//        print(error.localizedDescription)
//    }
//    if let lat = placemarks?.first?.location?.coordinate.latitiude,
//       let lon = placemarks?.first?.location?.coordinate.longitute {
//
//    }
//}

class WeatherController: UIViewController {
    
    @IBOutlet weak var zip: UITextField! //zipcode entry
    @IBOutlet weak var tempDisplay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func getWeather(_ sender: Any) {
        let zipStr: String = zip.text!
        print(zipStr)
//        let apiService = APIWeatherService.shared
        let geoCoder = CLGeocoder()
        var lat: CLLocationDegrees = 0
        var lon: CLLocationDegrees = 0
        geoCoder.geocodeAddressString(zipStr) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            lat = placemarks?.first?.location?.coordinate.latitude ?? 0
            lon = placemarks?.first?.location?.coordinate.longitude ?? 0
            
            //            if
//                let lat = placemarks.first?.location?.coordinate?.latitude
////                let placemarks = placemarks,
////                let location = placemarks.first?.location
//
////                let lat = location.coordinate.latitude
////                let lon = location.coordinate.longitude
//            else {
//                self.tempDisplay.text = "Invalid zipcode"
//            }
        }
        print(lat)
        print(lon)
        
        if let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=current,minutely,hourly,alerts&appid=c9c3bf612706e65b527065820b52c899") {
            URLSession.shared.dataTask(with: url) { [self]
                weatherdata, respose, error in
                if let weatherdata = weatherdata {
                    if let jsonString = String(data: weatherdata, encoding: .utf8) {
                        //print(jsonString)
                        let res = jsonString.components(separatedBy: "temp")
                        let finaltempKelvinStr = (((res[1].components(separatedBy: ":"))[1].components(separatedBy: ","))[0])
                        let tempKelvinDoub = Double(finaltempKelvinStr)
                        //convert from Kelvin to F
                        let finalTempF = (((tempKelvinDoub! - 273.15)*Double(9))/Double(5)) + Double(32)
                        let tempDisplay = String(format: "%.1f", finalTempF)
                        print("actual temp \(tempDisplay)")
                        DispatchQueue.main.async {
                            print("changing now")
                            self.tempDisplay.text = "\(tempDisplay) *F"
                                   }
                        
                    }
                }
            }.resume()
        }
        
//        if let lat = placemarks?.first?.location?.coordinate.latitude,
//           let lon = placemarks?.first?.location?.coordinate.longitude {
//            // Don't forget to use your own key
//            apiService.getJSON(urlString: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=current,minutely,hourly,alerts&appid={InsertYourKeyHere}",
//                               completion: { (result: Result<Forecast,APIWeatherService.APIError>) in
//                switch result {
//                case .success(let forecast):
//                    for day in forecast.daily {
//                        print(dateFormatter.string(from: day.dt))
//                        print("   Max: ", day.temp.max)
//                        print("   Min: ", day.temp.min)
//                        print("   Humidity: ", day.humidity)
//                        print("   Description: ", day.weather[0].description)
//                        print("   Clouds: ", day.clouds)
//                        print("   pop: ", day.pop)
//                        print("   IconURL: ", day.weather[0].weatherIconURL)
//                    }
//                case .failure(let apiError):
//                    switch apiError {
//                    case .error(let errorString):
//                        print(errorString)
//                    }
//                }
//            }
//        }
    
    }
    
}
