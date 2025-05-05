//
//  Pizzeria.swift
//  Pizzeria
//
//  Created by Dor Mizrachi on 04/05/2025.
//

import SwiftUI

struct Pizzeria: Codable {
    var name: String
    var address: String
    var phone: String
    var email: String
    var website: String
    
    var openingHours: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case address
        case phone
        case email
        case website
        case openingHours = "opening_hours"
    }
}
