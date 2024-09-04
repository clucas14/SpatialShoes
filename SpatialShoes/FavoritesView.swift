//
//  GridView.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 16/8/24.
//

import SwiftUI
import RealityKit
import SpatialShoes3D

struct FavoritesView: View {
    @Environment(ShoesVM.self) private var shoesVM
    private let gridItem: [GridItem] = [GridItem(.adaptive(minimum: 260))]
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: gridItem) {
                        ForEach(shoesVM.shoesFavorites) { shoe in
                            NavigationLink(value: shoe) {
                                VStack {
                                    Model3D(named: "\(shoe.model3DName)Scene",
                                            bundle: spatialShoes3DBundle) { model in
                                        model
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                        // .scaledToFit()
                                        // .scaleEffect(scaleMagnified)
                                        // .offset(y: -50)
                                        // .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: -1, z: 0))
                                        // .rotation3DEffect(.degrees(Double(currentRotation)), axis: (x: 0, y: 1, z: 0))
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 150, height: 150)
                                    Text(shoe.name)
                                        .font(.title)
                                    Text(shoe.brand.rawValue)
                                        .font(.headline)
                                }
                                .frame(width: 230, height: 250)
                                .padding()
                            }
                            
                            
                            .buttonBorderShape(.roundedRectangle(radius: 25))
                            //                            .buttonStyle(GridButton())
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Favoritos")
            .navigationDestination(for: ShoeModel.self) { shoe in
                DetailShoeView(selectedShoe: shoe, visibility: .constant(.automatic), backButton: false)
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    FavoritesView()
        .environment(ShoesVM(interactor: DataTest()))
}
