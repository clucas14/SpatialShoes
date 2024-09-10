//
//  GridView.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 16/8/24.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(ShoesVM.self) private var shoesVM
    
    private let gridItem: [GridItem] = [GridItem(.adaptive(minimum: 260))]
    
    var body: some View {
        NavigationStack {
            VStack {
                if !shoesVM.shoesFavorites.isEmpty {
                    ScrollView {
                        LazyVGrid(columns: gridItem) {
                            ForEach(shoesVM.shoesFavorites) { shoe in
                                NavigationLink(value: shoe) {
                                    ShoeCardView(shoe: shoe)
//                                        .onTapGesture {
//                                            shoesVM.selectedShoe = shoe
//                                        }
                                }
                                .buttonBorderShape(.roundedRectangle(radius: 24))
//                                                        .buttonStyle(GridButton())
                                
                            }
                            .padding()
                        }
                    }
                } else {
                    ContentUnavailableView("No hay favoritos", systemImage: "star.fill", description: Text("No tienes ningún zapato seleccionado como favorito, por favor selecciona alguno."))
                }
            }
            .padding(.horizontal)
            .navigationTitle("Favoritos")
            .navigationDestination(for: ShoeModel.self) { shoe in
                DetailShoeView(/*selectedShoe: shoe,*/ visibility: .constant(.automatic), backButton: false)
                    .onAppear {
                        shoesVM.selectedShoe = shoe
                    }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    FavoritesView()
        .environment(ShoesVM(interactor: DataTest()))
}
