//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Anmol Raibhandare on 7/22/20.
//  Copyright © 2020 Anmol Raibhandare. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets and properties
    
    @IBOutlet weak var locationTextField: LoginTextField!
    @IBOutlet weak var linkTextField: LoginTextField!
    @IBOutlet weak var findLocationButton: LoginButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var objectId: String?
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        linkTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    // MARK: Cancel adding location
    
    @IBAction func cancelAddLocation(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Find entered location
    
    @IBAction func findAddLocation(_ sender: Any) {
        let newLocation = locationTextField.text
        guard let url = URL(string: self.linkTextField.text!), UIApplication.shared.canOpenURL(url)
            else {
                    print("Invalid Input!")
                    return
        }
        geoPosition(newLocation: newLocation ?? "")
        
    }
      
    // MARK: Find new location geocode
    
    private func geoPosition(newLocation: String) {
        CLGeocoder().geocodeAddressString(newLocation) { (placemarker, error) in
            if let error = error {
                print("Location not found!")
            } else {
                var location: CLLocation?
                
                if let marker = placemarker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
                    self.placeNewLocation(location.coordinate)
                } else {
                    print("Error!")
                }
            }
        }
    }
    
    // MARK: Send Info to FinalController
    
    private func placeNewLocation(_ coordinate: CLLocationCoordinate2D) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "FinishAddLocationViewController") as! FinishAddLocationViewController
        // send coordinate to create student information
        controller.studentInformation = createStudentInfo(coordinate)
        // controller now contains the information in the form of StudentLocation (JSON response)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: Create student information of the user to push in next controller
    
    private func createStudentInfo(_ coordinate: CLLocationCoordinate2D) -> StudentLocation {
        var info = [
            "uniqueKey": UdacityClient.Auth.key,
            "firstName": UdacityClient.Auth.firstName,
            "lastName": UdacityClient.Auth.lastName,
            "mapString": locationTextField.text!,
            "mediaURL": linkTextField.text!,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
        ] as [String: AnyObject]
        
        if let objectId = objectId {
            info["objectId"] = objectId as AnyObject
            print("object Id: " + "\(objectId)")
        }
        return StudentLocation(info)
    }
    
        
    // MARK: - UITextField Delegate methods
    
    
    
    
    
}
