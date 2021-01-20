//
//  CustomAnnotation.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 6/4/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let image: UIImage?
    let barId: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, image: UIImage, barId: String) {
        self.coordinate = coordinate
        self.title = title
        self.image = image
        self.barId = barId
        super.init()
    }
    deinit {
    }
    
}
