//
//  ViewController.swift
//  CorelocationDemo.Feb21
//
//  Created by Pursuit on 2/21/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit
import MapKit

class mapViewController: UIViewController {
    
    // need to import mapkit
    @IBOutlet weak var mapView: MKMapView!
    
    
    private let locationSession = CoreLocationSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        // testing cpnverting to placemark
            //convertCoordinateToPlaceMark()
        
        // testing converting from placename to coordiates
        convertToPlaceName()
        
        // configure map view...
        // attempt to show the users current location ...
        mapView.showsUserLocation = true
        
        mapView.delegate = self
        
        //makeAnnotation()
        loadMap()
    }
    
    private func makeAnnotation() -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        // in order to add the pins on the image
        for location in Location.getLocations() {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = location.title
            annotations.append(annotation)
        }
        
        return annotations
    }
    
    private func loadMap(){
        // this will make the annotations onto the map
        // configure the map view
        let annotations = makeAnnotation()
        
        mapView.addAnnotations(annotations)
        
        mapView.showAnnotations(annotations, animated: true)
    }

    private func convertCoordinateToPlaceMark(){
         let location = Location.getLocations()[2] // now we have a location
            locationSession.convertCoordinateToPlacemark(coordinate: location.coordinate)
        
    }
    
    private func convertToPlaceName(){
        //let placeName = "eiffel tower" doesnt work because it is not as powerful
        // Brooklyn Museum does work
        locationSession.convertPlaceNameToCoordinate(addressString: "Brooklyn Museum")
    }
    
    
}

extension mapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("didSelect")
        // called when it is selected
    }
    
    // constructing an annotation view 
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {
            return nil
        }
        let identifier = "locationAnnotation"
        var annotationView: MKPinAnnotationView
        
        // try to deque and reuse annotation view
        if let deqeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            annotationView = deqeueView
        } else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // when the pin is clicked
        print("calloutAccessoryControlTapped")
    }
    
}
