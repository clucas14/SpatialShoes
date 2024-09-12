//
//  ToolBarOrnament.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 12/9/24.
//

import SwiftUI

struct ToolBarOrnament: View {
    @Environment(ShoesVM.self) private var shoesVM
    @Environment(\.openWindow) private var open
    
    @State var shoe: ShoeModel?
    
    @State private var isAnimatingFav = false
    @State private var scaleFav: CGFloat = 1.0
    @State private var scaleFavShadow: CGFloat = 1.0
    
    var body: some View {
        @Bindable var shoeBindable = shoesVM
        
        VStack {
            if let shoe {
                Text(shoe.name)
                    .font(.headline)
                HStack {
                    Toggle(isOn: $shoeBindable.free) {
                        Image(systemName: "hand.point.up.left")
                    }
                    .disabled(shoesVM.exhibitor)
                    Toggle(isOn: $shoeBindable.exhibitor) {
                        Image(systemName: "rotate.3d")
                    }
                    .disabled(shoesVM.free)
                    Button {
                        shoesVM.toggleFavorited(shoe: shoe)
                        if !shoe.isFavorited {
                            withAnimation(.easeInOut(duration: 0.75)) {
                                scaleFav = 1.5
                                scaleFavShadow = 2.5
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                                withAnimation(.easeInOut(duration: 0.75)) {
                                    scaleFav = 1.0
                                    scaleFavShadow = 1.0
                                }
                            }
                        }
                    } label: {
                        Image(systemName: shoe.isFavorited ? "star.fill" : "star")
                            .scaleEffect(scaleFav)
                            .overlay(
                                Image(systemName: "star.fill")
                                    .scaleEffect(scaleFavShadow)
                                    .opacity(shoe.isFavorited ? 0.1 : 0)
                            )
                    }
                    Button {
                        shoesVM.enlargedView = true
                        open(id: "shoeEnlarged")
                    } label: {
                        Image(systemName: "arrow.up.forward.app")
                    }
                    .disabled(shoesVM.enlargedView)
                }
            }
        }
        .onChange(of: shoesVM.selectedShoe) {
            shoe = shoesVM.selectedShoe
        }
    }
}
