//
//  ClientViewModel.swift
//  Pizzeria
//
//  Created by Dor Mizrachi on 07/05/2025.
//

import Foundation
import SwiftUI

@MainActor
class ClientViewModel: ObservableObject {
    
    let shared = Client()
    
    @Published var pizzeriaInfo: Pizzeria? = nil
    @Published var menu: MenuResponse? = nil
    @Published var cart: [MenuItem] = []
    
    @Published var openingHours: [String: String]? = nil
    @Published var name: String? = nil
    @Published var address: String? = nil
    @Published var email: String? = nil
    @Published var website: String? = nil
    @Published var phone: String? = nil
    
    @Published var selectedCategory: String = "All"
    
    
    @Published private(set) var isLoading = false
    @Published private(set) var error = false
    @Published var didAddToCart: Bool = false
    @Published var didRemoved: Bool = false

    init() {
        refresh()
    }
    
    func refresh() {
        fetchPizzeriaInfo()
        fetchMenuInfo()
    }
    
    func fetchPizzeriaInfo() {
        isLoading = true
        self.error = false
        
        shared.info() { result in
            if result == nil {
                print("Error fetching data")
                self.isLoading = false
                self.error = true
                return
            }
            
            DispatchQueue.main.async {
                self.pizzeriaInfo = result!
                self.openingHours = result!.openingHours
                self.name = result!.name
                self.address = result!.address
                self.email = result!.email
                self.phone = result!.phone
                self.website = result!.website
                
                print("pizza values assigned")
            }
            
            print("\(self.pizzeriaInfo.debugDescription)")
        }
        
        isLoading = false
    }
    
    func fetchMenuInfo() {
        isLoading = true
        self.error = false
        
        shared.menu() { result in
            guard let result = result else {
                print("Error fetching data")
                self.isLoading = false
                self.error = true
                return
            }
            
            DispatchQueue.main.async {
                self.menu = result
                self.menu!.categories.append(Category(name: "All", items: []))
                
                print("pizza menu assigned")
            }
            
            print("\(self.menu.debugDescription)")
        }
        
        self.error = false
        isLoading = false
    }
    
    func checkOutOrder(cart: [MenuItem]) {
        isLoading = true
        self.error = false
        
        shared.checkout(cart: cart) { success in
            if success {
                print("Order sent successfully:  \(cart.debugDescription)")
                self.isLoading = false
                self.error = false
                
                return
            }
            print("Error sending order !")
            
            self.error = true
            self.isLoading = false
        }
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
    
    func removeFromCart(at indexset: IndexSet) async {
        guard !cart.isEmpty else { return }

        withAnimation(.linear(duration: 0.3)) {
            didRemoved = true
        }
        
        try? await Task.sleep(for: .seconds(0.1))
        
        withAnimation {
            cart.remove(atOffsets: indexset)
        }
        
        try? await Task.sleep(for: .seconds(1.5))
        
        withAnimation(.linear(duration: 0.3)) {
            didRemoved = false
        }
    }
}

struct PreviewView: View {
    @StateObject var clientViewModel = ClientViewModel()
    var body: some View {
        VStack {
            Button {
                clientViewModel.fetchPizzeriaInfo()
                clientViewModel.fetchMenuInfo()
                clientViewModel.checkOutOrder(cart: [])
            } label: {
                Text("press")
            }
        }
    }
}


#Preview {
    PreviewView()
}
