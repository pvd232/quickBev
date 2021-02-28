//
//  NSBundle+Stripe_AppName.swift
//  Stripe
//
//  Created by Jack Flintermann on 4/20/16.
//  Copyright © 2016 Stripe, Inc. All rights reserved.
//

import Foundation

extension Bundle {
    class func stp_applicationName() -> String? {
        return main.infoDictionary?[kCFBundleNameKey as String] as? String
    }

    class func stp_applicationVersion() -> String? {
        return main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
