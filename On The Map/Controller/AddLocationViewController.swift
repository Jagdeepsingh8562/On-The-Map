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
    @IBOutlet weak var addLinkTextField: UITextField!
    
    let geocoder = CLGeocoder()
    var coordinates = CLLocationCoordinate2D()
    let uniqueKey = "2345"
    let firstName = "Selena"
    let lastName = " Gomez"
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
        if textField == addLinkTextField {
            urlString = addLinkTextField.text ?? ""
        }
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
                
            target.locationRequest = LocationRequest(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: locationString, mediaURL: urlString, latitude: coordinates.latitude, longitude: coordinates.longitude)
            
        }
    }
    
    @IBAction func findButton(_ sender: Any) {
//        geocoder.geocodeAddressString(locationString) { (placemarks, error) in
//            guard let placemark = placemarks?.first else {
//                print(error?.localizedDescription ?? "")
//                return
//            }
//                self.coordinates = placemark.location!.coordinate
//        }
            self.performSegue(withIdentifier: "verifySegue", sender: nil)
        

     
    }
//
    
    @IBAction func cancel(_ sender: Any) {
    }
}
