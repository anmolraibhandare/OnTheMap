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


class FinishAddLocationViewController: UIViewController {
    
    //MARK: Outlets and Properties
    
    @IBOutlet weak var mapView: MKMapView!
    
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
    
    @IBAction func finishAddLocation(_ sender: Any) {
        if let studentLocation = studentInformation {
            if UdacityClient.Auth.ObjectId == "" {
                UdacityClient.addStudentLocation(location: studentLocation) { (success, error) in
                    if success {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            print("Error")
                        }
                    }
                }
            } else {
                let alertVC = UIAlertController(title: "", message: "Overwrite the location?", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action: UIAlertAction) in
                    UdacityClient.updateStudentLocation(location: studentLocation) { (success, error) in
                        if success {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        } else {
                            DispatchQueue.main.async {
                                print("Error")
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
    
    
}
