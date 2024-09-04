//
//  ContentView.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 14/8/24.
//

import SwiftUI
import RealityKit
import SpatialShoes3D

struct AllShoesView2: View {
    @Environment(ShoesVM.self) private var shoesVM
    @Environment(\.openWindow) private var open
    
    @State private var selectedBrand: Brand?
    
    @State private var rotationAngle: Double = 0.0
    @State private var lastDragValue: CGFloat = 0.0
    @State private var velocity: CGFloat = 0.0
    
    @State private var free = false
    @State private var exhibitor = false
    
    @State private var currentRotation: CGFloat = 0.0
    
    @State private var initialScale: CGFloat = 0.6
    @State private var scaleMagnified: Double = 0.6
    
    @State var visibility: NavigationSplitViewVisibility = .all
    
    var body: some View {
        @Bindable var shoeBindable = shoesVM
        
        NavigationSplitView(columnVisibility: $visibility) {
            List(selection: $selectedBrand) {
                ForEach(Brand.allCases, id: \.self) { brand in
                    Text(brand.rawValue)
                        .tag(brand)
                }
            }
            .navigationTitle("Brands")
            .navigationSplitViewColumnWidth(185)
        } content: {
            Group {
                if let selectedBrand = selectedBrand {
                    List(selection: $shoeBindable.selectedShoe) {
                        ForEach(shoesVM.shoesBy(brand: selectedBrand)) { shoe in
                            Text(shoe.name)
                                .tag(shoe)
                        }
                    }
                    .navigationTitle("Shoes")
                    .navigationBarTitleDisplayMode(.inline)
                } else {
                    Text("Select a brand")
                        .font(.title)
                }
            }
            .navigationSplitViewColumnWidth(200)
        } detail: {
            if let selectedShoe = shoesVM.selectedShoe {
                HStack(spacing: 0) {
                    ScrollView {
                        HStack(alignment: .top) {
                            VStack {
                                CustomFormView(tittle: "Datos variados", arrayStrings: [
                                    ("Brand: ","\(selectedShoe.brand.rawValue)"),
                                    ("Type: ","\(selectedShoe.type)".capitalized),
                                    ("Warranty: ","\(selectedShoe.warranty) years"),
                                    ("Origin: ",selectedShoe.origin),
                                    ("Gender: ",selectedShoe.gender),
                                    ("Weight: ","\(selectedShoe.weightFormat) Kg")
                                ])
                                CustomFormView(tittle: "Materials", arrayStrings: [(selectedShoe.listMaterials,"")])
                            }
                            VStack {
                                CustomFormView(tittle: "Price", arrayStrings: [(selectedShoe.priceFormat,"")])
                                CustomFormView(tittle: "Size", arrayStrings: [(selectedShoe.listSize,"")])
                                CustomFormView(tittle: "Colors", arrayStrings: [(selectedShoe.listColors,"")])
                                CustomFormView(tittle: "Certifications", arrayStrings: selectedShoe.certifications.map{($0,"")})
                            }
                        }
                        CustomFormView(tittle: "Description", arrayStrings: [(selectedShoe.description,"")])
                        }
                    .safeAreaPadding()
                    Model3D(named: "\(selectedShoe.model3DName)Scene", bundle: spatialShoes3DBundle) { model in
                        model
                            .resizable()
                        
                        //                                                .scaledToFit()
                            .scaleEffect(scaleMagnified)
                            .aspectRatio(contentMode: .fit)
                        //                            .position(x: 0, y: 0)
                            .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: -1, z: 0))
                            .rotation3DEffect(.degrees(Double(currentRotation)), axis: (x: 0, y: 1, z: 0))
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(minWidth: 450, maxWidth: 600)
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
                .navigationTitle(selectedShoe.name)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        //                        if visibility != .all {
                        Button {
                            rotationAngle = 0.0
                            currentRotation = 0.0
                            rotationAngle = 0.0
                            scaleMagnified = 0.6
                            free = false
                            exhibitor = false
                            visibility = .all
                            shoesVM.selectedShoe = nil
                        } label: {
                            Image(systemName: "chevron.backward")
                        }
                        //                        }
                    }
                    ToolbarItem(placement: .bottomOrnament) {
                        VStack {
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
                                //                                    }
                                //                                }
                                //                            .font(.title)
                                //                            Text(selectedShoe.name)
                                //                                .font(.headline)
                            }
                        }
                    }
                    
                }
            } else {
                Text("Select a shoe")
                    .font(.title)
            }
        }
        .onChange(of: shoesVM.selectedShoe) {
            if shoesVM.selectedShoe != nil {
                visibility = .detailOnly
            }
        }
        .onAppear {
            shoeRotation()
            //            shoesVM.selectShoe()
        }
        .alert("App Error", isPresented: $shoeBindable.showAlert) { } message: {
            Text(shoesVM.errorMsg)
        }
        
    }
    
    //    func changeVisibility() {
    //        visibility = .detailOnly
    //    }
    
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
    let vm = ShoesVM(interactor: DataTest())
    AllShoesView2()
        .environment(vm)
        .onAppear {
            vm.selectedShoe = vm.shoes.first
        }
}
