//
//  VerifyLocationViewController.swift
//  On The Map
//
//  Created by Jagdeep Singh on 03/03/21.
//

import UIKit
import MapKit
import CoreLocation

class VerifyLocationViewController: UIViewController ,MKMapViewDelegate {
    
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    var coordinates = CLLocationCoordinate2D()
    var searchLocation: String = "Jaipur"
    var addedLink: String = "https://www.google.com"
    let geocoder = CLGeocoder()
    var objectId: String = ""
    var createdAt: String = ""
    var updateAt: String = ""
    var locationRequest: LocationRequest?
   
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let locationRequest = locationRequest else { return }
        self.searchLocation = locationRequest.mapString
        self.coordinates = CLLocationCoordinate2D(latitude: locationRequest.latitude, longitude: locationRequest.longitude)
        self.addedLink = locationRequest.mediaURL
     
        print(addedLink)
        geocoder.geocodeAddressString(searchLocation) { (placemarks, error) in
            guard let placemark = placemarks?.first else {
                print(error ?? "")
                return
            }
            self.coordinates = placemark.location!.coordinate
        }
            let ano = MKPointAnnotation()
        
        
        ano.title = locationRequest.firstName + locationRequest.lastName
            ano.coordinate = coordinates
            ano.subtitle = self.addedLink
            self.mapView.addAnnotation(ano)
            self.mapView.showAnnotations([ano], animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
   
    @IBAction func submit(_ sender: Any) {
        guard let locationRequest = locationRequest else { return }

        UdacityAPI.postStudentLocationRe(uniqueKey: locationRequest.uniqueKey, firstName: locationRequest.firstName, lastName: locationRequest.lastName, mapString: searchLocation, mediaURL: addedLink, latitude: coordinates.latitude, longitude: coordinates.longitude, completion: handlePostLocation(success:error:))
       
    }
    func handlePostLocation(success: Bool, error: Error?) {
        if success {
            guard let locationRequest = locationRequest else { return }
            UdacityAPI.putStudentLocation(uniqueKey: locationRequest.uniqueKey, firstName: locationRequest.firstName, lastName: locationRequest.lastName, mapString: searchLocation, mediaURL: addedLink, latitude: coordinates.latitude, longitude: coordinates.longitude, completion: handlePutLocationResponse(success:error:))
            createdAt = UdacityAPI.Auth.createdAt
            objectId = UdacityAPI.Auth.objectId
            updateAt = UdacityAPI.Auth.updatedAt
            let student = Student(firstName: locationRequest.firstName, lastName: locationRequest.lastName, longitude: locationRequest.longitude, latitude: locationRequest.longitude, mapString: searchLocation, mediaURL: addedLink, uniqueKey: locationRequest.uniqueKey, objectID: objectId, createdAt: createdAt, updatedAt: updateAt)
            
           UdacityAPI.Auth.students.append(student)
            self.dismiss(animated: true, completion: nil)
        }else {
            guard let error = error else {
                self.showAlert(message: "Something Wrong please try again", title: "Error")
                return
            }
            self.showAlert(message: error.localizedDescription, title: "Error")
        }
    }
    
    func handlePutLocationResponse(success: Bool, error: Error?) {
        if success {
            
            print("put location success")
        }else {
            guard let error = error else {
                self.showAlert(message: "Something Wrong please try again", title: "Error")
                return
            }
            self.showAlert(message: error.localizedDescription, title: "Error")
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
