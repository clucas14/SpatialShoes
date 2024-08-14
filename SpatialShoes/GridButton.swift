//
//  GridBitton.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 14/8/24.
//

import SwiftUI

struct GridButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .buttonStyle(.plain)
            .buttonBorderShape(.roundedRectangle(radius: 25))
            .hoverEffect(.highlight)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
