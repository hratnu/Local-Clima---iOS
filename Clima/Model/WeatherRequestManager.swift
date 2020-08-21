//
//  WeatherRequestManager.swift
//  Clima
//
//  Created by Harshil Ratnu on 7/16/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol  WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
}

struct  WeatherRequestManager {
    var delegate: WeatherManagerDelegate?
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=d925ad15722d9dc510882710c9f6554e&units=metric"
    
    func fetchWeather(city: String){
        var urlString = "\(weatherURL)&q=\(city)"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(urlString)
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(lat: Double, lon: Double){
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString:String){
        //step 1 create a url
        if let url = URL(string: urlString){
            //step 2 create  a Url session
            let session = URLSession(configuration: .default)
            
            // step 3 give the session a task
            let task = session.dataTask(with: url, completionHandler: handle(data: response: error: ))
            
            //step 4 start teh task
            
            task.resume()
        }else{
           
            print("had some error")
        }
        
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?){
        if error != nil{
            print(error!)
            return
        }
        
        if let dataReceived = data{
            //            let dataString = String(data: dataReceived, encoding: .utf8)  to convert data into a a string
            if let weather = parseJSON(weatherData : dataReceived){
                // now we just want to pass this weather data into the main view controller file
                // one way is to make an instance of the weather view controller and call a method using that instance
                // but lets instead use the delegate protocols
              
                
                delegate?.didUpdateWeather(weather: weather)
            }
            
            
        }
    }
    
    
    func parseJSON(weatherData : Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData  = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            let weatherModel =  WeatherModel(id: id, temp: temp, cityName: name)
            print(weatherModel.condition)
            print(weatherModel.temperatureString)
            return weatherModel
            
        }catch {
            print(error)
            return nil
        }
    }
    
    
    
}
