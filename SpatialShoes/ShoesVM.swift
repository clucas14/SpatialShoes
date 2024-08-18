//
//  ShoeVM.swift
//  Spatial Shoes
//
//  Created by Carlos Lucas Sánchez on 14/8/24.
//

import Foundation

@Observable
final class ShoesVM {
    let interactor: DataInteractor
    
    var shoes: [ShoeModel]
    
    var selectedShoe: ShoeModel?
    
    var enlargedView = false
    
    var shoesFavorites: [ShoeModel] {
        shoes.filter { $0.isFavorited  }
    }
    
    var showAlert = false
    @ObservationIgnored var errorMsg = ""
    
    init(interactor: DataInteractor = Interactor()) {
        self.interactor = interactor
        do {
            self.shoes = try interactor.getData()
        } catch {
            self.shoes = []
            errorMsg = "\(error)"
            showAlert.toggle()
        }
    }
    
    func selectShoe() {
        if selectedShoe == nil {
            selectedShoe = shoes.first
        }
    }
    
    func toggleFavorited(shoe: ShoeModel) {
        if let index = shoes.firstIndex(of: shoe) {
//        if let index = shoes.firstIndex(where: { $0.id == shoe.id }) {
            shoes[index].isFavorited.toggle()
            selectedShoe = shoes[index]
        }
    }
}
