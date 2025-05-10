//
//  CartView.swift
//  Pizzeria
//
//  Created by Dor Mizrachi on 04/05/2025.
//

import SwiftUI

struct CartView: View {
    
    @State var isOrderCompleted: Bool = false
    
    @Binding var didRemoved: Bool
    @Binding var cart: [MenuItem]
    
    var deleteAction: (IndexSet) -> Void
    var checkout: (Bool) -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                if cart.isEmpty {
                    ContentUnavailableView("Cart is empty !", image: "cart")
                        .navigationTitle("My Cart")
                        .transition(.opacity)
                } else {
                    List {
                        ForEach(Array(cart.enumerated()), id: \.element.id) { index, item in
                            HStack(alignment: .center) {
                                Text(item.name)
                                Spacer()
                                Text("\(String(format: "%.2f", item.price))")
                                    .font(.subheadline)
                            }
                        }
                        .onDelete { indexSet in
                            withAnimation {
                                deleteAction(indexSet)
                            }
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
                    .transition(.opacity)
                }
                
                Banner(title: "Order Completed!", isOn: $isOrderCompleted)
                
                Banner(title: "Item removed from cart", isOn: $didRemoved)
            }
        }
    }
}


//#Preview {
//    struct PreviewWrapper: View {
//        @State private var cart: [MenuItem] = [
//            
//        ]
//        @State private var didRemoved: Bool = false
//        
//        var body: some View {
//            CartView(
//                didRemoved: $didRemoved,
//                cart: $cart,
//                deleteAction: { indexSet in
//                    cart.remove(atOffsets: indexSet)
//                },
//                checkout: { _ in }
//            )
//        }
//    }
//    
//    return PreviewWrapper()
//}
