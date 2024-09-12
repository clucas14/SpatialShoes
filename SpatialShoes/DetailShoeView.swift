//
//  DetailShoeView.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 4/9/24.
//

import SwiftUI

struct DetailShoeView: View {
    @Environment(ShoesVM.self) private var shoesVM
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dismissWindow) private var dismissWindow
    
    @State var backButton = true
    
    @State private var selectedShoe: ShoeModel?
    
    var body: some View {
        @Bindable var shoeBindable = shoesVM
        
        Group {
            if let selectedShoe {
                HStack(spacing: 0) {
                    ScrollView {
                        HStack(alignment: .top) {
                            VStack {
                                CustomFormView(tittle: "Datos variados", arrayStrings: [
                                    ("Marca:","\(selectedShoe.brandFormat)"),
                                    ("Tipo:","\(selectedShoe.type)".capitalized),
                                    ("Garantía:","\(selectedShoe.warranty) years"),
                                    ("Origen:",selectedShoe.origin),
                                    ("Género:",selectedShoe.gender),
                                    ("Peso:","\(selectedShoe.weightFormat) Kg")
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
                    }
                    .safeAreaPadding()
                    Model3DView(shoe: selectedShoe)
                }
                .toolBar(shoe: selectedShoe, backButton: backButton)
            } else {
                Text("Selecciona un zapato")
                    .font(.title)
            }
        }
        .onChange(of: shoesVM.selectedShoe) {
            selectedShoe = shoesVM.selectedShoe
            if shoesVM.selectedShoe == nil {
                dismissWindow(id: "shoeEnlarged")
                dismiss()
            }
        }
        .onAppear {
            shoesVM.resetTools()
            selectedShoe = shoesVM.selectedShoe
        }
    }
}

#Preview(windowStyle: .automatic) {
    let vm = ShoesVM(interactor: DataTest())
    NavigationStack {
        DetailShoeView()
            .environment(vm)
            .onAppear {
                vm.selectedShoe = vm.shoes.first
            }
    }
}
