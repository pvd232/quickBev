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
    let price: NSNumber?
    let image: UIImage?
    init(data: [String: Any]) {
        self.id = data["id"] as! String
        self.name = data["name"] as! String
        self.price = data["price"] as? NSNumber
        self.description = data["description"] as! String
        self.image = data["image"] as? UIImage
    }
}
