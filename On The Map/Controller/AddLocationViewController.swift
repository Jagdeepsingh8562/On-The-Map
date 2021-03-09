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
    let firstName = "Jsdfghjkl;"
    let lastName = " B"
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
        print( urlString + " " + locationString)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let target = segue.destination as? VerifyLocationViewController {
            target.locationRequest = LocationRequest(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: locationString, mediaURL: urlString, latitude: coordinates.latitude, longitude: coordinates.longitude)
            
        }
    }
    
    @IBAction func findButton(_ sender: Any) {
        geocoder.geocodeAddressString(locationString) { (placemarks, error) in
            guard let placemark = placemarks?.first else {
                print(error ?? "")
                return
            }
            DispatchQueue.main.async {
                self.coordinates = placemark.location!.coordinate  }
        }
        
        performSegue(withIdentifier: "verifySegue", sender: nil)
        
//        UdacityAPI.postStudentLocation(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: addLocationTextField.text ?? "", mediaURL: addLinkTextField.text ?? "", latitude: coordinates.latitude, longitude: coordinates.longitude, completion: handlePostLocation(success:error:))
     
    }
//    func handlePostLocation(success: Bool, error: Error?) {
//        if success {
//            self.objectId = UdacityAPI.Auth.objectId
//                self.createdAt = UdacityAPI.Auth.createdAt
//                performSegue(withIdentifier: "verifySegue", sender: nil)
//                print("post location success")}
//    else {
//            print(error ?? "")
//        }
//    }
    
    @IBAction func cancel(_ sender: Any) {
    }
}
