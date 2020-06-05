//
//  BarMapViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 6/4/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Alamofire

//https://www.hackingwithswift.com/books/ios-swiftui/customizing-mkmapview-annotations
class BarMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var bars = [Bar]()
    var barLocations = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow //Moves view to user position
        
        
        //Add a custom pin to the map
        let customCoordinate = CLLocationCoordinate2D(latitude: 30.26, longitude: -97.74)
        let customAnnotation = CustomAnnotation(coordinate: customCoordinate, title: "PeckerHeads")
        mapView.addAnnotation(customAnnotation)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
//        fetchBars() {fetchedBars in
//            self.bars = fetchedBars!
        }
//    }
//    private func fetchBars(completion: @escaping ([Bar]?) -> Void) {
//        AF.request("http://127.0.0.1:5000/patientRequests", method: .get)
//            .validate()
//            .response { response in
//                switch response.result {
//                case .success:
//
//                    guard let rawBars = response.data
//                        else {
//                            return completion(nil)
//                    }
//
//                    let jsonDecoder = JSONDecoder()
//
//                    let bars = try! jsonDecoder.decode([Bar].self, from: rawBars)
//                    for bar in bars {
//                        //TODO finish getting bar locations
//                        //https://developer.apple.com/documentation/corelocation/converting_between_coordinates_and_user-friendly_place_names
//
//                        //TODO make the bottom of the map view draggable downwards
//                        //https://fluffy.es/facebook-draggable-bottom-card-modal-1/
//                        address = getCoordinate()
//                    }
//
//
//                    completion(createdPatientRequests)
//                case .failure(let error):
//                    completion(nil)
//                    print(error)
//                }
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func getCoordinate( addressString : String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    //MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomAnnotation) {
            return nil
        }
        
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        //        let customAnnotation = annotation as! CustomAnnotation
        
        // programatically creating an image view to hold the picture of the 360 bridge for the custom annotation
        //        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        //        imageView.image = customAnnotation.image
        //
        //        let detailView = UIView()
        //        detailView.addSubview(imageView)
        //        let widthConstraint = NSLayoutConstraint(item: detailView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        //        detailView.addConstraint(widthConstraint)
        //        let heightConstraint = NSLayoutConstraint(item: detailView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        //        detailView.addConstraint(heightConstraint)
        //
        //        annotationView?.detailCalloutAccessoryView = detailView
        
        return annotationView
    }
    
}
