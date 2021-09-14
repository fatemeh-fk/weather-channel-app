//
//  WeatherManager.swift
//  Weather Channel App
//
//  Created by Fateme Karimi on 2021-09-14.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManger :WeatherManager,weather :WeatherModel)
    func didFailWithError(error :Error)
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=c9bb61c65d373bbb02de0f9f03dff6ef&units=metric"
    var delegate : WeatherManagerDelegate?
    
    
    func fetchWeather(cityName : String){
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude:CLLocationDegrees ,longitute :CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString)
        
    }
    
    
    func performRequest(with urlString : String){
        //1
        if  let url = URL(string: urlString){
            //2
            let session = URLSession(configuration: .default)
            //3
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    //print(error!)
                    return
                }
                
                if let safeData = data {
                    //hame  ro be sorat ke majmome mide biroon
//                    let dataString = String(data: safeData, encoding: .utf8)
//                    print(dataString)
                    //dakhle closure behtare az self estefade she
                    if let weather = self.parseJSON(safeData){
                       // let  weatherVC = WeatherViewController()
                        self.delegate?.didUpdateWeather(self,weather:weather)
                    }
                }
              
            }
        //  let task =  session.dataTask(with: url, completionHandler: handle(data: response: error: ))
            
            //ghesmate jooloie completionHandler ke abi shod enter koni be balaii tabdil mishe
            //4
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData:Data)-> WeatherModel?{
        let decoder = JSONDecoder()
        do{
       let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
           // print(decodedData.main.temp)
           // print(decodedData.weather[0].description)
           // print(decodedData.weather[0].id)
            let id = decodedData.weather[0].id
            
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temprature: temp)
           // print(weather.conditionName)
          //  print(weather.tempratureString)
            //print(decodedData.name)
            return weather
        }catch{
            //print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
