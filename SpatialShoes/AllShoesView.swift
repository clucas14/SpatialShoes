//
//  ContentView.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 14/8/24.
//

import SwiftUI
import RealityKit
import SpatialShoes3D

struct AllShoesView: View {
    @Environment(ShoesVM.self) private var shoesVM
    @Environment(\.openWindow) private var open
    
    @State private var rotationAngle: Double = 0.0
    @State private var lastDragValue: CGFloat = 0.0
    @State private var velocity: CGFloat = 0.0
    
    @State private var free = false
    @State private var exhibitor = true
    
    @State private var currentRotation: CGFloat = 0.0
    
    @State private var initialScale: CGFloat = 0.6
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
//                        .scaledToFit()
                        .scaleEffect(scaleMagnified)
                                            .aspectRatio(contentMode: .fit)
                    //                        .scaleEffect(x: 0.5, y: 0.5, z: 0.5) // Escala el modelo
                        
                        .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: -1, z: 0))
                        .rotation3DEffect(.degrees(Double(currentRotation)), axis: (x: 0, y: 1, z: 0))
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 400, height: 450)
                .gesture(
                    HandleDragGesture(free: free, currentRotation: $currentRotation, lastDragValue: $lastDragValue, velocity: $velocity)
                        .dragGesture()
                )
                .gesture(
                    HandleMagnifyGesture(initialScale: $initialScale, scaleMagnified: $scaleMagnified)
                        .magnifyGesture()
                )
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            if !shoesVM.enlargedView {
                                shoesVM.enlargedView = true
                                open(id: "shoeEnlarged")
                            }
                        }
                )
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
    

}

#Preview(windowStyle: .automatic) {
    AllShoesView()
        .environment(ShoesVM(interactor: DataTest()))
}
