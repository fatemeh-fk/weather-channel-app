//
//  WeatherData.swift
//  Weather Channel App
//
//  Created by Fateme Karimi on 2021-09-14.
//

import Foundation

struct WeatherData :Decodable{
    let name :String
    
    let main : Main
    let weather : [Weather]
}
struct Main :Decodable {
    let temp :  Double
}

struct Weather  :Decodable{
        let description :String
        let id :Int
    }
