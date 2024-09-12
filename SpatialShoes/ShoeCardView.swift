//
//  ShoeCardView.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 5/9/24.
//

import SwiftUI
import RealityKit
import SpatialShoes3D

struct ShoeCardView: View {
    @State var shoe: ShoeModel
    
    @State private var rotationAngle: Double = 0.0
    
    var body: some View {
        VStack {
            Model3D(named: "\(shoe.model3DName)Scene",
                    bundle: spatialShoes3DBundle) { model in
                model
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 150, height: 120)
            .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: -1, z: 0))
            Text(shoe.name)
                .font(.title)
        }
        .frame(width: 230, height: 200)
        .padding()
        
        .onAppear {
            shoeRotation()
        }
    }
    private func shoeRotation() {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { _ in
            let angle = rotationAngle + 0.2
            rotationAngle = rotationAngle < 360 ? angle : 0
        }
        RunLoop.current.add(timer, forMode: .common)
    }
}

#Preview {
    ShoeCardView(shoe: .test)
}
