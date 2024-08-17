//
//  VolumetricShoe.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 17/8/24.
//

import SwiftUI
import RealityKit
import SpatialShoes3D

struct VolumetricShoe: View {
    @Environment(ShoesVM.self) private var shoesVM
       
    var body: some View {
        RealityView { content in
            guard let selectedShoe = shoesVM.selectedShoe else {
                shoesVM.showAlert.toggle()
                shoesVM.errorMsg = "No shoe selected, please select one"
                return
            }
            do {
                let scene = try await Entity(named: "\(selectedShoe.model3DName)Scene", in: spatialShoes3DBundle)
//                if let shoe = scene.findEntity(named: selectedShoe.model3DName) {
                    
                scene.scale = [0.5, 0.5, 0.5]
                    content.add(scene)
                    
//                }
            } catch {
                print("Error loading entity")
            }
        }
        .onDisappear {
            shoesVM.enlargedView = false
        }
    }
}

#Preview(windowStyle: .volumetric) {
    let shoesVM = ShoesVM(interactor: DataTest())
    VolumetricShoe()
        .environment(shoesVM)
        .onAppear {
            shoesVM.selectedShoe = shoesVM.shoes.first
        }
}
