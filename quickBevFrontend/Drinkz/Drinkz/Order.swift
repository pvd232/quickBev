//
//  Order.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 4/16/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit

struct Order{
    let id: String
    let userId: String
    let barId: String
    let price: String
    let orderDrink: [Drink]
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case barId = "bar_id"
        case price = "price"
        case orderDrink = "order_drink"
    }
}
extension Order {
   init(userId: String, barId: String, price: String, orderDrink: [Drink]) {
       self.id = UUID().uuidString
       self.userId = userId
       self.barId = barId
       self.price = price
       self.orderDrink = orderDrink
   }

}

extension Order: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.barId = try container.decode(String.self, forKey: .barId)
        self.price = try container.decode(String.self, forKey: .price)
        self.orderDrink = [Drink]()
        //need to implement this once i have multiple drinks being ordered
//        self.orderDrink = try order.decode([Drink].self, forKey: .orderDrink)
    }

 func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.barId, forKey: .barId)
        try container.encode(self.price, forKey: .price)
        try container.encode(self.orderDrink, forKey: .orderDrink)
    }
}



