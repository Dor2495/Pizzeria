import SwiftUI

struct ContentView: View {
    
    @StateObject var client = APIClient()
    @State var searchText: String = ""
    
    @State var showCart: Bool = false
    @State var selectedCategory: Category?
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    List {
                        ForEach(client.menu ?? [], id: \.name) { category in
                            ItemRow(category: category, cart: $client.cart) { item in
                                Task {
                                    await client.addToCart(item)
                                }
                            } 
                        }
                    }
                    .refreshable {
                        await client.refresh()
                    }
                    .listStyle(.insetGrouped)
                }
                .sheet(isPresented: $showCart) {
                    CartView(cart: $client.cart) { indexSet in
                        withAnimation(.bouncy) {
                            client.removeFromCart(at: indexSet)
                        }
                    } checkout: { returnToHomeScreen in
                        Task {
                            await client.checkout(cart: client.cart)
                            
                            // dismiss the cart view
                            client.cart.removeAll()
                            showCart = returnToHomeScreen
                        }
                    }
                }
                .navigationTitle(client.pizzeria?.name ?? "Pizzeria")
                .toolbar {
                    ToolbarItem {
                        Button {
                            showCart = true
                        } label: {
                            Image(systemName: "cart")
                                .bold()
                        }
                    }
                }
                
                // ✅ Show loading overlay based on client.isLoading
                if client.isLoading {
                    CustomProgressView()
                }
                
                Banner(
                    title: "Item added to cart!",
                    isOn: $client.didAddToCart
                )
            }
        }
        .task {
            await client.refresh()
            selectedCategory = client.menu!.first
        }
    }
}

#Preview {
    ContentView()
}


