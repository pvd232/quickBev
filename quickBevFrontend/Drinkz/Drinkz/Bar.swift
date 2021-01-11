//
//  Bar.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 12/23/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import Alamofire
import CoreLocation
import CoreData

public class Bar: NSManagedObject, Codable {
    var coordinate: CLLocationCoordinate2D?
    enum CodingKeys: String, CodingKey {
        case barResponse = "bar"
        case id = "id"
        case name = "name"
        case address = "address"
        case salesTaxRate = "sales_tax_rate"
    }
    required convenience public init(from decoder: Decoder) throws {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let barResponse = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .barResponse)
        self.id = try barResponse.decode(String.self, forKey: .id)
        self.name = try barResponse.decode(String.self, forKey: .name)
        self.address = try barResponse.decode(String.self, forKey: .address)
        self.salesTaxRate = try barResponse.decode(Double.self, forKey: .salesTaxRate)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var barResponse = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .barResponse)
        try barResponse.encode(self.name, forKey: .name)
        try barResponse.encode(self.id, forKey: .id)
        try barResponse.encode(self.address, forKey: .address)
        try barResponse.encode(self.salesTaxRate, forKey: .salesTaxRate)
    }
    func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?)-> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location?.coordinate else {
                completion(nil)
                completion(nil)
                return
            }
            completion(location)
        }
    }
    static func getBars(completion: @escaping ([Bar]?) -> Void) {
        AF.request("http://127.0.0.1:5000/getBars", method: .get)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    guard let rawData = response.data
                    else {
                        return completion(nil)
                    }
                    let json = try! JSONSerialization.jsonObject(with: rawData, options: []) as! NSDictionary
                    let unpackedBars = json.value(forKey: "bars")
                    let rawBars = try! JSONSerialization.data(withJSONObject: unpackedBars!, options: [])
                    let jsonDecoder = JSONDecoder()
                    let bars = try! jsonDecoder.decode([Bar].self, from: rawBars)
                    completion(bars)
                case .failure(let error):
                    completion(nil)
                    print(error)
                }
            }
    }
}
