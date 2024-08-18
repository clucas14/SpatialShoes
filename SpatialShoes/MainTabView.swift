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
            AllShoesView2()
                .tabItem {
                    Label("All shoes", systemImage: "shoe.2.fill")
                }
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
        .environment(ShoesVM(interactor: DataTest()))
}
