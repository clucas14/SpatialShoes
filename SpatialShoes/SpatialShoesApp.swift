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
                .frame(minWidth: 1080, maxWidth: 1480, minHeight: 608, maxHeight: 833)
        }
        .windowResizability(.contentSize)
        .defaultSize(CGSize(width: 1280, height: 720))
        WindowGroup(id: "shoeEnlarged") {
            VolumetricShoeView()
                .environment(shoesVM)
        }
        .windowStyle(.volumetric)
        .windowResizability(.contentSize)
        .defaultSize(width: 1.5, height: 1, depth: 1.5, in: .meters)
        .defaultWindowPlacement { _, context in
            if let mainWindow = context.windows.first {
                return WindowPlacement(.leading(mainWindow))
            }
            return WindowPlacement(.none)
        }
    }
}
