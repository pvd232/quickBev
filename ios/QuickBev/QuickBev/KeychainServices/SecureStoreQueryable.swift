//
//  SecureStoreQueryable.swift
//  QuickBev
//
//  Created by Peter Vail Driscoll II on 2/13/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import Foundation

public protocol SecureStoreQueryable {
    var query: [String: Any] { get }
}

public struct GenericPasswordQueryable {
    let service: String = "com.theQuickCompany.QuickBev"
    let accessGroup: String?

    init(accessGroup: String? = nil) {
//    self.service = service
        self.accessGroup = accessGroup
    }
}

extension GenericPasswordQueryable: SecureStoreQueryable {
    public var query: [String: Any] {
        var query: [String: Any] = [:]
        query[String(kSecClass)] = kSecClassGenericPassword
        query[String(kSecAttrService)] = service
        // Access group if target environment is not simulator
        #if !targetEnvironment(simulator)
            if let accessGroup = accessGroup {
                query[String(kSecAttrAccessGroup)] = accessGroup
            }
        #endif
        return query
    }
}

public struct InternetPasswordQueryable {
    let server: String
    let port: Int
    let path: String
    let securityDomain: String
    let internetProtocol: InternetProtocol
    let internetAuthenticationType: InternetAuthenticationType
}

extension InternetPasswordQueryable: SecureStoreQueryable {
    public var query: [String: Any] {
        var query: [String: Any] = [:]
        query[String(kSecClass)] = kSecClassInternetPassword
        query[String(kSecAttrPort)] = port
        query[String(kSecAttrServer)] = server
        query[String(kSecAttrSecurityDomain)] = securityDomain
        query[String(kSecAttrPath)] = path
        query[String(kSecAttrProtocol)] = internetProtocol.rawValue
        query[String(kSecAttrAuthenticationType)] = internetAuthenticationType.rawValue
        return query
    }
}
