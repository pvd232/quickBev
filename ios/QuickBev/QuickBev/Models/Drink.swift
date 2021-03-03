//
//  Drink.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 12/25/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import CoreData
import os

public class Drink: NSManagedObject, Codable, NSCopying {
    enum CodingKeys: String, CodingKey {
        case drinkResponse = "drink"
        case id
        case name
        case detail = "description"
        case price
        case businessId = "business_id"
        case quantity
        case cost
    }

    public required convenience init(from decoder: Decoder) throws {
        self.init(context: CoreDataManager.sharedManager.managedContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .drinkResponse)
        id = try nestedContainer.decode(UUID.self, forKey: .id)
        name = try nestedContainer.decode(String.self, forKey: .name)
        detail = try nestedContainer.decode(String.self, forKey: .detail)
        price = try nestedContainer.decode(Double.self, forKey: .price)
        businessId = try nestedContainer.decode(UUID.self, forKey: .businessId)
        quantity = try nestedContainer.decode(Int16.self, forKey: .quantity)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var nestedContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .drinkResponse)
        try nestedContainer.encode(id, forKey: .id)
        try nestedContainer.encode(name, forKey: .name)
        try nestedContainer.encode(detail, forKey: .detail)
        try nestedContainer.encode(price, forKey: .price)
        try nestedContainer.encode(businessId, forKey: .businessId)
        try nestedContainer.encode(quantity, forKey: .quantity)
    }

    static func getDrinks(APIClient: APIClient, completion: @escaping ([Drink]?) -> Void) {
        let jsonData = try! JSONEncoder().encode(CheckoutCart.drinkETag)
        let headerString = String(data: jsonData, encoding: .utf8)!
        let ifNoneMatchHeader: [HTTPHeader] = [HTTPHeader(field: "If-None-Match", value: headerString)]
        let request = try! APIRequest(method: .get, path: "/drink/" + CheckoutCart.shared.sessionToken, headers: ifNoneMatchHeader)
        APIClient.perform(request) { result in
            switch result {
            case let .success(response):
                if response.statusCode == 200, let response = try? response.decode(to: [String: [Drink]].self) {
                    if let etagId = response.headers["E-tag-id"] as? String, let etagCategory = response.headers["E-tag-category"] as? String {
                        let intEtagId = Int(etagId)!
                        let int64EtagId = Int64(intEtagId)
                        CheckoutCart.drinkETag?.setValue(int64EtagId, forKey: "id")
                        CheckoutCart.drinkETag?.setValue(etagCategory, forKey: "category")
                        CoreDataManager.sharedManager.saveContext()
                    }
                    let drinks = response.body["drinks"]
                    completion(drinks)
                } else {
                    print("na")
                }
            case let .failure(error):
                completion(nil)
                print(error)
            }
        }
    }

    public func copy(with _: NSZone? = nil) -> Any {
        let copy = Drink(Id: id!, Name: name!, Detail: detail!, Price: price, businessId: businessId!)
        return copy
    }
}

extension Drink {
    public var cost: Double {
        return Double(quantity) * price
    }

    convenience init(Id: UUID, Name: String, Detail: String, Price: Double, businessId: UUID) {
        self.init(context: CoreDataManager.sharedManager.managedContext)
        id = Id
        name = Name
        detail = Detail
        price = Price
        self.businessId = businessId
    }
}
