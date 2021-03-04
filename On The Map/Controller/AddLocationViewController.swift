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
    override func viewDidLoad() {
        super.viewDidLoad()
        settingUpTextField()
    }
    func settingUpTextField(){
        let colorPlaceholderText = NSAttributedString(string: "Enter Your Location Here", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                addLocationTextField.attributedPlaceholder = colorPlaceholderText
        addLocationTextField.textColor = UIColor.white
        addLocationTextField.backgroundColor = UIColor.systemBlue
    }
    @IBAction func findButton(_ sender: Any) { performSegue(withIdentifier: "verifySegue", sender: nil)
    }
    @IBAction func cancel(_ sender: Any) {
    }
}
