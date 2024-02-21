// Name: Arshdeep Singh
// Student Id: 991502864
//  ContentView.swift
//  Arshdeep_Weather
//
//  Created by Arshdeep Singh on 2023-11-14.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    @StateObject private var weatherHelper =  WeatherHelper()
    @StateObject private var locationHelper = LocationHelper()
    
    
    
    var body: some View {
        NavigationView{
            VStack {
               
                #if os(watchOS)
                
                if let location = locationHelper.currentLocation{
                    
                    if let weather = weatherHelper.weather{
                        let output = Int(weather.current.temp_c)
                        
                    Text("\(weather.location.name), \(weather.location.country) ")
                            .foregroundColor(.black)
                            .font(.headline)
                        HStack{
                            Text("\(output) \u{00B0}C")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .bold()
                            
                            AsyncImage(url: weather.iconURL) { phase in
                                
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                case .failure:
                                    Image(systemName: "exclamationmark.triangle")
                                        .frame(width: 40, height: 40)
                                @unknown default:
                                    fatalError()
                                }
                            }
                        }//HStack
                        
                        Text("\(weather.current.condition.text ?? "NA")")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                    }else{
                        Text("Fetching Weather.....")
                    }
                }else{
                    Text("Fetching Location.....")
                }
                    
                #else
                    
                VStack{
                    if let location = locationHelper.currentLocation{
                        
                        if let weather = weatherHelper.weather{
                            let output = Int(weather.current.temp_c)
                            
                            Text("\(weather.location.name), \(weather.location.country) ")
                                .bold()
                                .font(.title3)
                                .padding()
                            HStack{
                                Text("\(output) \u{00B0}C")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                    .bold()
                                    .padding()
                                
                                AsyncImage(url: weather.iconURL) { phase in
                                    
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                        
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                        
                                    case .failure:
                                        Image(systemName: "exclamationmark.triangle")
                                            .frame(width: 50, height: 50)
                                    @unknown default:
                                        fatalError()
                                    }
                                }
                            }//HStack
                            VStack{
                                Text("Feels Like: \(Int(weather.current.feelslike_c ?? 0)) \u{00B0}C")
                                Text("Condition: \(weather.current.condition.text ?? "NA")")
                                Text("Humidity: \(Int(weather.current.humidity ?? 0))")
                                Text("Wind Speed: \(Int(weather.current.wind_kph ?? 0)) km/h")
                                Text("Wind Direction: \(weather.current.wind_dir ?? "NA")")
                                Text("UV: \(Int(weather.current.uv ?? 0))")
                                Text("Visibility: \(Int(weather.current.vis_km ?? 0))km")
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.callout)
                            
                        }else{
                            Text("Fetching Weather.....")
                        }
                        
                    }else{
                        Text("Fetching Location.....")
                    }
                      
                }
                .cornerRadius(20)
                .padding(.horizontal, 20)
                #endif
                Text("")
                
            }//VStack
            .padding()
            .navigationBarTitle("Arshdeep Singh")
            .background(Color.cyan)
            .cornerRadius(12)
            .padding(.horizontal, 6)
        }//NavigationView
        .onAppear{
            //accessing the request location on initalizing the application
            locationHelper.requestLocation()
            
            //passing coordinates to weather function everytime location changes
            weatherHelper.fetchWeatherInfo(latitude: locationHelper.currentLocation?.coordinate.latitude ?? 00, longitude: locationHelper.currentLocation?.coordinate.longitude ?? 00)
        }//onAppear
        
        .onChange(of: locationHelper.currentLocation){ newLocation in
            if let newLocation = newLocation{
                weatherHelper.fetchWeatherInfo(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
            }
        }//onChange
    }
}

#Preview {
    ContentView().foregroundColor(.red)
}
