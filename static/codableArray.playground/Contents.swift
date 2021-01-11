import UIKit

let jsonString = """
{"Response": {
  "Bar": true,
  "Baz": "Hello, World!",
  "Friends": [
    {"FirstName": "Gabe",
    "FavoriteColor": "Orange"},
    {"FirstName": "Jeremiah",
    "FavoriteColor": "Green"},
    {"FirstName": "Peter",
    "FavoriteColor": "Red"}]}}
"""
struct Friend: Codable {
  let firstName: String
  let favoriteColor: String
  enum CodingKeys: String, CodingKey {
    case firstName = "FirstName"
    case favoriteColor = "FavoriteColor"
  }
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.firstName = try container.decode(String.self, forKey: .firstName)
    self.favoriteColor = try container.decode(String.self, forKey: .favoriteColor)
  }
    func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.firstName, forKey: .firstName)
    try container.encode(self.favoriteColor, forKey: .favoriteColor)
  }
}
struct Response: Codable {
  let bar: Bool
  let baz: String
  let friends: [Friend]
  enum CodingKeys: String, CodingKey {
    case response = "Response"
    case bar = "Bar"
    case baz = "Baz"
    case friends = "Friends"
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let response = try container.nestedContainer(keyedBy:
    CodingKeys.self, forKey: .response)
    self.bar = try response.decode(Bool.self, forKey: .bar)
    self.baz = try response.decode(String.self, forKey: .baz)
    self.friends = try response.decode([Friend].self, forKey: .friends)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    var response = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
    try response.encode(self.bar, forKey: .bar)
    try response.encode(self.baz, forKey: .baz)
    try response.encode(self.friends, forKey: .friends)
   }
}
let data = jsonString.data(using: .utf8)!
// Initializes a Response object from the JSON data at the top.
let myResponse = try! JSONDecoder().decode(Response.self, from: data)
// Turns your Response object into raw JSON data you can send back!
let dataToSend = try! JSONEncoder().encode(myResponse)
