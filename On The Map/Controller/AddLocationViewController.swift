//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Jagdeep Singh on 03/03/21.
//

import Foundation
import CoreLocation
import UIKit

class AddLocationViewController: UIViewController , UITextFieldDelegate{
    @IBOutlet weak var addLocationTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addLinkTextField: UITextField!
    
    let geocoder = CLGeocoder()
    var coordinates = CLLocationCoordinate2D()
    let uniqueKey = "12345"
    let firstName = "Selly"
    let lastName = " G"
    var locationString = ""
    var urlString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        addLocationTextField.delegate = self
        addLinkTextField.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == addLocationTextField {
            locationString = textField.text ?? ""
        }
        geocoder.geocodeAddressString(locationString) { (placemarks, error) in
            guard let placemark = placemarks?.first else {
                print(error?.localizedDescription ?? "")
                return
            }
                self.coordinates = placemark.location!.coordinate
        }
        print( urlString + " " + locationString)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? VerifyLocationViewController {
                
            target.locationRequest = LocationRequest(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: locationString, mediaURL: addLinkTextField.text ?? "", latitude: coordinates.latitude, longitude: coordinates.longitude)
            
        }
    }
    
    @IBAction func findButton(_ sender: Any) {
        guard let url = URL(string: self.addLinkTextField.text!), UIApplication.shared.canOpenURL(url) else {
            self.showAlert(message: "Please insert 'https://' in your link.", title: "Invalid URL")
            return
        }
            self.performSegue(withIdentifier: "verifySegue", sender: nil)
    }
//
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
