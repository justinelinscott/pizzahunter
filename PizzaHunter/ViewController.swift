//
//  ViewController.swift
//  PizzaHunter
//
//  Created by Justine Linscott on 5/22/19.
//  Copyright © 2019 Justine Linscott. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation!
    var pizzaPlaces : [MKMapItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }
    
    @IBAction func whenZoomPressed(_ sender: UIBarButtonItem) {
        let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        let center = currentLocation.coordinate
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    @IBAction func whenSearchPressed(_ sender: UIBarButtonItem) {
        //sets up the actual request to search
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Pizza"
        
        //sets up the region for the search
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let center = currentLocation.coordinate
        let region = MKCoordinateRegion(center: center, span: span)
        request.region = region
        
        //creates and starts the search
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {return}
            //if there are parks in the region they are added to the array
            for mapItem in response.mapItems{
                self.pizzaPlaces.append(mapItem)
                //adds a marker where the lockation is
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.name
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pin = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.image = UIImage(named: "pizzaIcon")
        //pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.canShowCallout = true
        let button = UIButton(type: .detailDisclosure)
        pin.rightCalloutAccessoryView = button
        
        if annotation.isEqual(mapView.userLocation) {
            return nil
        } else {
            return pin
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("info button tapped")
        
        let annotation = view.annotation
        
        let alertController = UIAlertController(title: annotation?.title!, message: annotation?.description, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true)
        
        
    }
    
}

