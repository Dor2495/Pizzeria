//
//  Menu.swift
//  Pizzeria
//
//  Created by Dor Mizrachi on 04/05/2025.
//

import Foundation

struct MenuItem: Codable {
    var id: Int
    var name: String
    var description: String
    var price: Double
    var vegetarian: Bool
}

struct Category: Codable {
    var name: String
    var items: [MenuItem]
}

struct MenuResponse: Codable {
    var categories: [Category]
}
