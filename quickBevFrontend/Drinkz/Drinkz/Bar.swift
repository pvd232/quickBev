//
//  Bar.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 6/4/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
import CoreLocation

//struct BarList: Codable {
//    let barList: [Bar]
//    enum CodingKeys: String, CodingKey {
//        case barResponse = "bars"
//    }
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.barList = try container.decode([Bar].self, forKey: .barResponse)
//    }
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(self.barList, forKey: .barResponse)
//    }
//}

class Bar:Codable {
    
    let id: String
    let name: String
    let street: String
    let city: String
    let state: String
    let zipcode: String
    let country: String
    var address: String
    var coordinate: CLLocationCoordinate2D?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case street = "street"
        case city = "city"
        case state = "state"
        case zipcode = "zipcode"
        case country = "country"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.street = try container.decode(String.self, forKey: .street)
        self.city = try container.decode(String.self, forKey: .city)
        self.state = try container.decode(String.self, forKey: .state)
        self.zipcode = try container.decode(String.self, forKey: .zipcode)
        self.country = try container.decode(String.self, forKey: .country)
        self.address = "\(self.street), \(self.city), \(self.state) \(self.zipcode)"
     
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.street, forKey: .street)
        try container.encode(self.city, forKey: .city)
        try container.encode(self.state, forKey: .state)
        try container.encode(self.zipcode, forKey: .zipcode)
        try container.encode(self.country, forKey: .country)
    }
}


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




