//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Jagdeep Singh on 03/03/21.
//

import Foundation

import UIKit

class AddLocationViewController: UIViewController {
    @IBOutlet weak var addLocationTextField: UITextField!
    @IBOutlet weak var addLinkTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func findButton(_ sender: Any) {
        VerifyLocationViewController().searchLocation = addLinkTextField.text!
        
        performSegue(withIdentifier: "verifySegue", sender: nil)
    }
    @IBAction func cancel(_ sender: Any) {
    }
}
