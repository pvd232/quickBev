//
//  User.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 6/1/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit

struct User {
    let email: String
    let first_name: String
    let last_name: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case userResponse = "user"
        case email = "email"
        case password = "password"
        case first_name = "first_name"
        case last_name = "last_name"
    
        

    }
}

extension User: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let userResponse = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .userResponse)
              print("userResponse", userResponse)
        self.email = try userResponse.decode(String.self, forKey: .email)
        self.first_name = try userResponse.decode(String.self, forKey: .first_name)
        self.last_name = try userResponse.decode(String.self, forKey: .last_name)
        self.password = try userResponse.decode(String.self, forKey: .password)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var userResponse = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .userResponse)
        try userResponse.encode(self.email, forKey: .email)
        try userResponse.encode(self.first_name, forKey: .first_name)
        try userResponse.encode(self.last_name, forKey: .last_name)
        try userResponse.encode(self.password, forKey: .password)
    }
}
