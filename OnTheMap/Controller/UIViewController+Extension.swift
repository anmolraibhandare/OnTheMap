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
    
    // MARK: Add location button tapped
    
    @IBAction func addLocationButton(_ enabled: Bool, button: UIButton){
        performSegue(withIdentifier: "addLocationButton", sender: nil)
    }
    
    // MARK: Logout tapped
    
    @IBAction func logout(_ sender: Any) {
        UdacityClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    // MARK: Enable buttons
    
    func enableButton(_ enabled: Bool, button: UIButton) {
        if enabled{
            button.isEnabled = true
        } else {
            button.isEnabled = false
        }
    }
    
    //MARK: Show alerts
    
    func showLoginFailure(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }

}
