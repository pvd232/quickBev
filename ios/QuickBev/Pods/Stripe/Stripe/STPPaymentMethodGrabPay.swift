//
//  STPPaymentMethodGrabPay.swift
//  StripeiOS
//
//  Copyright © 2020 Stripe, Inc. All rights reserved.
//

import Foundation

/// A GrabPay PaymentMethod
/// - seealso: https://stripe.com/docs/api/payment_methods/object#payment_method_object-grabpay
public class STPPaymentMethodGrabPay: NSObject, STPAPIResponseDecodable {
    public private(set) var allResponseFields: [AnyHashable: Any] = [:]

    // MARK: - Description

    /// :nodoc:
    @objc override public var description: String {
        let props = [
            // Object
            String(format: "%@: %p", NSStringFromClass(STPPaymentMethodGrabPay.self), self),
        ]

        return "<\(props.joined(separator: "; "))>"
    }

    // MARK: - STPAPIResponseDecodable

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
