//
//  SearchView.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 5/9/24.
//

import SwiftUI

struct SearchView: View {
    @Environment(ShoesVM.self) private var shoesVM
    
    private let gridItem: [GridItem] = [GridItem(.adaptive(minimum: 260))]
    
    var body: some View {
        @Bindable var shoeBindable = shoesVM
        
        NavigationStack {
            VStack {
                if shoesVM.search.isEmpty {
                    ContentUnavailableView("Inicia la búsqueda", systemImage: "magnifyingglass")
                } else if shoesVM.filteredShoes.isEmpty {
                    ContentUnavailableView("Búsqueda vacía", systemImage: "magnifyingglass", description: Text("No hay resultados con el texto \(shoesVM.search)"))
                } else {
                    ScrollView {
                        LazyVGrid(columns: gridItem) {
                            ForEach(shoesVM.filteredShoes) { shoe in
                                NavigationLink(value: shoe) {
                                    ShoeCardView(shoe: shoe)
                                    
                                }
                                .buttonBorderShape(.roundedRectangle(radius: 24))
                                //                            .buttonStyle(GridButton())
                            }
                            .padding()
                        }
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle("Búsqueda")
            .navigationDestination(for: ShoeModel.self) { shoe in
                DetailShoeView(selectedShoe: shoe, visibility: .constant(.automatic), backButton: false)
            }
            .searchable(text: $shoeBindable.search, placement: .navigationBarDrawer, prompt: Text("Búsqueda por nombre"))
        }
    }
}

#Preview(windowStyle: .automatic) {
    SearchView()
        .environment(ShoesVM(interactor: DataTest()))
}
