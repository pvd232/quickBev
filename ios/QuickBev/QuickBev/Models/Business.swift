//
//  Business.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 1/28/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import CoreData
import CoreLocation
import Foundation
public class Business: NSManagedObject, Codable {
    var coordinate: CLLocationCoordinate2D?
    enum CodingKeys: String, CodingKey {
        case businessResponse = "business"
        case id
        case name
        case address
        case salesTaxRate = "sales_tax_rate"
        case merchantStripeId = "merchant_stripe_id"
    }

    public required convenience init(from decoder: Decoder) throws {
        self.init(context: CoreDataManager.sharedManager.managedContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let businessResponse = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .businessResponse)
        id = try businessResponse.decode(UUID.self, forKey: .id)
        name = try businessResponse.decode(String.self, forKey: .name)
        address = try businessResponse.decode(String.self, forKey: .address)
        salesTaxRate = try businessResponse.decode(Double.self, forKey: .salesTaxRate)
        merchantStripeId = try businessResponse.decode(String.self, forKey: .merchantStripeId)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var businessResponse = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .businessResponse)
        try businessResponse.encode(name, forKey: .name)
        try businessResponse.encode(id, forKey: .id)
        try businessResponse.encode(address, forKey: .address)
        try businessResponse.encode(salesTaxRate, forKey: .salesTaxRate)
        try businessResponse.encode(merchantStripeId, forKey: .merchantStripeId)
    }

    func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, _ in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location?.coordinate
            else {
                return completion(nil)
            }
            completion(location)
        }
    }

    static func getBusinesses(APIClient: APIClient, completion: @escaping ([Business]?) -> Void) {
        let jsonData = try! JSONEncoder().encode(CheckoutCart.businessETag)
        let headerString = String(data: jsonData, encoding: .utf8)!
        let ifNoneMatchHeader: [HTTPHeader] = [HTTPHeader(field: "If-None-Match", value: headerString)]
        let request = try! APIRequest(method: .get, path: "/business/" + CheckoutCart.shared.sessionToken, headers: ifNoneMatchHeader)
        APIClient.perform(request) { result in
            switch result {
            case let .success(response):
                if response.statusCode == 200, let response = try? response.decode(to: [String: [Business]].self) {
                    if let etagId = response.headers["E-tag-id"] as? String, let etagCategory = response.headers["E-tag-category"] as? String {
                        let intEtagId = Int(etagId)!
                        let int64EtagId = Int64(intEtagId)
                        CheckoutCart.businessETag?.setValue(int64EtagId, forKey: "id")
                        CheckoutCart.businessETag?.setValue(etagCategory, forKey: "category")
                        CoreDataManager.sharedManager.saveContext()
                    }
                    let businesses = response.body["businesses"]
                    completion(businesses)
                } else {
                    print("get business status code bad")
                }
            case let .failure(error):
                completion(nil)
                print(error)
            }
        }
    }
}
