//
//  APIClient.swift
//  Pizzeria
//
//  Created by Dor Mizrachi on 04/05/2025.
//

import SwiftUI

class APIClient: ObservableObject {
    var pizzeria: Pizzeria?
    var menu: [Category]?
    
    @Published var isLoading: Bool = false
    
    @Published var cart: [MenuItem] = []
    
    @Published var didAddToCart: Bool = false
    
    let port = 8080
    
    var baseURLString: String = ""
    
    init () {
        self.baseURLString = "http://localhost:\(port)/"
    }
    
    func addToCart(_ item: MenuItem) async {
        withAnimation(.linear(duration: 0.3)) {
            didAddToCart = true
            cart.append(item)
            
        }
        
        print("\(item.name) added to cart...")
        try? await Task.sleep(for: .seconds(2))
        
        withAnimation(.linear(duration: 0.3)) {
            didAddToCart = false
        }
    }
    
    func removeFromCart(at indexset: IndexSet) {
        for index in indexset {
            cart.remove(at: index)
        }
    }
    
    func refresh() async {
        isLoading = true
        await getPizerriaInfo()
        await getMenu()
        // sleep for 2 seconds
        try? await Task.sleep(for: .seconds(1.2))
        print("Refreshing by client...")
        isLoading = false
    }
    
    func getPizerriaInfo() async  {
        
        guard let url = URL(string: "\(baseURLString)pizza") else {
            print("Error: cannot create URL")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }

            // Optional: print raw JSON for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON:\n\(jsonString)")
            }

            let pizzeriaModel = try JSONDecoder().decode(Pizzeria.self, from: data)
            print("🍕 Data fetched: \(pizzeriaModel)")
            
            pizzeria = pizzeriaModel
            
        } catch {
            print("Error fetching Info: \(error)")
        }
        
    }
    
    func getMenu() async {
        
        guard let url = URL(string: "\(baseURLString)menu") else {
            print("Error: cannot create URL")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON:\n\(jsonString)")
            }
            
            let menuRespomseModel = try JSONDecoder().decode(MenuResponse.self, from: data)
            let menuModel = menuRespomseModel.categories
            
            print("📝 MENU fetched: \(menuModel)")
            
            menu = menuModel
            
        } catch {
            print("Error fetching MENU: \(error)")
        }
        
    }
    
    func checkout(cart: [MenuItem]) async {
        guard let url = URL(string: "\(baseURLString)order") else {
            print("Error: cannot create URL")
            return
        }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try JSONEncoder().encode(cart)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // ✅ Perform the network request
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response code: \(httpResponse.statusCode)")
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response body:\n\(responseString)")
            }
            
        } catch {
            print("Error placing order: \(error)")
        }
    }
}
