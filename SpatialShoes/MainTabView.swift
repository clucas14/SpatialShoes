//
//  TabView.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 18/8/24.
//

import SwiftUI

struct MainTabView: View {
    @Environment(ShoesVM.self) private var shoesVM
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            AllShoesView()
                .tabItem {
                    Label("Zapatos", systemImage: "shoe.2.fill")
                }
                .tag(0)
            FavoritesView()
                .tabItem {
                    Label("Favoritos", systemImage: "star.fill")
                }
                .tag(1)
            SearchView()
                .tabItem {
                    Label("Búsqueda", systemImage: "magnifyingglass")
                }
                .tag(2)
        }
        .onChange(of: selectedTab) {
            shoesVM.selectedShoe = nil
        }
    }
}

#Preview {
    MainTabView()
        .environment(ShoesVM(interactor: DataTest()))
}
