//
//  STPPaymentMethodPayPal.swift
//  StripeiOS
//
//  Created by Cameron Sabol on 10/5/20.
//  Copyright © 2020 Stripe, Inc. All rights reserved.
//

import Foundation

/// A PayPal Payment Method. :nodoc:
/// - seealso: https://stripe.com/docs/payments/paypal
public class STPPaymentMethodPayPal: NSObject, STPAPIResponseDecodable {
    @objc public private(set) var allResponseFields: [AnyHashable: Any] = [:]

    // MARK: - Description

    /// :nodoc:
    @objc override public var description: String {
        let props = [
            // Object
            String(format: "%@: %p", NSStringFromClass(STPPaymentMethodPayPal.self), self),
        ]

        return "<\(props.joined(separator: "; "))>"
    }

    // MARK: - STPAPIResponseDecodable

    @objc
    public class func decodedObject(fromAPIResponse response: [AnyHashable: Any]?) -> Self? {
        guard let response = response else {
            return nil
        }
        return self.init(dictionary: response)
    }

    required init(dictionary dict: [AnyHashable: Any]) {
        super.init()
        allResponseFields = dict
    }
}
