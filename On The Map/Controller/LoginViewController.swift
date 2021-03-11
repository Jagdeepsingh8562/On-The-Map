//
//  LoginViewController.swift
//  On The Map
//
//  Created by Jagdeep Singh on 02/03/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setLoggingIn(false)
    }
    

    @IBAction func loginAction(_ sender: Any) {
        setLoggingIn(true)
        UdacityAPI.loginRequest(username:emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: loginHandeResponse(success:error:))
        
    }
    func loginHandeResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            DispatchQueue.main.async{
                self.passwordTextField.text = ""
                self.emailTextField.text = ""
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
            } }
        else {
            guard let error = error else {
                self.showAlert(message: "Something Wrong please try again", title: "Error")
                return
            }
            print(error)
            self.showAlert(message: "Please enter vaild email and password", title: "Login Error")
        }
        
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            DispatchQueue.main.async {
                self.activityView.startAnimating()
                
            }
        } else {
            DispatchQueue.main.async {
                self.activityView.stopAnimating()
                
            }
        }
        DispatchQueue.main.async {
            self.emailTextField.isEnabled = !loggingIn
            self.passwordTextField.isEnabled = !loggingIn
            self.loginButton.isEnabled = !loggingIn
            self.signUpButton.isEnabled = !loggingIn
        }
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        setLoggingIn(true)
        openLink("https://auth.udacity.com/sign-up?next=https://classroom.udacity.com")
        
    }
    
    
}

