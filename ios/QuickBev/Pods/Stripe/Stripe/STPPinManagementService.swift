//
//  STPAPIClient+PinManagement.h
//  Stripe
//
//  Created by Arnaud Cavailhez on 4/29/19.
//  Copyright © 2019 Stripe, Inc. All rights reserved.
//

import Foundation
import UIKit

/// STPAPIClient extensions to manage PIN on Stripe Issuing cards
public class STPPinManagementService: NSObject {
    /// The API Client to use to make requests.
    /// Defaults to STPAPIClient.shared
    @objc public var apiClient = STPAPIClient.shared

    /// Create a STPPinManagementService, you must provide an implementation of STPIssuingCardEphemeralKeyProvider
    @objc
    public init(keyProvider: STPIssuingCardEphemeralKeyProvider) {
        super.init()
        keyManager = STPEphemeralKeyManager(
            keyProvider: keyProvider as Any, apiVersion: STPAPIClient.apiVersion,
            performsEagerFetching: false
        )
    }

    /// Retrieves a PIN number for a given card,
    /// this call is asynchronous, implement the completion block to receive the updates
    @objc
    public func retrievePin(
        _ cardId: String,
        verificationId: String,
        oneTimeCode: String,
        completion: @escaping STPPinCompletionBlock
    ) {
        let endpoint = "issuing/cards/\(cardId)/pin"
        let parameters = [
            "verification": [
                "id": verificationId,
                "one_time_code": oneTimeCode,
            ],
        ]
        keyManager?.getOrCreateKey { ephemeralKey, keyError in
            if ephemeralKey == nil {
                completion(nil, .ephemeralKeyError, keyError)
                return
            }

            if let ephemeralKey = ephemeralKey {
                APIRequest<STPIssuingCardPin>.getWith(
                    self.apiClient,
                    endpoint: endpoint,
                    additionalHeaders: self.apiClient.authorizationHeader(using: ephemeralKey),
                    parameters: parameters
                ) { details, _, error in
                    // Find if there were errors
                    if details?.error != nil {
                        let code = details?.error?["code"] as? String
                        if code == "api_key_expired" {
                            completion(nil, .ephemeralKeyError, error)
                        } else if code == "expired" {
                            completion(nil, .errorVerificationExpired, nil)
                        } else if code == "incorrect_code" {
                            completion(nil, .errorVerificationCodeIncorrect, nil)
                        } else if code == "too_many_attempts" {
                            completion(nil, .errorVerificationTooManyAttempts, nil)
                        } else if code == "already_redeemed" {
                            completion(nil, .errorVerificationAlreadyRedeemed, nil)
                        } else {
                            completion(nil, .unknownError, error)
                        }
                        return
                    }
                    completion(details, .success, nil)
                }
            }
        }
    }

    /// Updates a PIN number for a given card,
    /// this call is asynchronous, implement the completion block to receive the updates
    @objc
    public func updatePin(
        _ cardId: String,
        newPin: String,
        verificationId: String,
        oneTimeCode: String,
        completion: @escaping STPPinCompletionBlock
    ) {
        let endpoint = "issuing/cards/\(cardId)/pin"
        let parameters =
            [
                "verification": [
                    "id": verificationId,
                    "one_time_code": oneTimeCode,
                ],
                "pin": newPin,
            ] as [String: Any]
        keyManager?.getOrCreateKey { ephemeralKey, keyError in
            if ephemeralKey == nil {
                completion(nil, .ephemeralKeyError, keyError)
                return
            }
            if let ephemeralKey = ephemeralKey {
                APIRequest<STPIssuingCardPin>.post(
                    with: self.apiClient,
                    endpoint: endpoint,
                    additionalHeaders: self.apiClient.authorizationHeader(using: ephemeralKey),
                    parameters: parameters
                ) { details, _, error in
                    // Find if there were errors
                    if details?.error != nil {
                        let code = details?.error?["code"] as? String
                        if code == "api_key_expired" {
                            completion(nil, .ephemeralKeyError, error)
                        } else if code == "expired" {
                            completion(nil, .errorVerificationExpired, nil)
                        } else if code == "incorrect_code" {
                            completion(nil, .errorVerificationCodeIncorrect, nil)
                        } else if code == "too_many_attempts" {
                            completion(nil, .errorVerificationTooManyAttempts, nil)
                        } else if code == "already_redeemed" {
                            completion(nil, .errorVerificationAlreadyRedeemed, nil)
                        } else {
                            completion(nil, .unknownError, error)
                        }
                        return
                    }
                    completion(details, .success, nil)
                }
            }
        }
    }

    private var keyManager: STPEphemeralKeyManager?
}
