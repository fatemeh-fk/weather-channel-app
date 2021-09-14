//
//  ViewController.swift
//  Weather Channel App
//
//  Created by Fateme Karimi on 2021-09-13.
//

import UIKit
import CoreLocation
class WeatherViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        // Do any additional setup after loading the view.
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }

    @IBAction func locationPressed(_ sender: UIButton) {
        
        locationManager.requestLocation()
    }
    
}
    extension WeatherViewController :UITextFieldDelegate {
        
        @IBAction func searchPressed(_ sender: UIButton) {
            searchTextField.endEditing(true)
           print( searchTextField.text!)
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            searchTextField.endEditing(true)
            return true
        }
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            //in bara zamani hast ke empty az user mikhaim type kone
            if textField.text != ""{
                return true
            }else{
                textField.placeholder = "type somthing"
                return false
            }
        }
        func textFieldDidEndEditing(_ textField: UITextField) {
            if  let city = searchTextField.text {
                weatherManager.fetchWeather(cityName: city)
            }
            //use searchtext field to get the
            //text ra pack mikonim
            searchTextField.text = ""
        }
       
    }
   
    extension WeatherViewController:WeatherManagerDelegate{
        
        func didUpdateWeather(_ weatherManger :WeatherManager,weather : WeatherModel){
           // print(weather.temprature)
            DispatchQueue.main.async {
                self.temperatureLabel.text = weather.tempratureString
                self.conditionImageView.image = UIImage(systemName: weather.conditionName)
                self.cityLabel.text = weather.cityName
            }
           
        }
        func didFailWithError(error: Error) {
            print(error)
        }
        
    }

    extension WeatherViewController:CLLocationManagerDelegate{
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last{
                locationManager.stopUpdatingLocation()
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                weatherManager.fetchWeather(latitude: lat,longitute :lon)
            }
            
        }
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("error")
        }
        
    }

