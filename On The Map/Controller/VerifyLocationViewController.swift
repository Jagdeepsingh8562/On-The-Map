//
//  VerifyLocationViewController.swift
//  On The Map
//
//  Created by Jagdeep Singh on 03/03/21.
//

import UIKit
import MapKit
class VerifyLocationViewController: UIViewController ,MKMapViewDelegate {
    
    var student: Student!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        settingUpTextField()
    }
    func settingUpTextField(){
        let colorPlaceholderText = NSAttributedString(string: "Enter Your Location Here", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                linkTextField.attributedPlaceholder = colorPlaceholderText
        linkTextField.textColor = UIColor.white
        linkTextField.backgroundColor = UIColor.systemBlue
    }
    
    @IBAction func submit(_ sender: Any) {
        
    }
    @IBAction func cancel(_ sender: Any) {
    }
}
