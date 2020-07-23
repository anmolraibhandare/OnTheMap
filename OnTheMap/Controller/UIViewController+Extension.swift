//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Anmol Raibhandare on 7/22/20.
//  Copyright © 2020 Anmol Raibhandare. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    @IBAction func addLocationButton(_ enabled: Bool, button: UIButton){
        performSegue(withIdentifier: "addLocationButton", sender: nil)
    }

}
