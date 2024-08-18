//
//  SpatialShoesApp.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 14/8/24.
//

import SwiftUI

@main
struct SpatialShoesApp: App {
    @State private var shoesVM = ShoesVM()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(shoesVM)
        }
        
        WindowGroup(id: "shoeEnlarged") {
            VolumetricShoeView()
                .environment(shoesVM)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 0.7, height: 0.7, depth: 0.7, in: .meters)
    }
}
