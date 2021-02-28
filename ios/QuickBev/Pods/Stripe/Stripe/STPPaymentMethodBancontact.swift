//
//  STPPaymentMethodBancontact.swift
//  StripeiOS
//
//  Created by Vineet Shah on 4/29/20.
//  Copyright © 2020 Stripe, Inc. All rights reserved.
//

import Foundation

/// A Bancontact Payment Method.
/// - seealso: https://stripe.com/docs/payments/bancontact
public class STPPaymentMethodBancontact: NSObject, STPAPIResponseDecodable {
    public private(set) var allResponseFields: [AnyHashable: Any] = [:]

    // MARK: - Description

    /// :nodoc:
    @objc override public var description: String {
        let props = [
            // Object
            String(format: "%@: %p", NSStringFromClass(STPPaymentMethodBancontact.self), self),
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
