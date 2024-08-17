//
//  ContentView.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 14/8/24.
//

import SwiftUI
import RealityKit
import SpatialShoes3D

struct ContentView: View {
    @Environment(ShoesVM.self) private var shoesVM
    @Environment(\.openWindow) private var open
    
    @State private var rotationAngle: Double = 0.0
    
    @State private var free = false
    @State private var exhibitor = true
    
    @State private var currentRotation: CGFloat = 0.0
    @State private var lastDragValue: CGFloat = 0.0
    @State private var velocity: CGFloat = 0.0
    
    @State var initialScale: CGFloat = 0.6
    @State private var scaleMagnified: Double = 1.0
    
    var body: some View {
        @Bindable var shoeBindable = shoesVM
        
        NavigationSplitView {
            List(selection: $shoeBindable.selectedShoe) {
                ForEach(shoesVM.shoes) { shoe in
                    Text(shoe.name)
                        .tag(shoe)
                }
            }
            .navigationTitle("Shoes")
            .navigationSplitViewColumnWidth(150)
            .toolbar {
                ToolbarItem(placement: .bottomOrnament) {
                    VStack {
                        if let selectedShoe = shoesVM.selectedShoe {
                            Text(selectedShoe.name)
                                .font(.title2)
                        }
                        HStack {
                            Toggle(isOn: $free) {
                                Image(systemName: "hand.point.up.left")
                            }
                            .disabled(exhibitor)
                            Toggle(isOn: $exhibitor) {
                                Image(systemName: "rotate.3d")
                            }
                            .disabled(free)
                            if let selectedShoe = shoesVM.selectedShoe {
                                Button {
                                    shoesVM.toggleFavorited(shoe: selectedShoe)
                                } label: {
                                    Image(systemName: selectedShoe.isFavorited ? "star.fill" : "star.slash.fill")
                                }
                                Button {
                                    shoesVM.enlargedView = true
                                    open(id: "shoeEnlarged")
                                } label: {
                                    Image(systemName: "arrow.up.forward.app")
                                }
                                .disabled(shoesVM.enlargedView)
                            }
                        }
                        .font(.title)
                    }
                }
            }
        } content: {
            if let selectedShoe = shoesVM.selectedShoe {
                Text(selectedShoe.description)
                    .padding()
            }
        } detail: {
            if let selectedShoe = shoesVM.selectedShoe {
                Model3D(named: "\(selectedShoe.model3DName)Scene", bundle: spatialShoes3DBundle) { model in
                    model
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(scaleMagnified)
//                        .aspectRatio(contentMode: .fit)
//                        .scaleEffect(x: 0.5, y: 0.5, z: 0.5) // Escala el modelo
                        .frame(width: 450, height: 450)
                        .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: -1, z: 0))
                        .rotation3DEffect(.degrees(Double(currentRotation)), axis: (x: 0, y: 1, z: 0))
                } placeholder: {
                    ProgressView()
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let delta = value.translation.width - lastDragValue
                            velocity = delta / 10
                            lastDragValue = value.translation.width
                            if free {
                                currentRotation += velocity
                            }
                        }
                        .onEnded { _ in
                            lastDragValue = 0.0
                            if free {
                                startInertial()
                            }
                        }
                )
                .gesture(
                    MagnifyGesture()
                        .onChanged { value in
                            // La escala es sobre 1.0
                            let newScale = initialScale - (2.0 - value.magnification)
                            if 0.4...2.0 ~= newScale {
                                scaleMagnified = newScale
                            }
                        }
                        .onEnded { value in
                            initialScale = scaleMagnified
                        }
                )
                //                RealityView { content in
                //                    do {
                //                        let scene = try await Entity(named: "Shoes", in: spatialShoes3DBundle)
                //                        if let shoe = scene.findEntity(named: selectedShoe.model3DName) {
                //
                //                           // shoe.scale = [0.5, 0.5, 0.5]
                //                            content.add(shoe)
                //
                //                        }
                //                    } catch {
                //                        print("Error al cargar entidad")
                //                    }
                //                }
                //                .frame(width: 150, height: 150)
            }
        }
        .onAppear {
            shoeRotation()
            shoesVM.selectShoe()
        }
        .alert("App Error", isPresented: $shoeBindable.showAlert) { } message: {
            Text(shoesVM.errorMsg)
        }
    }
    
    func shoeRotation() {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { _ in
            let angle = rotationAngle + 0.2
            if exhibitor {
                rotationAngle = rotationAngle < 360 ? angle : 0
            }
        }
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func startInertial() {
        let inertialTimer =  Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { timer in
            if abs(velocity) < 0.01 {
                timer.invalidate()
            } else {
                velocity *= 0.95
                currentRotation += velocity
            }
        }
        RunLoop.current.add(inertialTimer, forMode: .common)
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(ShoesVM(interactor: DataTest()))
}




//:MARK
/*RealityView { content in
 do {
 let scene = try await Entity(named: "Shoes", in: spatialShoes3DBundle)
 if let shoe = scene.findEntity(named: shoe.model3DName) {
 
 //                                                shoe.scale = SIMD3<Float>(repeating: 0.5)
 content.add(shoe)
 
 }
 } catch {
 print("Error al cargar entidad")
 }
 }
 .frame(width: 150, height: 150)
 */
