//
//  SpatialShoesApp.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 14/8/24.
//

import SwiftUI

@main
struct SpatialShoesApp: App {
    @State private var vm = ShoeVM()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(vm)
        }
    }
}
