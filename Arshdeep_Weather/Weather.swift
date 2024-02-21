// Name: Arshdeep Singh
// Student Id: 991502864

//  Weather.swift
//  Arshdeep_Weather
//
//  Created by Arshdeep Singh on 2023-11-14.
//

import Foundation
import UIKit

class Weather: Codable{
   

    let current: Current

    let location: Location
  
    
    struct Location: Codable{
        let name: String
        let country: String
    }
    
    struct Current: Codable{
        var temp_c: Double
        let wind_kph : Double
        let wind_dir: String
        let humidity: Double
        let feelslike_c: Double
        let uv: Double
        let vis_km: Double        
        let condition: Condition
    }
    
    struct Condition: Codable{
        let text: String
        let icon: String
    }
    
    enum WeatherKeys: String, CodingKey{
        case weather
    }

    init(current: Current, location: Location) {
        self.current = current
        self.location = location
    }
   
}

//fetching icon from the url
extension Weather {
    var iconURL: URL?{
        let baseURL = "https:"
        return URL(string: baseURL + current.condition.icon)
    }
}
