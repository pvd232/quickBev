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
class BarMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var bars = [Bar]()
    var customAnnotations = [CustomAnnotation]()
    
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
        
        func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?)-> Void) {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address) { (placemarks, error) in
                guard let placemarks = placemarks,
                    let location = placemarks.first?.location?.coordinate else {
                        completion(nil)
                        return
                }
                completion(location)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let group = DispatchGroup()
        fetchBars() {bars in
            guard bars != nil else {
                print("error1")
                return
            }
            self.bars = bars!
            //https://stackoverflow.com/questions/58319322/using-dispatch-group-in-multi-for-loop-with-urlsession-tasks
            for bar in self.bars {
                group.enter()
                getLocation(from: bar.address) { location in
                    if location != nil {
                        print("Location is", location.debugDescription)
                        bar.coordinate = location
                        group.leave()
                        //Add a custom pin to the map
                        let customCoordinate = bar.coordinate
                        
                        let customAnnotation = CustomAnnotation(coordinate: customCoordinate!, title: "\(bar.name)", image: (UIImage(named: "360bridge"))!)
                        self.mapView.addAnnotation(customAnnotation)
                    }
                }
            }
            group.notify(queue: .main, execute: { // executed after all async calls in for loop finish
                print("done with all async calls weeee")
                // do stuff
            })
        }}
    
    private func fetchBars(completion: @escaping ([Bar]?) -> Void) {
        AF.request("http://127.0.0.1:5000/getBars", method: .get)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    
                    guard let rawBars = response.data
                        else {
                            return completion(nil)
                    }
                    let jsonDecoder = JSONDecoder()
                    
                    let bars = try! jsonDecoder.decode([Bar].self, from: rawBars)
                    
                    completion(bars)
                case .failure(let error):
                    completion(nil)
                    print(error)
                }
        }
    }
    
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
        
        let customAnnotation = annotation as! CustomAnnotation
        
        //         programatically creating an image view to hold the picture of the 360 bridge for the custom annotation
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        imageView.image = customAnnotation.image
        
        let detailView = UIView()
        detailView.addSubview(imageView)
        let widthConstraint = NSLayoutConstraint(item: detailView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        detailView.addConstraint(widthConstraint)
        let heightConstraint = NSLayoutConstraint(item: detailView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        detailView.addConstraint(heightConstraint)
        
        // add button
        let button = RoundButton(frame: CGRect(x: 50, y: 200, width: 100, height: 40))
        button.backgroundImageColor = .blue
        button.setTitle("B", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        detailView.addSubview(button)
        annotationView?.detailCalloutAccessoryView = detailView
        return annotationView
    }
    @objc func buttonAction(sender: RoundButton!) {
       let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                 let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DrinkListTableViewController") as! DrinkListTableViewController
                 
                 let navigationController = self.navigationController!
                 navigationController.setViewControllers([nextViewController], animated: true)
    }
    
}

//                        //TODO finish getting bar locations
//                        //https://developer.apple.com/documentation/corelocation/converting_between_coordinates_and_user-friendly_place_names
//
//                        //TODO make the bottom of the map view draggable downwards
//                        //https://fluffy.es/facebook-draggable-bottom-card-modal-1/
//                        address = getCoordinate()
