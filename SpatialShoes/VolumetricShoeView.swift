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
    
    @State private var entity = Entity()
    @State private var rotation: Rotation3D = .identity
    @State private var isRotating = false
    @State private var robotCreationOrientation: Rotation3D = Rotation3D()
    
    
    @State private var initialScale: CGFloat = 0.5
    @State private var scaleMagnified: Float = 0.5
    
    
    
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
                shoe.scale = [scaleMagnified,scaleMagnified,scaleMagnified]
                shoe.position.y = -0.2
                shoe.components.set(InputTargetComponent())
                /// Cambiarlo por un box?¿
                shoe.components.set(CollisionComponent(shapes: [.generateSphere(radius: 1)]))
                content.add(shoe)
                entity = shoe
            } catch {
                shoesVM.showAlert.toggle()
                shoesVM.errorMsg = "Error al cargar el modelo 3D"
            }
        } update: { content in
            if let shoe = content.entities.first {
                shoe.transform.scale = [scaleMagnified,scaleMagnified,scaleMagnified]
            }
        }
        .gesture(MagnifyGesture()
            .onChanged { value in
                let newScale = initialScale - (2.0 - value.magnification)
                if 0.2...2.0 ~= newScale {
                    scaleMagnified = Float(newScale)
                }
            }
            .onEnded { value in
                initialScale = CGFloat(scaleMagnified)
            })
        .simultaneousGesture(DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                handleDrag(value)
            }
            .onEnded { value in
                isRotating = false
            })

        .onDisappear {
            shoesVM.enlargedView = false
        }
                .alert("Error App", isPresented: $bindableShoe.showAlert) { } message: {
                    Text(shoesVM.errorMsg)
                }
        
    }
    
    func handleDrag(_ value: EntityTargetValue<DragGesture.Value>) {
        if !isRotating {
            isRotating = true
            robotCreationOrientation = Rotation3D(entity.orientation(relativeTo: nil))
        }
        let yRotation = value.gestureValue.translation.width / 100
        
        let rotationAngle = Angle2D(radians: yRotation)
        let rotation = Rotation3D(angle: rotationAngle, axis: RotationAxis3D.y)
        
        let startOrientation = robotCreationOrientation
        let newOrientation = startOrientation.rotated(by: rotation)
        entity.setOrientation(.init(newOrientation), relativeTo: nil)
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
