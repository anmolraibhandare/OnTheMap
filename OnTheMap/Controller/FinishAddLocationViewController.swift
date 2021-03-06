//
//  FinishAddLocationViewController.swift
//  OnTheMap
//
//  Created by Anmol Raibhandare on 7/23/20.
//  Copyright © 2020 Anmol Raibhandare. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class FinishAddLocationViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: Outlets and Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var finishButton: LoginButton!

    var studentInformation: StudentLocation?
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let studentLocation = studentInformation {
            let studentLocation = Location(
                objectId: studentLocation.objectId ?? "",
                uniqueKey: studentLocation.uniqueKey,
                firstName: studentLocation.firstName,
                lastName: studentLocation.lastName,
                mapString: studentLocation.mapString,
                mediaURL: studentLocation.mediaURL,
                latitude: studentLocation.latitude,
                longitude: studentLocation.longitude,
                createdAt: studentLocation.createdAt ?? "",
                updatedAt: studentLocation.updatedAt ?? ""
            )
            displayLocation(location: studentLocation)
        }
    }

    //MARK: Finish button tapped
    
    @IBAction func finishAddLocation(_ sender: Any) {
        setFinishAdding(true)
        // If the student information is obtained post the new student info
        if let studentLocation = studentInformation {
            if UdacityClient.Auth.ObjectId == "" {
                UdacityClient.addStudentLocation(location: studentLocation) { (success, error) in
                    if success {
                        DispatchQueue.main.async {
                            // Dismiss if the information is successfully entered
                            self.setFinishAdding(true)
                            self.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showLoginFailure(title: "Error", message: error?.localizedDescription ?? "")
                            self.setFinishAdding(false)
                        }
                    }
                }
            } else {
                let alertVC = UIAlertController(title: "", message: "Overwrite the location?", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action: UIAlertAction) in
                    UdacityClient.updateStudentLocation(location: studentLocation) { (success, error) in
                        if success {
                            DispatchQueue.main.async {
                                self.setFinishAdding(true)
                                self.dismiss(animated: true, completion: nil)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.showLoginFailure(title: "Error", message: error?.localizedDescription ?? "")
                                self.setFinishAdding(false)
                            }
                        }
                    }
                }))
                alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
                    DispatchQueue.main.async {
                        alertVC.dismiss(animated: true, completion: nil)
                    }
                }))
                self.present(alertVC, animated: true)
            }
        }
    }
    
    // MARK: Pull new location in the map
    
    private func pullCoordinate(location: Location) -> CLLocationCoordinate2D? {
        if let latitude = location.latitude, let longitude = location.longitude {
            return CLLocationCoordinate2DMake(latitude, longitude)
        }
        return nil
    }
    
    private func displayLocation(location: Location) {
        mapView.removeAnnotations(mapView.annotations)
        if let coordinate = pullCoordinate(location: location) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = location.studentName //"\(location.firstName)" + " " + "\(location.lastName)"
            annotation.subtitle = location.mediaURL ?? ""
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
            
        }
    }
    
    func setFinishAdding(_ finishAdding: Bool){
        if finishAdding {
            activityIndicator.startAnimating()
            finishButton.isEnabled = true
        } else{
            activityIndicator.stopAnimating()
            finishButton.isEnabled = false
        }
        finishButton.isEnabled = !finishAdding
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
