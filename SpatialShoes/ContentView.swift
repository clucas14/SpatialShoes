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
    @Environment(ShoeVM.self) private var vm
    private let gridItem: [GridItem] = [GridItem(.adaptive(minimum: 250))]
    
    var body: some View {
        @Bindable var shoeBindable = vm
        VStack{
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Shoes")
                        .font(.title)
                        .padding(.leading, 32)
                    LazyVGrid(columns: gridItem) {
                        ForEach(vm.shoes) { shoe in
                            NavigationLink(value: shoe) {
                                VStack {
                                    Model3D(named: shoe.model3DName,
                                            bundle: spatialShoes3DBundle) { model in
                                        model
                                            .resizable()
                                            .scaledToFit()
                                        //                                                        .scaleEffect(scaleMagnified)
//                                            .offset(y: -50)
                                        //                                                        .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: -1, z: 0))
                                        //                                                        .rotation3DEffect(.degrees(Double(currentRotation)), axis: (x: 0, y: 1, z: 0))
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    Text(shoe.name)
                                        .font(.title)
                                    Text(shoe.brand)
                                        .font(.headline)
                                }
                                .padding()
                            }
                            .buttonBorderShape(.roundedRectangle(radius: 25))
//                            .buttonStyle(GridButton())
                        }
                    }
                }
            }
        }
        .alert("App Error", isPresented: $shoeBindable.showAlert) { } message: {
            Text(vm.errorMsg)
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(ShoeVM(interactor: DataTest()))
}
