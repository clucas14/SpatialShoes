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
    
    @State var entity = Entity()
    @State var rotation: Rotation3D = .identity
    
    @State private var rotationAngle: Double = 0.0
    @State private var lastDragValue: CGFloat = 0.0
    @State private var velocity: CGFloat = 0.0
    
    @State private var free = false
    @State private var exhibitor = false
    
    @State private var currentRotation: CGFloat = 0.0
    
    var body: some View {
        @Bindable var bindableShoe = shoesVM
        
        RealityView { content in
            guard let selectedShoe = shoesVM.selectedShoe else {
                shoesVM.showAlert.toggle()
                shoesVM.errorMsg = "Ningún zapato seleccionado, por favor selecciona uno"
                return
            }
            do {
                let shoe = try await Entity(named: "\(selectedShoe.model3DName)Scene", in: spatialShoes3DBundle)
                //                if let shoe = scene.findEntity(named: selectedShoe.model3DName) {
                //                modelEntity = shoe
                shoe.scale = [0.5, 0.5, 0.5]
                shoe.components.set(InputTargetComponent())
                content.add(shoe)
                entity = shoe
                //                }
            } catch {
                shoesVM.showAlert.toggle()
                shoesVM.errorMsg = "Error al cargar el modelo 3D"
            }
        } update: { content in
                
        }
        .gesture(
            HandleDragGesture(free: free, currentRotation: $currentRotation, lastDragValue: $lastDragValue, velocity: $velocity)
                .dragGesture()
        )
        .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: -1, z: 0))
        .alert("Error App", isPresented: $bindableShoe.showAlert) { } message: {
            Text(shoesVM.errorMsg)
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
