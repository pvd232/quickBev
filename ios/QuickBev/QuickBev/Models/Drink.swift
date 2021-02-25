//
//  Drink.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 12/25/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import os
import CoreData

public class Drink: NSManagedObject, Codable, NSCopying {
    enum CodingKeys: String, CodingKey {
        case drinkResponse = "drink"
        case id = "id"
        case name = "name"
        case detail = "description"
        case price = "price"
        case businessId = "business_id"
        case quantity = "quantity"
        case cost = "cost"
    }
    required convenience public init(from decoder: Decoder) throws {
        self.init(context: CoreDataManager.sharedManager.managedContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .drinkResponse)
        self.id = try nestedContainer.decode(UUID.self, forKey: .id)
        self.name = try nestedContainer.decode(String.self, forKey: .name)
        self.detail = try nestedContainer.decode(String.self, forKey: .detail)
        self.price = try nestedContainer.decode(Double.self, forKey: .price)
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
        try nestedContainer.encode(self.businessId, forKey: .businessId)
        try nestedContainer.encode(self.quantity, forKey: .quantity)
    }
    static func getDrinks(APIClient: APIClient, completion: @escaping ([Drink]?) -> Void) {
        let jsonData = try! JSONEncoder().encode(CheckoutCart.drinkETag)
        let headerString = String(data: jsonData, encoding: .utf8)!
        let ifNoneMatchHeader: [HTTPHeader] = [HTTPHeader(field: "If-None-Match", value: headerString)]
        let request = try! APIRequest( method: .get, path:"/drink", headers: ifNoneMatchHeader)
        APIClient.perform(request)
        { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200, let response = try? response.decode(to: [String: [Drink]].self)  {
                    if CheckoutCart.drinkETag != nil {
                        CoreDataManager.sharedManager.deleteEntity(entity: CheckoutCart.drinkETag!)
                        CoreDataManager.sharedManager.saveContext()

                    }
                    if let etagId = response.headers["E-tag-id"] as? String, let etagCategory = response.headers["E-tag-category"] as? String {
                        let intEtagID = Int(etagId)!
                        if let etagId = intEtagID as? Int, let etagCategory = etagCategory as? String {
                            CheckoutCart.drinkETag = ETag(Id:Int64(etagId) , Category: etagCategory)
                        }
                    }
                    
                        CoreDataManager.sharedManager.saveContext()
                    let drinks =  response.body["drinks"]
                    completion(drinks)
                }
                else {
                    print("na")
                }
            case .failure(let error):
                completion(nil)
                print(error)
            }
        }
    }
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = Drink(Id: self.id!, Name: self.name!, Detail: self.detail!, Price: self.price, businessId: self.businessId!)
        return copy
    }
    
}
extension Drink {
    public var cost:Double {
        return Double(quantity) * price
    }
    convenience init(Id:UUID, Name:String, Detail:String, Price:Double, businessId:UUID) {
        self.init(context: CoreDataManager.sharedManager.managedContext)
        self.id = Id
        self.name = Name
        self.detail = Detail
        self.price = Price
        self.businessId = businessId
    }
}
