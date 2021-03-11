//
//  MapViewController.swift
//  On The Map
//
//  Created by Jagdeep Singh on 03/03/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    var locations = [Student]()
    var annotations = [MKPointAnnotation]()
    override func viewDidLoad() {
        super.viewDidLoad()
         //let locations: [Student] = UdacityAPI.Auth.student
        activityView.hidesWhenStopped = true
        UdacityAPI.getStudentLocation(completion: handleStudentResponse(success:error:))
    }
    
    func handleStudentResponse(success: Bool, error: Error?) {
        if success {
            locations.append(contentsOf: UdacityAPI.Auth.students)
            print("map loaded")
            for dictionary in locations {
                
                let lat = CLLocationDegrees(dictionary.latitude)
                let long = CLLocationDegrees(dictionary.longitude)
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = dictionary.firstName
                let last = dictionary.lastName
                let mediaURL = dictionary.mediaURL
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)

            }
            
            // When the array is complete, we add the annotations to the map.
            
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.annotations)
                self.activityView.stopAnimating()
            } 
        }
        else {
            guard let error = error else {
                self.showAlert(message: "Something Wrong please try again", title: "Error")
                return
            }
            self.showAlert(message: error.localizedDescription, title: "Error")
        }
    }
    
    @IBAction func addLocation(_ sender: Any) {
      
        performSegue(withIdentifier: "addStudentLocation", sender: nil)
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        UdacityAPI.logoutRequest { (success, error) in
            if success {
                print("logout")
               // self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            } else {
                guard let error = error else {
                    self.showAlert(message: "Something Wrong please try again", title: "Error")
                    return
                }
                self.showAlert(message: error.localizedDescription, title: "Error")
            }
        }
    }
    @IBAction func refresh(_ sender: Any) {
        self.activityView.startAnimating()
        mapView.removeAnnotations(annotations)
        self.annotations.removeAll()
        UdacityAPI.getStudentLocation(completion: handleStudentResponse(success:error:))
        
    }
    
    // MARK: - MKMapViewDelegate
    
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                openLink(toOpen)
            }
        }
    }
}
