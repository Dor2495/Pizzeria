//
//  CustomProgressView.swift
//  Pizzeria
//
//  Created by Dor Mizrachi on 04/05/2025.
//

import SwiftUI

struct CustomProgressView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            ProgressView("Loading...")
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
        }
    }
}

#Preview {
    CustomProgressView()
}
