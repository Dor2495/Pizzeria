//
//  CartView.swift
//  Pizzeria
//
//  Created by Dor Mizrachi on 04/05/2025.
//

import SwiftUI

struct CartView: View {
    
    @State var isOrderCompleted: Bool = false
    
    @Binding var cart: [MenuItem]
    
    var deleteAction: (IndexSet) -> Void
    var checkout: (Bool) -> Void
    
    var body: some View {
        NavigationStack {
            
            if cart.isEmpty {
                ContentUnavailableView("Cart is empty !", image: "cart")
                    .navigationTitle("My Cart")
            } else {
                ZStack {
                    List {
                        let groupedCart = Dictionary(grouping: cart, by: { $0.id })
                        
                        ForEach(groupedCart.keys.sorted(), id: \.self) { id in
                            if let items = groupedCart[id], let item = items.first {
                                HStack(alignment: .center) {
                                    Text(item.name)
                                    Spacer()
                                    Text("\(String(format: "%.2f", item.price))")
                                        .font(.subheadline)
                                    Text("x \(items.count)")
                                }
                            }
                        }
                        .onDelete { indexSet in
                            deleteAction(indexSet)
                        }
                        Section("Total") {
                            HStack {
                                Spacer()
                                Text("\(String(format: "%.2f", cart.reduce(0) { $0 + $1.price })) NIS")
                            }
                        }
                    }
                    .navigationTitle("My Cart")
                    .toolbar {
                        ToolbarItem {
                            Button("CheckOut") {
                                Task {
                                    withAnimation(.linear(duration: 0.3)) {
                                        isOrderCompleted = true
                                    }
                                    try? await Task.sleep(for: .seconds(2))
                                    
                                    withAnimation(.linear(duration: 0.3)) {
                                        isOrderCompleted = false
                                    }
                                    
                                    checkout(false)
                                }
                            }
                            .disabled(isOrderCompleted)
                        }
                    }
                    
                    Banner(
                        title: "Order Completed!",
                        isOn: $isOrderCompleted
                    )
                }
            }
        }
    }
}


#Preview {
//    CartView()
}
