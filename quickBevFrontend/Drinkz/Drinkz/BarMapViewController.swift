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

protocol NewBarPickedProtocol {
    func barPicked ()
}
class BarMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate{
    
    @UsesAutoLayout var mapView = MKMapView()
    
    let locationManager = CLLocationManager()
    var customAnnotations = [CustomAnnotation]()
    var barPickerDelegate: NewBarPickedProtocol? = nil
    @UsesAutoLayout private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .systemBackground
        makeBarServiceCall()
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder not set up")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mapView)
        self.view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.4)
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        let margins = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mapView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            mapView.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            mapView.heightAnchor.constraint(equalTo: mapView.superview!.heightAnchor),
            mapView.widthAnchor.constraint(equalTo: margins.widthAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalTo: activityIndicator.superview!.widthAnchor),
            activityIndicator.heightAnchor.constraint(equalTo: activityIndicator.superview!.heightAnchor)
        ])
        let backBtnImage = UIImage(systemName: "xmark")?.withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
        let backBtn = UIBarButtonItem(image: backBtnImage,
                                      style: .plain,
                                      target: self,
                                      action: #selector(back))
        navigationItem.leftBarButtonItem = backBtn
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
            makeBarServiceCall()
        }
    }
    @objc func back () {
        dismiss(animated: true, completion: nil)
    }
    func makeBarServiceCall () {
        activityIndicator.startAnimating()
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let group = DispatchGroup()
        //https://stackoverflow.com/questions/58319322/using-dispatch-group-in-multi-for-loop-with-urlsession-tasks
        for bar in CheckoutCart.shared.barArray {
            if bar.coordinateString != "" {
                let latandLonArray = bar.coordinateString?.split(separator: ",")
                let lattitude = latandLonArray![0].split(separator: ":")[1].trimmingCharacters(in: .whitespacesAndNewlines)
                let longitude = latandLonArray![1].split(separator: ":")[1].trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ")", with: "")
                let locationCoordinate = CLLocationCoordinate2D(latitude: Double(lattitude)!, longitude: Double(longitude)!)
                bar.coordinate = locationCoordinate
            }
            else {
                group.enter()
                bar.getLocation(from: bar.address!) { location in
                    if location != nil {
                        bar.coordinate = location!
                        bar.coordinateString = String(describing:location!)
                    }
                    group.leave()
                }
            }
            //Add a custom pin to the map
        }
        group.notify(queue: .main, execute: {
            for bar in CheckoutCart.shared.barArray {
                let customCoordinate = bar.coordinate
                let customAnnotation = CustomAnnotation(coordinate: customCoordinate!, title: "\(bar.name!)", image: (UIImage(named: "blaise"))!, barId: bar.id!)
                self.mapView.addAnnotation(customAnnotation)
            }
            self.activityIndicator.stopAnimating()
            
            CoreDataManager.sharedManager.saveContext(context: managedContext)
            // executed after all async calls in for loop finish
            print("done with all async calls weeee")
        })
    }
    
    override func didReceiveMemoryWarning() {
        // Dispose of any resources that can be recreated.
        super.didReceiveMemoryWarning()
        self.mapView.removeAnnotations(mapView.annotations)
        self.mapView.delegate = nil
        self.mapView.removeFromSuperview()
    }
    
    //MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location manager error", error)
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
        
        // programatically creating an image view to hold the picture of the 360 bridge for the custom annotation
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
        button.setTitle("Select", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.params["barId"] = customAnnotation.barId as String?
        detailView.addSubview(button)
        annotationView?.detailCalloutAccessoryView = detailView
        return annotationView
    }
    @objc func buttonAction(sender: RoundButton!) {
        //https://stackoverflow.com/questions/24814646/attach-parameter-to-button-addtarget-action-in-swift
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        if let clickedBar = CheckoutCart.shared.bars!.first(where: { ($0 as! Bar).id == sender.params["barId"] }) as? Bar {
            CheckoutCart.shared.userBar = clickedBar
            CheckoutCart.shared.userBar!.drinks =  clickedBar.drinks!
            CoreDataManager.sharedManager.saveContext(context: managedContext)
            barPickerDelegate?.barPicked()
        }
        dismiss(animated: true) {
            
        }
    }
}
