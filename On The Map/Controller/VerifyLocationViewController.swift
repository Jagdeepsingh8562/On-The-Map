//
//  VerifyLocationViewController.swift
//  On The Map
//
//  Created by Jagdeep Singh on 03/03/21.
//

import UIKit
import MapKit
class VerifyLocationViewController: UIViewController ,MKMapViewDelegate {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func submit(_ sender: Any) {
    }
    @IBAction func cancel(_ sender: Any) {
    }
}
