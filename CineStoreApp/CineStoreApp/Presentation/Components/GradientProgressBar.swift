//
//  GradientProgressBar.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 26/08/24.
//

import SwiftUI
import Foundation

struct GradientProgressBar: View {
    var value: Double
    var maxValue: Double = 10.0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.gray.opacity(0.3))
                    .frame(height: 20)

                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.accentColor, Color.teal]),
                        startPoint: .leading,
                        endPoint: .trailing))
                    .frame(width: geometry.size.width * CGFloat(value / maxValue), height: 20)
            }
        }
        .frame(height: 20)
    }
}
