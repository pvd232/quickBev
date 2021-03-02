//
//  CustomAnnotation.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 6/4/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import MapKit
import UIKit

class CustomAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let businessName: String?
//    let image: UIImage?
    let businessId: UUID?

    init(coordinate: CLLocationCoordinate2D, businessName: String, businessId: UUID) {
        self.coordinate = coordinate
        self.businessName = businessName
//        self.image = image
        self.businessId = businessId
        super.init()
    }

    deinit {}
}
