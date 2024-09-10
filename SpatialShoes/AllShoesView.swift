//
//  ContentView.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 14/8/24.
//

import SwiftUI

struct AllShoesView: View {
    @Environment(ShoesVM.self) private var shoesVM
    
    @State private var selectedBrand: Brand?
    
    @State var visibility: NavigationSplitViewVisibility = .all
    
    var body: some View {
        @Bindable var bindableShoe = shoesVM
        
        NavigationSplitView(columnVisibility: $visibility) {
            List(selection: $selectedBrand) {
                ForEach(Brand.allCases, id: \.self) { brand in
                    Text(brand.rawValue.formattedBrand())
                        .tag(brand)
                }
            }
            .navigationTitle("Marcas")
            .navigationSplitViewColumnWidth(185)
        } content: {
            Group {
                if let selectedBrand = selectedBrand {
                    List(selection: $bindableShoe.selectedShoe) {
                        ForEach(shoesVM.shoesBy(brand: selectedBrand)) { shoe in
                            Text(shoe.name)
                                .tag(shoe)
                        }
                    }
                    .navigationTitle("Zapatos")
                    .navigationBarTitleDisplayMode(.inline)
                } else {
                    Text("Selecciona una marca")
                        .font(.title)
                }
            }
            .navigationSplitViewColumnWidth(200)
        } detail: {
            if shoesVM.selectedShoe != nil {
                DetailShoeView(visibility: $visibility)
            }  else {
                Text("Selecciona un zapato")
                    .font(.title)
            }
        }
        .onChange(of: shoesVM.selectedShoe) {
            if shoesVM.selectedShoe != nil {
                visibility = .detailOnly
            } else {
                visibility = .all
            }
        }
        .alert("Error App", isPresented: $bindableShoe.showAlert) { } message: {
            Text(shoesVM.errorMsg)
        }
    }
}

#Preview(windowStyle: .automatic) {
    let vm = ShoesVM(interactor: DataTest())
    AllShoesView()
        .environment(vm)
        .onAppear {
            vm.selectedShoe = vm.shoes.first
        }
}
