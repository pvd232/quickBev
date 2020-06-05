//
//  Bar.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 6/4/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit

struct Bar {

    let id: String
    let name: String
    let street: String
    let city: String
    let state: String
    let zipcode: String
    let country: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case barResponse = "bar"
        case name = "name"
        case street = "street"
        case city = "city"
        case state = "state"
        case zipcode = "zipcode"
        case country = "country"
    }
}

extension Bar: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let barResponse = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .barResponse)
        self.id = try barResponse.decode(String.self, forKey: .id)
        self.name = try barResponse.decode(String.self, forKey: .name)
        self.street = try barResponse.decode(String.self, forKey: .street)
        self.city = try barResponse.decode(String.self, forKey: .city)
        self.state = try barResponse.decode(String.self, forKey: .state)
        self.zipcode = try barResponse.decode(String.self, forKey: .zipcode)
        self.country = try barResponse.decode(String.self, forKey: .country)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var barResponse = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .barResponse)
        try barResponse.encode(self.name, forKey: .name)
        try barResponse.encode(self.id, forKey: .id)
        try barResponse.encode(self.street, forKey: .street)
        try barResponse.encode(self.city, forKey: .city)
        try barResponse.encode(self.state, forKey: .state)
        try barResponse.encode(self.zipcode, forKey: .zipcode)
        try barResponse.encode(self.country, forKey: .country)
    }
}
