//
//  GridBitton.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 14/8/24.
//

import SwiftUI

struct BackButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
                configuration.label
                    .background(.thinMaterial)
                    .hoverEffect(.highlight)
                    .hoverEffect { effect, isActive, proxy in
                        effect.animation(.default.delay(isActive ? 0.6 : 0.2)) {
                            $0.clipShape(.capsule.size(
                                width: isActive ? proxy.size.width : proxy.size.height,
                                height: proxy.size.height,
                                anchor: .leading
                            ))
                        }.scaleEffect(isActive ? 1.05 : 1.0)
                    }
            }
    }
