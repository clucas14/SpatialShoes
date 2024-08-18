//
//  VolumetricShoe.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 17/8/24.
//

import SwiftUI
import RealityKit
import SpatialShoes3D

struct VolumetricShoeView: View {
    @Environment(ShoesVM.self) private var shoesVM
       
    var body: some View {
        RealityView { content in
            guard let selectedShoe = shoesVM.selectedShoe else {
                shoesVM.showAlert.toggle()
                shoesVM.errorMsg = "No shoe selected, please select one"
                return
            }
            do {
                let shoe = try await Entity(named: "\(selectedShoe.model3DName)Scene", in: spatialShoes3DBundle)
//                if let shoe = scene.findEntity(named: selectedShoe.model3DName) {
                    
                shoe.scale = [0.5, 0.5, 0.5]
                shoe.components.set(InputTargetComponent())
                    content.add(shoe)
                    
//                }
            } catch {
                shoesVM.showAlert.toggle()
                shoesVM.errorMsg = "Error loading entity"
            }
        } update: { content in
            if let model = content.entities.first {
//                model.transform.scale = scale
            }
        }
        .onDisappear {
            shoesVM.enlargedView = false
        }
    }
}

#Preview(windowStyle: .volumetric) {
    let shoesVM = ShoesVM(interactor: DataTest())
    VolumetricShoeView()
        .environment(shoesVM)
        .onAppear {
            shoesVM.selectedShoe = shoesVM.shoes.first
        }
}
