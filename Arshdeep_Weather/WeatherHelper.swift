// Name: Arshdeep Singh
// Student Id: 991502864

//  WeatherHelper.swift
//  Arshdeep_Weather
//
//  Created by Arshdeep Singh on 2023-11-14.
//

import Foundation


class WeatherHelper: ObservableObject{
    
    
    @Published var weather: Weather?
    
    
    func fetchWeatherInfo(latitude: Double, longitude: Double){
        
        
        //api key
        let apiKey = "790c0e1055b3402f82d223935231411"
        
        // url to connect with the api and requesting the weahter information
        let urlReq = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(latitude),\(longitude)"
        print(#function,"\n Connected to url for weather updates")
        
        if let url = URL(string: urlReq){
            URLSession.shared.dataTask(with: url){ data, response, error in
            
                if let data = data{
                    let decoder = JSONDecoder()
                    do{
                        let weather = try decoder.decode(Weather.self, from: data)
                        DispatchQueue.main.async {
                            self.weather = weather
                        }
                    }catch{
                        print(#function,"Unable to fetch information: \(error)")
                    }
                }//data
            }.resume()
        }//url        
    }//fetchWeatherInfo
    
}
