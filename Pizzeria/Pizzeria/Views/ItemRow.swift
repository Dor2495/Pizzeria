//
//  ItemRow.swift
//  Pizzeria
//
//  Created by Dor Mizrachi on 04/05/2025.
//

import SwiftUI


struct ItemRow: View {
    
    var category: Category
    @Binding var cart: [MenuItem]
    
    var action: (MenuItem) -> Void
    
    var body: some View {
        Section(header: Text(category.name).font(.headline)) {
            ForEach(category.items, id: \.id) { item in
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
    }
}

#Preview {
//    ItemRow()
}
