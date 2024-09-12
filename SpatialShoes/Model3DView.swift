//
//  Model3DView.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 12/9/24.
//

import SwiftUI
import RealityKit
import SpatialShoes3D

struct Model3DView: View {
    @Environment(ShoesVM.self) private var shoesVM
    @Environment(\.openWindow) private var open
    
    @State var shoe: ShoeModel
    
    @State private var rotationAngle: Double = 0.0
    @State private var lastDragValue: CGFloat = 0.0
    @State private var velocity: CGFloat = 0.0
    
    @State private var initialScale: CGFloat = 0.6
    @State private var scaleMagnified: Double = 0.6
    @State private var currentRotation: CGFloat = 0.0
    
    var body: some View {
        VStack {
            Model3D(named: "\(shoe.model3DName)Scene", bundle: spatialShoes3DBundle) { model in
                model
                    .resizable()
                    .scaleEffect(scaleMagnified)
                    .aspectRatio(contentMode: .fit)
                    .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: -1, z: 0))
                    .rotation3DEffect(.degrees(Double(currentRotation)), axis: (x: 0, y: 1, z: 0))
            } placeholder: {
                ProgressView()
            }
            .frame(maxWidth: 550)
            .gesture(
                HandleDragGesture(free: shoesVM.free, currentRotation: $currentRotation, lastDragValue: $lastDragValue, velocity: $velocity)
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
        .frame(width: 640)
        .onAppear {
            shoeRotation()
        }
    }
    
    private func shoeRotation() {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { _ in
            let angle = rotationAngle + 0.2
            if shoesVM.exhibitor {
                rotationAngle = rotationAngle < 360 ? angle : 0
            }
        }
        RunLoop.current.add(timer, forMode: .common)
    }
}

#Preview {
    Model3DView(shoe: .test)
        .environment(ShoesVM(interactor: DataTest()))
}
