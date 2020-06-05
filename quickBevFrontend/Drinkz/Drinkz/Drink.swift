//
//  Drink.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 3/29/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit

struct Drink {
    let id: String
    let name: String
    let description: String
    // should probably find a better way to do this instead of representing the price as a string
    let price: String
//    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case price = "price"
    }
    
    init(data: [String: String]) {
        self.id = data["id"]!
        self.name = data["name"]!
        self.price = data["price"]!
        self.description = data["description"]!
//        self.image = data["image"] as? String
    }
}
extension Drink: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.price = try container.decode(String.self, forKey: .price)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.price, forKey: .price)
    }
}

//    func serialize() -> String {
//        let drinkDic = ["id": self.id, "name": self.name, "price": self.price, "description": self.description]
//        let jsonDrinkDic = try! JSONSerialization.data(withJSONObject: drinkDic)
//        let jsonString = String(data: jsonDrinkDic, encoding: .utf8)!
//        return jsonString
//    }

