//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Anmol Raibhandare on 7/22/20.
//  Copyright © 2020 Anmol Raibhandare. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Outlets and Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var locations = [StudentLocation]()
    var annotations = [MKPointAnnotation]()

    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getStudentPins()
    }
    
    // MARK: Refresh button tapped
    
    @IBAction func refresh(_ sender: Any) {
        getStudentPins()
    }
    
    // MARK: Get all student pins
    
    func getStudentPins() {
        self.activityIndicator.startAnimating()
        UdacityClient.getStudentLocation { location, error in
            self.mapView.removeAnnotations(self.annotations)
            self.annotations.removeAll()
            self.locations = location ?? []
            for dictionary in location ?? [] {
                let lat = CLLocationDegrees(dictionary.latitude ?? 0.0)
                let long = CLLocationDegrees(dictionary.longitude ?? 0.0)
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let space = " "
                let name = dictionary.firstName + space + dictionary.lastName
                let mediaURL = dictionary.mediaURL
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(name)"
                annotation.subtitle = mediaURL
    
                self.annotations.append(annotation)
            }
        
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.annotations)
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - MKMapViewDelegate

    // Here we create a view with a "right callout accessory view" an generate a styled pin.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
}

