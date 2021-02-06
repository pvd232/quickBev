//
//  StripeAPIClient.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 12/21/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import Stripe
import PassKit
import Foundation

final class StripeAPIClient: NSObject, STPCustomerEphemeralKeyProvider {
    enum APIError: Error {
        case unknown
        var localizedDescription: String {
            switch self {
            case .unknown:
                return "Unknown error"
            }
        }
    }
    
    static let sharedAPIClient = StripeAPIClient()
    
    private override init() {
        // private
    }
    
    var baseURLString = "http://127.0.0.1:5000/"
    private lazy var baseURL: URL = {
        guard let url = URL(string: baseURLString) else {
            fatalError("Invalid URL")
        }
        return url
    }()
    func createPaymentIntent(order: Order, completion: @escaping ((Result<String, Error>) -> Void)) {
        let url = self.baseURL.appendingPathComponent("create-payment-intent")
        var params: [String: Order] = [:]
        let encoder = JSONEncoder()
        
        params["order"] = order
        let encodedParams = try! encoder.encode(params)
    
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encodedParams
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data,
                  let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]) as [String: Any]??),
                  let secret = json?["secret"] as? String else {
                completion(.failure(error ?? APIError.unknown))
                return
            }
            completion(.success(secret))
        })
        task.resume()
    }
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = self.baseURL.appendingPathComponent("create-ephemeral-keys")
        var customerStripeId: String? = ""
        if CheckoutCart.shared.stripeId != nil  {
            customerStripeId = CheckoutCart.shared.stripeId!
        }
        let params: [String: Any] = [
            "api_version": apiVersion,
            "stripe_id": (String(describing: customerStripeId!))
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: params)

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data,
                  let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??) else {
                completion(nil, error)
                return
            }
            // this will be true during the guest checkout pathway
            if CheckoutCart.shared.isGuest {
                CheckoutCart.shared.stripeId = response.allHeaderFields["stripe_id"] as? String
                CoreDataManager.sharedManager.saveContext()
            }
            completion(json, nil)
        })
        task.resume()
    }
}
