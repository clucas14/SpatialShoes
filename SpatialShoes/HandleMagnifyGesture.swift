//
//  MagnifyGestureHandler.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 18/8/24.
//

import SwiftUI

struct HandleMagnifyGesture {
    @Binding var initialScale: CGFloat
    @Binding var scaleMagnified: Double
    
    func magnifyGesture() -> some Gesture {
        MagnifyGesture()
            .onChanged { value in
                let newScale = initialScale - (2.0 - value.magnification)
                if 0.4...2.0 ~= newScale {
                    scaleMagnified = newScale
                }
            }
            .onEnded { value in
                initialScale = scaleMagnified
            }
    }
}
