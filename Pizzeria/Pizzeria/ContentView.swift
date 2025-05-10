//
//  NewMainScreen.swift
//  Pizzeria
//
//  Created by Dor Mizrachi on 07/05/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ClientViewModel()
    
    @State var showCart: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                mainBody
            }
            
            if viewModel.isLoading {
                CustomProgressView()
            }
            
            Banner(
                title: "Item added to cart!",
                isOn: $viewModel.didAddToCart
            )
        }
        .task {
            viewModel.refresh()
        }
    }
    
    var mainBody: some View {
        VStack {
            if !viewModel.error {
                VStack(spacing: 0) {
                    CategoryList(
                        categories: viewModel.menu?.categories ?? [],
                        selectedCategory: $viewModel.selectedCategory
                    ) { category in
                        viewModel.selectedCategory = category.name
                    }
                    
                    if viewModel.selectedCategory == "All" {
                        List {
                            ForEach(viewModel.menu?.categories.filter({ $0.name != "All" }) ?? [], id: \.name) { category in
                                
                                ItemRow(category: category, cart: $viewModel.cart) { item in
                                    Task {
                                        await viewModel.addToCart(item)
                                    }
                                }
                            }
                        }
                        .refreshable {
                            viewModel.refresh()
                        }
                        .listStyle(.plain)
                    } else {
                        let items = viewModel.menu!.categories.first(where: { $0.name == viewModel.selectedCategory})?.items
                        
                        ItemsList(items: items ?? [], cart: $viewModel.cart) { item in
                            Task {
                                await viewModel.addToCart(item)
                            }
                        }
                    }
                }
                .sheet(isPresented: $showCart) {
                    CartView(
                        didRemoved: $viewModel.didRemoved,
                        cart: $viewModel.cart
                    ) { indexSet in
                        Task {
                            await viewModel.removeFromCart(at: indexSet)
                        }
                    } checkout: { closeSheet in
                        viewModel.checkOutOrder(cart: viewModel.cart)
                        showCart = closeSheet
                        viewModel.cart.removeAll()
                    }
                

                }
                .navigationTitle(viewModel.name ?? "Pizzeria")
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
                
            } else {
                ContentUnavailableView {
                    Button {
                        viewModel.refresh()
                    } label: {
                        Label("No Connection! ", systemImage: "network.slash")
                    }
                }
            }
            
            Spacer()
        }
    }
}


struct ItemsList: View {
    
    var items: [MenuItem]
    @Binding var cart: [MenuItem]
    
    var action: (MenuItem) -> Void
    
    var body: some View {
        List {
            ForEach(items,
                    id: \.name
            ) { item in
                MenuItemRow(item: item, itemCount: cart.count(where: { $0.id == item.id }))
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            action(item)
                        } label: {
                            Image(systemName: "cart.badge.plus.fill")
                                .font(.largeTitle)
                        }
                        .tint(.green)
                    }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    @Previewable @State var showCart: Bool = false
    ContentView(showCart: showCart)
}

struct CategoryList: View {
    let categories: [Category]
    @Binding var selectedCategory: String
    var onSelectCategory: (Category) -> Void
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                let sortedCategories = categories.sorted { $0.name < $1.name }
                
                ForEach(sortedCategories, id: \.name) { item in
                    Text("\(item.name)") // replace with row structure
                        .foregroundStyle(.white)
                        .bold()
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(selectedCategory == item.name ? Color.green : Color.blue)
                        .clipShape(Capsule(style: .circular))
                        .shadow(radius: selectedCategory == item.name ? 5 : 0)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                onSelectCategory(item)
                            }
                            print("selected: \(item.name)")
                        }
                }
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
    }
}
