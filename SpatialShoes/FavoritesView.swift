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
                ScrollView {
                    LazyVGrid(columns: gridItem) {
                        ForEach(shoesVM.shoesFavorites) { shoe in
                            NavigationLink(value: shoe) {
                                ShoeCardView(shoe: shoe)
                            }
                            .buttonBorderShape(.roundedRectangle(radius: 25))
                        //                            .buttonStyle(GridButton())
                        }
                        .padding()
                    }
                }
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
