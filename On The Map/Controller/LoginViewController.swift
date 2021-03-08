//
//  LoginViewController.swift
//  On The Map
//
//  Created by Jagdeep Singh on 02/03/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginViaGoogleButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.setNavigationBarHidden(true, animated: true)
        
    }

    @IBAction func loginAction(_ sender: Any) {
        UdacityAPI.loginRequest(username:emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: loginHandeResponse(success:error:))
        
    }
    func loginHandeResponse(success: Bool, error: Error?) {
        if success {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
            } }
            else {
                print(error ?? "")
            }
        
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func loginViaGoogle(_ sender: Any) {
       // let app
        performSegue(withIdentifier: "completeLogin", sender: nil)
    }
}

