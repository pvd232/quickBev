//
//  Business.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 1/28/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import CoreLocation
import CoreData
import Foundation
public class Business: NSManagedObject, Codable {
    var coordinate: CLLocationCoordinate2D?
    enum CodingKeys: String, CodingKey {
        case businessResponse = "business"
        case id = "id"
        case name = "name"
        case address = "address"
        case salesTaxRate = "sales_tax_rate"
        case merchantStripeId = "merchant_stripe_id"
    }
    required convenience public init(from decoder: Decoder) throws {
        self.init(context: CoreDataManager.sharedManager.managedContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let businessResponse = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .businessResponse)
        self.id = try businessResponse.decode(UUID.self, forKey: .id)
        self.name = try businessResponse.decode(String.self, forKey: .name)
        self.address = try businessResponse.decode(String.self, forKey: .address)
        self.salesTaxRate = try businessResponse.decode(Double.self, forKey: .salesTaxRate)
        self.merchantStripeId = try businessResponse.decode(String.self, forKey: .merchantStripeId)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var businessResponse = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .businessResponse)
        try businessResponse.encode(self.name, forKey: .name)
        try businessResponse.encode(self.id, forKey: .id)
        try businessResponse.encode(self.address, forKey: .address)
        try businessResponse.encode(self.salesTaxRate, forKey: .salesTaxRate)
        try businessResponse.encode(self.merchantStripeId, forKey: .merchantStripeId)
    }
    func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?)-> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location?.coordinate else {
                return completion(nil)
            }
            completion(location)
        }
    }
    static func getBusinesses(APIClient: APIClient, completion: @escaping ([Business]?) -> Void) {
        let jsonData = try! JSONEncoder().encode(CheckoutCart.businessETag)
        let headerString = String(data: jsonData, encoding: .utf8)!
        let ifNoneMatchHeader: [HTTPHeader] = [HTTPHeader(field: "If-None-Match", value: headerString)]
        let request = try! APIRequest( method: .get, path:"/business", headers: ifNoneMatchHeader)
        APIClient.perform(request)
           { result in
                switch result {
                case .success(let response):
                    if response.statusCode == 200, let response = try? response.decode(to: [String: [Business]].self) {
                        if CheckoutCart.businessETag != nil {
                            CoreDataManager.sharedManager.deleteEntity(entity: CheckoutCart.businessETag!)
                            CoreDataManager.sharedManager.saveContext()

                        }
                        if let etagId = response.headers["E-tag-id"] as? String, let etagCategory = response.headers["E-tag-category"] as? String {
                            let intEtagID = Int(etagId)!
                            if let etagId = intEtagID as? Int, let etagCategory = etagCategory as? String {
                                CheckoutCart.businessETag = ETag(Id:Int64(etagId) , Category: etagCategory)
                            }
                        }
                        
                            CoreDataManager.sharedManager.saveContext()
                        let businesses =  response.body["businesses"]
                        completion(businesses)
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
}

