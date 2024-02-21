// Name: Arshdeep Singh
// Student Id: 991502864

//  LocationHelper.swift
//  Arshdeep_Weather
//
//  Created by Arshdeep Singh on 2023-11-14.
//

import Foundation
import CoreLocation

class LocationHelper: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    
   
    private let locationManager = CLLocationManager()
    
    @Published var currentLocation : CLLocation?
    @Published var weahter: Weather?
  
    
    
    override init(){
        super .init()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        setupLocationManager()
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func requestLocation(){
        locationManager.requestLocation()
    }
    
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            print("Always access granted for location")
            // start receiving the location changes
            manager.startUpdatingLocation()
            
        case .authorizedWhenInUse:
            print(#function,"Foreground access granted for location")

            //start receiving the location changes.
            manager.startUpdatingLocation()
            
        case .notDetermined, .denied:
            print(#function,"Location Permission \(manager.authorizationStatus)")
            
            //stop an existing location updates
            //manager.stopUpdatingLocation()
            
            //request the foreground location
            manager.requestWhenInUseAuthorization()
            
        case .restricted:
            print(#function,"location permissiions restricted")
            
            manager.requestAlwaysAuthorization()
            manager.requestWhenInUseAuthorization()
            
        @unknown default:
            
            print(#function,"location permissiions not received")
            
            //stop an existing location update
            //manager.stopUpdatingLocation()
            
            //request the forground permission.
            manager.requestWhenInUseAuthorization()
        }
        
    }//locationManagerDidChangeAuthorization
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        if (locations.isEmpty){
            print(#function,"No location received.")
            // optionally use any hardcoded locations
        } else {
            
            if(locations.last != nil){
                //access most recent location
                print(#function,"Most recent locations: \(locations.last)")
                self.currentLocation = locations.last
            } else {
                //access to previouslt old known location
                print(#function,"Most recent locations: \(locations.first)")
                self.currentLocation = locations.first
            }
            print(#function," \n Lat: \(self.currentLocation?.coordinate.latitude) , Lng : \(self.currentLocation?.coordinate.longitude)")
        }
        
    }//locationManager
    
    //Checking if there's any errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print(#function, "Unable to receive location due to error: \(error.localizedDescription)")
        
       
    }
    
    func locationManager(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied{
            print(#function,"Location Access Denied")
        }
    }
    
}//LocationHelper
