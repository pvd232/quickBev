//
//  Business.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 1/28/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import Alamofire
import CoreLocation
import CoreData

public class Business: NSManagedObject, Codable {
    var coordinate: CLLocationCoordinate2D?
    enum CodingKeys: String, CodingKey {
        case businessResponse = "business"
        case id = "id"
        case name = "name"
        case address = "address"
        case salesTaxRate = "sales_tax_rate"
        case stripeId = "stripe_id"
//        case businessAddressId = "business_address_id"
    }
    required convenience public init(from decoder: Decoder) throws {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let businessResponse = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .businessResponse)
        self.id = try businessResponse.decode(UUID.self, forKey: .id)
        self.name = try businessResponse.decode(String.self, forKey: .name)
        self.address = try businessResponse.decode(String.self, forKey: .address)
        self.salesTaxRate = try businessResponse.decode(Double.self, forKey: .salesTaxRate)
        self.stripeId = try businessResponse.decode(String.self, forKey: .stripeId)
//        self.businessAddressId = try businessResponse.decode(UUID.self, forKey: .businessAddressId)

    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var businessResponse = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .businessResponse)
        try businessResponse.encode(self.name, forKey: .name)
        try businessResponse.encode(self.id, forKey: .id)
        try businessResponse.encode(self.address, forKey: .address)
        try businessResponse.encode(self.salesTaxRate, forKey: .salesTaxRate)
//        try businessResponse.encode(self.businessAddressId, forKey: .businessAddressId)
        try businessResponse.encode(self.stripeId, forKey: .stripeId)

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
    static func getBusinesses(completion: @escaping ([Business]?) -> Void) {
        AF.request("http://127.0.0.1:5000/business", method: .get)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    guard let rawData = response.data
                    else {
                        return completion(nil)
                    }
                    let json = try! JSONSerialization.jsonObject(with: rawData, options: []) as! NSDictionary
                    let unpackedBusinesses = json.value(forKey: "businesses")
                    let rawBusinesses = try! JSONSerialization.data(withJSONObject: unpackedBusinesses!, options: [])
                    let jsonDecoder = JSONDecoder()
                    let businesses = try! jsonDecoder.decode([Business].self, from: rawBusinesses)
                    completion(businesses)
                case .failure(let error):
                    completion(nil)
                    print(error)
                }
            }
    }
}

