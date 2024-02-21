// Name: Arshdeep Singh
// Student Id: 991502864
//  Weather_Widget.swift
//  Weather_Widget
//
//  Created by Arshdeep Singh on 2023-11-24.
//

import WidgetKit
import SwiftUI


//Controller
struct Provider: TimelineProvider {
    
    
    @ObservedObject var weatherHelper = WeatherHelper()
    @ObservedObject var locationHelper = LocationHelper()
    
    
    //@State var temp: Double
    
    //let temp = weatherHelper.weather.current.temp_c
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), temperature: weatherHelper.weather?.current.temp_c ?? 00)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), temperature: weatherHelper.weather?.current.temp_c ?? 00)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {

        var entries : [SimpleEntry] = []

        //let refresh = Calendar.current.date(byAdding: .second, value: 5, to: Date()) ?? Date()
        //accessing the location and fethcing the weather
        locationHelper.requestLocation()
        
        //passing coordinates to weather function everytime location changes
        weatherHelper.fetchWeatherInfo(latitude: locationHelper.currentLocation?.coordinate.latitude ?? 00, longitude: locationHelper.currentLocation?.coordinate.longitude ?? 00)
            
            //let temp = weatherHelper.weather?.current.temp_c ?? 00
            //let city = weatherHelper.weather?.location.name ?? "NA"
            
            //print(#function,"Temperature in widget:\(temp)")
            //print(#function,"City in widget:\(city)")
        
        
            
            let entry = SimpleEntry(date: Date(), temperature: weatherHelper.weather?.current.temp_c ?? 00)
        
        entries.append(entry)
            
        
            
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
        
    }
}

//Model
struct SimpleEntry: TimelineEntry {
    let date: Date
    let temperature: Double
    //let weather: Weather
   // let weatherData: WeatherData
}



//View
struct Weather_WidgetEntryView : View {
    var entry: Provider.Entry

    @ObservedObject var weatherHelper: WeatherHelper
    @ObservedObject var locationHelper: LocationHelper
    
    
    var body: some View {
        
        
        VStack {
//
           // if locationHelper.currentLocation != nil{
 //               if let weather = weatherHelper.weather {
                    
                    HStack{
                        Text("\(weatherHelper.weather?.location.name ?? "NA")")
                        Text("\(weatherHelper.weather?.location.country ?? "NA" )")
                    }
                    .padding()
            Text("\(Int(entry.temperature ?? 00))\u{00B0}C")
//                } else {
//                    Text("Fetching weather....")
//                }
//            } else {
//                Text("Fetching location....")
//            }
        }//VStack
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

//struct WeatherWidgetEntryView: View {
//    
//    var entry: Provider.Entry
//
//    @ObservedObject var weatherHelper: WeatherHelper
//    @ObservedObject var locationHelper: LocationHelper
//    
//    var body: some View{
//        Weather_WidgetEntryView(entry: entry, weatherHelper: WeatherHelper(), locationHelper: LocationHelper())
//    }
//}

struct Weather_Widget: Widget {
    let kind: String = "Weather_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                Weather_WidgetEntryView(entry: entry, weatherHelper: WeatherHelper(), locationHelper: LocationHelper())
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                Weather_WidgetEntryView(entry: entry, weatherHelper: WeatherHelper(), locationHelper: LocationHelper())
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Weather Widget")
        .description("This is an Weather widget.")
    }
}

#Preview(as: .systemSmall) {
    Weather_Widget()
} timeline: {
    SimpleEntry(date: .now, temperature: 00)
    
}
