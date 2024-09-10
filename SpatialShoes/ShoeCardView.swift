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
            Text(shoe.name)
                .font(.title)
            Text(shoe.brand.rawValue)
                .font(.headline)
        }
        .frame(width: 230, height: 200)
        .padding()
    }
}

#Preview {
    ShoeCardView(shoe: .test)
}
