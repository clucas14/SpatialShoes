//
//  DetailShoeView.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 4/9/24.
//

import SwiftUI
import RealityKit
import SpatialShoes3D

struct DetailShoeView: View {
    @Environment(ShoesVM.self) private var shoesVM
    @Environment(\.openWindow) private var open
    @Environment(\.dismiss) private var dismiss
    
    @State var selectedShoe: ShoeModel?
    
    @State private var isAnimatingFav = false
    @State private var scaleFav: CGFloat = 1.0
    @State private var scaleFavShadow: CGFloat = 1.0
    
    @State private var rotationAngle: Double = 0.0
    @State private var lastDragValue: CGFloat = 0.0
    @State private var velocity: CGFloat = 0.0
    
    @State private var free = false
    @State private var exhibitor = false
    
    @State private var currentRotation: CGFloat = 0.0
    
    @State private var initialScale: CGFloat = 0.6
    @State private var scaleMagnified: Double = 0.6
    
    @Binding var visibility: NavigationSplitViewVisibility
    
    @State var backButton = true
    
    var body: some View {
        Group {
            if let selectedShoe {
                HStack(spacing: 0) {
                    ScrollView {
                        HStack(alignment: .top) {
                            VStack {
                                CustomFormView(tittle: "Datos variados", arrayStrings: [
                                    ("Marca: ","\(selectedShoe.brandFormat)"),
                                    ("Tipo: ","\(selectedShoe.type)".capitalized),
                                    ("Garantía: ","\(selectedShoe.warranty) years"),
                                    ("Origen: ",selectedShoe.origin),
                                    ("Género: ",selectedShoe.gender),
                                    ("Peso: ","\(selectedShoe.weightFormat) Kg")
                                ])
                                CustomFormView(tittle: "Materiales", arrayStrings: [(selectedShoe.listMaterials,"")])
                            }
                            VStack {
                                CustomFormView(tittle: "Precio", arrayStrings: [(selectedShoe.priceFormat,"")])
                                CustomFormView(tittle: "Tamaño", arrayStrings: [(selectedShoe.listSize,"")])
                                CustomFormView(tittle: "Colores", arrayStrings: [(selectedShoe.listColors,"")])
                                CustomFormView(tittle: "Certificaciones", arrayStrings: selectedShoe.certifications.map{($0,"")})
                            }
                        }
                        CustomFormView(tittle: "Descripción", arrayStrings: [(selectedShoe.description,"")])
                        Text(selectedShoe.description)
//                        Text("Descubre la combinaci\u00f3n perfecta entre estilo y comodidad con nuestras **Urban Explorer** de **UrbanStride**")
                    }
                    .safeAreaPadding()
                    VStack {
                        Model3D(named: "\(selectedShoe.model3DName)Scene", bundle: spatialShoes3DBundle) { model in
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
                    .frame(width: 640)
                }
                .toolbar {
                    if backButton {
                        ToolbarItem(placement: .navigationBarLeading) {
                            HStack {
                                Button {
                                    visibility = .all
                                    shoesVM.selectedShoe = nil
//                                    rotationAngle = 0.0
//                                    currentRotation = 0.0
//                                    rotationAngle = 0.0
//                                    scaleMagnified = 0.6
//                                    free = false
//                                    exhibitor = false
                                } label: {
                                    HStack(spacing: 2) {
                                        Image(systemName: "chevron.backward")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 16, height: 16)
                                            .padding(14)
                                        
                                        Text("Atrás")
                                            .font(.body)
                                            .foregroundStyle(.secondary)
                                            .padding(.trailing, 24)
                                    }
                                }
                                .buttonStyle(BackButtonStyle())
                                .hoverEffectGroup()
                                Text(selectedShoe.name)
                                    .font(.title)
                                    .padding(.leading)
                            }
                        }
                    } else {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Text(selectedShoe.name)
                                .font(.title)
                                .offset(x: 72)
                        }
                    }
                    ToolbarItem(placement: .bottomOrnament) {
                        VStack {
                            Text(selectedShoe.name)
                                .font(.headline)
                            HStack {
                                Toggle(isOn: $free) {
                                    Image(systemName: "hand.point.up.left")
                                }
                                .disabled(exhibitor)
                                Toggle(isOn: $exhibitor) {
                                    Image(systemName: "rotate.3d")
                                }
                                .disabled(free)
                                Button {
                                    shoesVM.toggleFavorited(shoe: selectedShoe)
                                    if !selectedShoe.isFavorited {
                                        withAnimation(.easeInOut(duration: 0.75)) {
                                            scaleFav = 1.5
                                            scaleFavShadow = 2.5
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                                            withAnimation(.easeInOut(duration: 0.75)) {
                                                scaleFav = 1.0
                                                scaleFavShadow = 1.0
                                            }
                                        }
                                    }
                                } label: {
                                    Image(systemName: selectedShoe.isFavorited ? "star.fill" : "star")
                                        .scaleEffect(scaleFav)
                                        .overlay(
                                            Image(systemName: "star.fill")
                                                .scaleEffect(scaleFavShadow)
                                                .opacity(selectedShoe.isFavorited ? 0.1 : 0)
                                        )
                                }
                                Button {
                                    shoesVM.enlargedView = true
                                    shoesVM.selectedShoe = selectedShoe
                                    open(id: "shoeEnlarged")
                                } label: {
                                    Image(systemName: "arrow.up.forward.app")
                                }
                                .disabled(shoesVM.enlargedView)
                            }
                        }
                    }
                }
            } else {
                Text("Selecciona un zapato")
                    .font(.title)
            }
        }
        .onChange(of: shoesVM.selectedShoe) {
            selectedShoe = shoesVM.selectedShoe
            if shoesVM.selectedShoe == nil {
                dismiss()
            }
        }
        .onAppear {
            shoeRotation()
            selectedShoe = shoesVM.selectedShoe
        }
    }

    private func shoeRotation() {
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
    let vm = ShoesVM(interactor: DataTest())
    NavigationStack {
        DetailShoeView(visibility: .constant(.automatic))
            .environment(vm)
            .onAppear {
                vm.selectedShoe = vm.shoes.first
            }
    }
}
