//
//  Banner.swift
//  Pizzeria
//
//  Created by Dor Mizrachi on 04/05/2025.
//

import SwiftUI

struct Banner: View {
    var title: String
    @Binding var isOn: Bool
    
    var body: some View {
        ZStack {
            Color.green.opacity(isOn ? 1 : 0)
            VStack {
                Text("\(title)")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .opacity(isOn ? 1 : 0)
        .frame(width: 250, height: 70)
        .cornerRadius(20)
        .offset(
            x: 0,
            y: isOn ?  UIScreen.main.bounds.height / 3 : UIScreen.main.bounds.height / 2
        )
    }
}

#Preview {
    Banner(title: "title", isOn: .constant(true))
}
