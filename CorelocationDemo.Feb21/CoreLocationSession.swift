//
//  CoreLocationSession.swift
//  CorelocationDemo.Feb21
//
//  Created by Pursuit on 2/21/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import Foundation
// this is a swift file
import CoreLocation

struct Location {
  let title: String
  let body: String
  let coordinate: CLLocationCoordinate2D
  let imageName: String
  
  static func getLocations() -> [Location] {
    return [
      Location(title: "Pursuit", body: "We train adults with the most need and potential to get hired in tech, advance in their careers, and become the next generation of leaders in tech.", coordinate: CLLocationCoordinate2D(latitude: 40.74296, longitude: -73.94411), imageName: "team-6-3"),
      Location(title: "Brooklyn Museum", body: "The Brooklyn Museum is an art museum located in the New York City borough of Brooklyn. At 560,000 square feet (52,000 m2), the museum is New York City's third largest in physical size and holds an art collection with roughly 1.5 million works", coordinate: CLLocationCoordinate2D(latitude: 40.6712062, longitude: -73.9658193), imageName: "brooklyn-museum"),
      Location(title: "Central Park", body: "Central Park is an urban park in Manhattan, New York City, located between the Upper West Side and the Upper East Side. It is the fifth-largest park in New York City by area, covering 843 acres (3.41 km2). Central Park is the most visited urban park in the United States, with an estimated 37.5–38 million visitors annually, as well as one of the most filmed locations in the world.", coordinate: CLLocationCoordinate2D(latitude: 40.7828647, longitude: -73.9675438), imageName: "central-park")
    ]
  }
}


class CoreLocationSession: NSObject {
    // why?
    // it is a subclass .. this is an inheritence from another class
    // the subclass has it own ...
    public var locationManager: CLLocationManager // it is of the type
    
    // Everything you want to use for location manager you start inside of the initializer
   override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self // updates like user changed the location/ there was an error capturing the location
        // request the user's location
    locationManager.requestAlwaysAuthorization()
    locationManager.requestWhenInUseAuthorization()
    
    // the following keys need to be added to the info.plist
    
    /*
     NSLocationAlwaysAndWhenInUseUsageDescription
   
     NSLocationWhenInUseUsageDescription
     */
    
    // get updates for user location
    // this is the most aggressive solution for the gps data collection...
        // locationManager.startUpdatingLocation() instead of this one which updates all the time instead we will use the one below
    
    // less agressive on battery comsumption and GPS Collection
    startSignificantLocationChanges() // the device has built in fuctions that aid in the ...
    
    startMonitoringRegion()
    }
    
    private func startSignificantLocationChanges(){
        
        if !CLLocationManager.significantLocationChangeMonitoringAvailable(){
            // not available on the device
            print("not available on the device")
            return
        }
        // less agressive then the startUpdatingLocation() in GPS monitor changes
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    
    public func convertCoordinateToPlacemark(coordinate: CLLocationCoordinate2D){
        //CLLocationCoordinate2D - a struct that has lat and long.. so now we can pass in a coordiante.
        // we will use the CLGeocoder() class for converting coordiate(CLLocationCoordinate2D) to placemark(CLPlacemark)
        
        // returns a placemark and there are properties within placemark that we will then access.
        
        // we need to create a location to put in
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("reverseGeocodeLocation: \(error)")
            }
           if let firstPlacemark = placemarks?.first{
                print("placemark info: \(firstPlacemark)")
            }
         }
        }
    
    // converts from name to the coordiate...
    public func convertPlaceNameToCoordinate(addressString: String){
        // converting an address to a coordinate
        CLGeocoder().geocodeAddressString(addressString) { (placemarks, error) in
            if let error = error {
                print("geocodeAddressString: \(error)")
            }
            if let firstPlaceName = placemarks?.first, let location = firstPlaceName.location {
                print("placeName coordinate is: \(location.coordinate)")
            }
            
        }
    }
    
    // monitor a CLRegion
    // a CLRegion is made up of a center coordinate and a radius in meters
    private func startMonitoringRegion(){
        let location = Location.getLocations()[2] // central park
        let identifier = "monitoring region"
        let region = CLCircularRegion(center: location.coordinate, radius: 500, identifier: identifier)
        
        region.notifyOnEntry = true // when they get there they will get a notification
        region.notifyOnExit = false // when they leave they will not get a notificaiton.
        
        locationManager.stopMonitoring(for: region)

    }
    
}// end of class curly


extension CoreLocationSession: CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations: \(locations)")
        // its an array because there are differernt points that will show
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        case .denied:
            print("denied")
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        default:
            break // apple may add more cases
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("to have user enter in a location/region - didEnterRegion - \(region)")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("didExitRegion - \(region)")
    }
    
}
