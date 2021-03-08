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
    var searchLocation: String = "Jaipur"
    var addedLink: String = "www.google.com"
    var student: Student!
    let geocoder = CLGeocoder()
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        
        
        geocoder.geocodeAddressString(searchLocation) { (placemarks, error) in
            guard let placemark = placemarks?.first else {
                print(error ?? "")
                return
            }
           
            let ano = MKPointAnnotation()
            ano.title = "Jazzy"
            ano.coordinate = placemark.location!.coordinate
            ano.subtitle = self.addedLink
            self.mapView.addAnnotation(ano)
            
        }
        super.viewDidLoad()
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
       
    }
    @IBAction func cancel(_ sender: Any) {
    }
}
