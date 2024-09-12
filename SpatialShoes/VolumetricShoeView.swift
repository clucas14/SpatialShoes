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
    @Environment(\.dismissWindow) private var dismissWindow
    
    @State private var shoeEntity = Entity()

    @State private var isRotating = false
    @State private var initialOrientation: Rotation3D = .identity
    @State private var shoeCreationOrientation: Rotation3D = Rotation3D()
    
    @State private var initialScale: CGFloat = 0.5
    @State private var scaleMagnified: Float = 0.5
    
    var body: some View {
        @Bindable var bindableShoe = shoesVM
        
        if let selectedShoe = shoesVM.selectedShoe {
            RealityView { content, attachments  in
                do {
                    let shoeScene = try await Entity(named: "\(selectedShoe.model3DName)Scene", in: spatialShoes3DBundle)
                    shoeScene.scale = [scaleMagnified,scaleMagnified,scaleMagnified]
                    shoeScene.position = [0, -0.1, 0.2]
                    shoeScene.components.set(InputTargetComponent())
                    shoeScene.generateCollisionShapes(recursive: true)
                    content.add(shoeScene)
                    shoeEntity = shoeScene
                    if let nameShoe = attachments.entity(for: "nameShoe") {
                        nameShoe.setPosition([0, 1, 1], relativeTo: shoeScene)
                        nameShoe.scale = [2, 2, 2]
                        content.add(nameShoe)
                    }
                } catch {
                    shoesVM.showAlert.toggle()
                    shoesVM.errorMsg = "Error al cargar el modelo 3D"
                }
            } update: { content, attachments  in
                if let shoe = content.entities.first {
                    shoe.transform.scale = [scaleMagnified,scaleMagnified,scaleMagnified]
                }
            } attachments: {
                Attachment(id: "nameShoe") {
                    VStack {
                        Text(selectedShoe.name)
                            .font(.title)
                    }
                    .padding()
                    .glassBackgroundEffect()
                }
            }
            .gesture(MagnifyGesture()
                .onChanged { value in
                    let newScale = initialScale - (1.5 - value.magnification)
                    if 0.1...1.5 ~= newScale {
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
            .toolbar {
                ToolbarItem(placement: .bottomOrnament) {
                    HStack {
                        Button {
                            dismissWindow()
                        } label: {
                            Image(systemName: "xmark")
                        }
                        Button {
                            scaleMagnified = 0.5
                            shoeEntity.setOrientation(.init(initialOrientation), relativeTo: nil)
                        } label: {
                            Image(systemName: "gobackward")
                        }
                    }
                }
            }
            .onDisappear {
                shoesVM.enlargedView = false
            }
            .alert("Error App", isPresented: $bindableShoe.showAlert) { } message: {
                Text(shoesVM.errorMsg)
            }
        } else {
            Text("Ningún zapato seleccionado, por favor selecciona uno")
        }
    }
    
    private func handleDrag(_ value: EntityTargetValue<DragGesture.Value>) {
        if !isRotating {
            isRotating = true
            shoeCreationOrientation = Rotation3D(shoeEntity.orientation(relativeTo: nil))
        }
        let xRotation = value.translation.height / 100 // Controla la rotación vertical
        let yRotation = value.translation.width / 100  // Controla la rotación horizontal
        let rotationX = Rotation3D(angle: Angle2D(radians: xRotation), axis: RotationAxis3D.x)
        let rotationY = Rotation3D(angle: Angle2D(radians: yRotation), axis: RotationAxis3D.y)
        
        // Combina las rotaciones en los ejes X e Y
        let newOrientation = shoeCreationOrientation
            .rotated(by: rotationX)
            .rotated(by: rotationY)
        
        shoeEntity.setOrientation(.init(newOrientation), relativeTo: nil)
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
