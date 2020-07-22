//
//  ViewController.swift
//  OnTheMap
//
//  Created by Anmol Raibhandare on 7/20/20.
//  Copyright © 2020 Anmol Raibhandare. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, LoginButtonDelegate {
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    func loginButtonWillLogin(_ loginButton: FBLoginButton) -> Bool {
        return true
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print("Login Successful")
    }
    

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: 35, y: 800, width: view.frame.width - 75, height: 45)
        view.addSubview(loginButton)
        
        if let token = AccessToken.current,
            !token.isExpired {
            let token = token.tokenString
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields" : "email, name"], tokenString: token, version: nil, httpMethod: .get)
            request.start { (connection, result, error) in
                print("\(result ?? "")")
            }
            // User is logged in, do work such as go to next view controller.
        }
        
        loginButton.permissions = ["public_profile", "email"]
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
        UIApplication.shared.open(UdacityClient.Endpoints.signUp.url, options: [:], completionHandler: nil)
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

