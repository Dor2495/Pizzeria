//
//  MenuItemRow.swift
//  Pizzeria
//
//  Created by Dor Mizrachi on 04/05/2025.
//

import SwiftUI

struct MenuItemRow: View {
    
    var item: MenuItem
    var itemCount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.name)
                .font(.subheadline)
                .bold()
            Text(item.description)
                .font(.footnote)
                .foregroundColor(.gray)
            HStack {
                Text(String(format: "$%.2f", item.price))
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                
                Spacer()
                if item.vegetarian {
                    Text("🌱")
                }
                if itemCount > 0 {
                    Text("X \(itemCount)")
                }
            }
            
        }
        .padding(.vertical, 4)
    }
}

#Preview {
//    MenuItemRow()
}
