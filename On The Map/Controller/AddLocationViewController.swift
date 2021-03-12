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
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    let geocoder = CLGeocoder()
    var coordinates = CLLocationCoordinate2D()
    var uniqueKey = "12345"
    var firstName = "Sellyyyyyyyyyy"
    var lastName = " G"
    var locationString = ""
    var urlString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        uniqueKey = UdacityAPI.Auth.key
        firstName = UdacityAPI.Auth.firstName
        lastName = UdacityAPI.Auth.lastName
        addLocationTextField.delegate = self
        addLinkTextField.delegate = self
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == addLocationTextField {
            locationString = textField.text ?? ""
        }
                
        print( urlString + " " + locationString)
        
    }
    func geocoding(_ str:String){
        geocoder.geocodeAddressString(locationString) { (placemarks, error) in
            guard let placemark = placemarks?.first else { self.showAlert(message: "Please try again later.", title: "Error")
                        self.setLoading(false)
                        return
                    }
            if let error = error  {
                        self.showAlert(message: error.localizedDescription, title: "Location Not Found")
                        self.setLoading(false)
                        return
                    }
            self.setLoading(false)
                        self.coordinates = placemark.location!.coordinate
                        self.performSegue(withIdentifier: "verifySegue", sender: nil)

                }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? VerifyLocationViewController {
                
            target.locationRequest = LocationRequest(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: locationString, mediaURL: addLinkTextField.text ?? "", latitude: coordinates.latitude, longitude: coordinates.longitude)
            
        }
    }
    
    @IBAction func findButton(_ sender: Any) {
        setLoading(true)
        
        guard let url = URL(string: self.addLinkTextField.text!), UIApplication.shared.canOpenURL(url) else {
            self.showAlert(message: "Please insert 'https://' in your link.", title: "Invalid URL")
            setLoading(false)
            return
        }
        geocoding(locationString)
    }
//
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

func setLoading(_ loading: Bool) {
    if loading {
        DispatchQueue.main.async {
            self.activityView.startAnimating()
        }
    } else {
        DispatchQueue.main.async {
            self.activityView.stopAnimating()
            
        }
    }
    DispatchQueue.main.async {
        self.addLocationTextField.isEnabled = !loading
        self.addLinkTextField.isEnabled = !loading
        self.addButton.isEnabled = !loading
    }
}
}
