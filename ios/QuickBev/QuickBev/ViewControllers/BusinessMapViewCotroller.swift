//
//  BusinessMapViewCotroller.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 1/29/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

protocol NewBusinessPickedProtocol {
    func businessPicked()
}

class BusinessMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {
    @UsesAutoLayout var mapView = MKMapView()
    @UsesAutoLayout private var activityIndicator = UIActivityIndicatorView(style: .large)

    let locationManager = CLLocationManager()
    var customAnnotations = [CustomAnnotation]()
    var businessPickerDelegate: NewBusinessPickedProtocol?
    let regionRadius: Double = 1600
    let authorizationStatus = CLLocationManager.authorizationStatus()
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        configureLocationServices()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("coder not set up")
    }

    func configureLocationServices() {
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            return
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)

        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.4)
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.delegate = self
        let margins = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            mapView.heightAnchor.constraint(equalTo: mapView.superview!.heightAnchor),
            mapView.widthAnchor.constraint(equalTo: margins.widthAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalTo: activityIndicator.superview!.widthAnchor),
            activityIndicator.heightAnchor.constraint(equalTo: activityIndicator.superview!.heightAnchor),
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
            makeBusinessServiceCall()
        }
    }

    @objc func back() {
        dismiss(animated: true, completion: nil)
    }

    func makeBusinessServiceCall() {
        activityIndicator.startAnimating()
        let group = DispatchGroup()
        // https://stackoverflow.com/questions/58319322/using-dispatch-group-in-multi-for-loop-with-urlsession-tasks
        for business in CheckoutCart.shared.businessArray {
            if business.coordinateString != "" {
                let latandLonArray = business.coordinateString?.split(separator: ",")
                let lattitude = latandLonArray![0].split(separator: ":")[1].trimmingCharacters(in: .whitespacesAndNewlines)
                let longitude = latandLonArray![1].split(separator: ":")[1].trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ")", with: "")
                let locationCoordinate = CLLocationCoordinate2D(latitude: Double(lattitude)!, longitude: Double(longitude)!)
                business.coordinate = locationCoordinate
            } else {
                group.enter()
                business.getLocation(from: business.address!) { location in
                    if location != nil {
                        business.coordinate = location!
                        business.coordinateString = String(describing: location!)
                    }
                    CoreDataManager.sharedManager.saveContext()
                    group.leave()
                }
            }
            // Add a custom pin to the map
        }
        group.notify(queue: .main, execute: {
            for business in CheckoutCart.shared.businessArray {
                let customCoordinate = business.coordinate
                let customAnnotation = CustomAnnotation(coordinate: customCoordinate!, businessName: business.name!, businessId: business.id!)
                self.mapView.addAnnotation(customAnnotation)
            }
            self.activityIndicator.stopAnimating()

            // executed after all async calls in for loop finish
            print("done with all async calls weeee")
        })
    }

    override func didReceiveMemoryWarning() {
        // Dispose of any resources that can be recreated.
        super.didReceiveMemoryWarning()
        mapView.removeAnnotations(mapView.annotations)
        mapView.delegate = nil
        mapView.removeFromSuperview()
    }

    // MARK: CLLocationManagerDelegate

    func locationManager(_: CLLocationManager, didUpdateLocations _: [CLLocation]) {}

    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func locationManager(_: CLLocationManager, didChangeAuthorization _: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        print("location manager error", error)
    }

    // MARK: MKMapViewDelegate

    func mapView(_: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomAnnotation) {
            return nil
        }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        let customAnnotation = annotation as! CustomAnnotation

        let detailView = UIView()
        detailView.translatesAutoresizingMaskIntoConstraints = false

        let widthConstraint = NSLayoutConstraint(item: detailView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0.25 * UIViewController.screenSize.width)
        detailView.addConstraint(widthConstraint)
        let heightConstraint = NSLayoutConstraint(item: detailView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0.15 * UIViewController.screenSize.width)
        detailView.addConstraint(heightConstraint)

        // add button
        let button = RoundButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundImageColor = .blue
        button.setTitle("Select", for: .normal)
        button.titleLabel?.font = UIFont(name: "Charter-Black", size: 18.0)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.params["businessId"] = customAnnotation.businessId?.uuidString
        var labelColor: UIColor {
            if #available(iOS 13.0, *) {
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    return .white
                } else {
                    return .black
                }
            } else { return .white }
        }
        let titleLabel = UILabel(theme: Theme.UILabel(props: [.text(customAnnotation.businessName!), .center, .font(UIFont(name: "Charter-Roman", size: 18.0))]))
        titleLabel.textColor = labelColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailView.addSubview(titleLabel)
        detailView.addSubview(button)

        let buttonWidth = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIViewController.screenSize.width * 0.2)
        let buttonHeight = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIViewController.screenSize.width * 0.085)
        button.addConstraint(buttonWidth)
        button.addConstraint(buttonHeight)
        button.centerXAnchor.constraint(equalTo: detailView.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: detailView.bottomAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: detailView.topAnchor, constant: -5.0).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: detailView.centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -10.0).isActive = true

        annotationView?.detailCalloutAccessoryView = detailView
        return annotationView
    }

    @objc func buttonAction(sender: RoundButton!) {
        // https://stackoverflow.com/questions/24814646/attach-parameter-to-button-addtarget-action-in-swift
        if let clickedBusiness = CheckoutCart.shared.business!.first(where: { ($0 as! Business).id?.uuidString == sender.params["businessId"] }) as? Business {
            CheckoutCart.shared.userBusiness = clickedBusiness
            CheckoutCart.shared.userBusiness!.drinks = clickedBusiness.drinks!
            CoreDataManager.sharedManager.saveContext()
            businessPickerDelegate?.businessPicked()
        }
        dismiss(animated: true) {}
    }
}
