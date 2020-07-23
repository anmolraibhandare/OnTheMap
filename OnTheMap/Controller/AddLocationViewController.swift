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
    
    
    @IBOutlet weak var locationTextField: LoginTextField!
    
    @IBOutlet weak var linkTextField: LoginTextField!
    
    @IBOutlet weak var findLocationButton: LoginButton!
    
    var objectId: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        linkTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    @IBAction func cancelAddLocation(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findAddLocation(_ sender: Any) {
        
    
    }
}
