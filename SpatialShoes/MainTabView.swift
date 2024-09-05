//
//  TabView.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 18/8/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            AllShoesView()
                .tabItem {
                    Label("Zapatos", systemImage: "shoe.2.fill")
                }
            FavoritesView()
                .tabItem {
                    Label("Favoritos", systemImage: "star.fill")
                }
            SearchView()
                .tabItem {
                    Label("Búsqueda", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    MainTabView()
        .environment(ShoesVM(interactor: DataTest()))
}
