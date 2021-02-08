//
//  Drink.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 12/25/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import os
import CoreData
import Alamofire

public class Drink: NSManagedObject, Codable, NSCopying {
    enum CodingKeys: String, CodingKey {
        case drinkResponse = "drink"
        case id = "id"
        case name = "name"
        // couldn't use the word description as a property because it is system reserved
        case detail = "description"
        case price = "price"
        case businessId = "business_id"
//        case businessAddressId = "business_address_id"
        case quantity = "quantity"
        case cost = "cost"
    }
    required convenience public init(from decoder: Decoder) throws {
//        let context = CoreDataManager.sharedManager.managedContext
        
        self.init(context: CoreDataManager.sharedManager.managedContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .drinkResponse)
        self.id = try nestedContainer.decode(UUID.self, forKey: .id)
        self.name = try nestedContainer.decode(String.self, forKey: .name)
        self.detail = try nestedContainer.decode(String.self, forKey: .detail)
        self.price = try nestedContainer.decode(Double.self, forKey: .price)
//        self.businessAddressId = try nestedContainer.decode(UUID.self, forKey: .businessAddressId)
        self.businessId = try nestedContainer.decode(UUID.self, forKey: .businessId)
        self.quantity = try nestedContainer.decode(Int16.self, forKey: .quantity)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var nestedContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .drinkResponse)
        try nestedContainer.encode(self.id, forKey: .id)
        try nestedContainer.encode(self.name, forKey: .name)
        try nestedContainer.encode(self.detail, forKey: .detail)
        try nestedContainer.encode(self.price, forKey: .price)
//        try nestedContainer.encode(self.businessAddressId, forKey: .businessAddressId)
        try nestedContainer.encode(self.businessId, forKey: .businessId)
        try nestedContainer.encode(self.quantity, forKey: .quantity)
    }
    static func getDrinks(completion: @escaping ([Drink]?) -> Void) {
        AF.request("http://127.0.0.1:5000/inventory", method: .get)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    os_log("Successful API Inventory Call")
                    guard let rawData = response.value
                    else {
                        os_log("failure to capture data")
                        return completion(nil)
                    }
                    let json = try! JSONSerialization.jsonObject(with: rawData!, options: []) as! NSDictionary
                    let rawInventory = try! JSONSerialization.data(withJSONObject: json.value(forKey: "drinks")!, options: [])
                    let jsonDecoder = JSONDecoder()
                    let drinks = try! jsonDecoder.decode([Drink].self, from: rawInventory)
                    completion(drinks)
                case .failure(let error):
                    completion(nil)
                    print(error)
                }
            }
    }
    public func copy(with zone: NSZone? = nil) -> Any {
//        let copy = Drink(Id: self.id!, Name: self.name!, Detail: self.detail!, Price: self.price, businessAddressId: self.businessAddressId!)
        let copy = Drink(Id: self.id!, Name: self.name!, Detail: self.detail!, Price: self.price, businessId: self.businessId!)
        return copy
    }
    
}
extension Drink {
    public var cost:Double {
        return Double(quantity) * price
    }
    convenience init(Id:UUID, Name:String, Detail:String, Price:Double, businessId:UUID) {
//        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        self.init(context: CoreDataManager.sharedManager.managedContext)
        self.id = Id
        self.name = Name
        self.detail = Detail
        self.price = Price
        self.businessId = businessId
    }
}
