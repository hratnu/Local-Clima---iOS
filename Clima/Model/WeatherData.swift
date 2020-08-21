//
//  WeatherData.swift
//  Clima
//
//  Created by Harshil Ratnu on 7/16/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation


// a struct to organize and decode the JSON data received from the API
struct WeatherData : Decodable {
    let name: String
    let main: Main
    let weather : [Weather] 
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let description: String
    let id : Int
}

//weather[0].description
