//
//  ViewController.swift
//  OnTheMap
//
//  Created by Anmol Raibhandare on 7/20/20.
//  Copyright © 2020 Anmol Raibhandare. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginViaFacebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    @IBAction func loginTapped(_ sender: Any) {
        UdacityClient.login(email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleloginResponse(success:error:))
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
    }
    
    func handleloginResponse(success: Bool, error: Error?) {
        if success{
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "login", sender: nil)
            }
        } else {
            
        }
    }
    
    
}

