//
//  ViewController.swift
//  OnTheMap
//
//  Created by Anmol Raibhandare on 7/20/20.
//  Copyright © 2020 Anmol Raibhandare. All rights reserved.
//

import UIKit
import FacebookLogin

class ViewController: UIViewController, LoginButtonDelegate {
    
    
    // MARK: Facebook Login Button Delegate functions
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Logged out of Facebook Acoount")
    }
    func loginButtonWillLogin(_ loginButton: FBLoginButton) -> Bool {
        return true
    }
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print("Login Successful")
    }
    
    // MARK: Outlets and Properties
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Facebook login button displayed
        let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: 35, y: 775, width: view.frame.width - 75, height: 45)
        view.addSubview(loginButton)
        
        // If facebook login is successful, token is generated
        if let token = AccessToken.current {
            // User is logged in, go to next view controller
            fetchprofile()
            goToDifferentView()
        }
        loginButton.permissions = ["public_profile", "email"]
    }
    
    // Once logged in, go to nextViewController
    func goToDifferentView() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // Fetch user profile
    func fetchprofile() {
        print("Fetch Profile")
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields" : "email, name"])
        request.start { (connection, result, error) in
            print("\(result ?? "")")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    // MARK: Login Button Tapped

    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(true)
        // Call UdacityClient login function with email and password from User's input
        UdacityClient.login(email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleloginResponse(success:error:))
    }
    
    func handleloginResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success{
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "login", sender: nil)
            }
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    // MARK: SignUp Button Tapped
    
    @IBAction func signUpTapped(_ sender: Any) {
        // Open Udacity's Sign Up page
        UIApplication.shared.open(UdacityClient.Endpoints.signUp.url, options: [:], completionHandler: nil)
    }
    
    func setLoggingIn(_ loggingIn: Bool){
        if loggingIn {
            activityIndicator.startAnimating()
        } else{
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }

}

