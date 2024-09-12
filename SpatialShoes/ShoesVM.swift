//
//  ShoeVM.swift
//  Spatial Shoes
//
//  Created by Carlos Lucas Sánchez on 14/8/24.
//

import SwiftUI

@Observable
final class ShoesVM {
    let interactor: DataInteractor
    
    var shoes: [ShoeModel] {
        didSet {
            do {
                try interactor.saveShoes(json: shoes)
            } catch {
                errorMsg = "Ha habido un error al guardar los datos: \(error.localizedDescription)"
                showAlert.toggle()
            }
        }
    }
    
    var selectedShoe: ShoeModel?
    
    var enlargedView = false
    var free = false
    var exhibitor = false
    
    var visibility: NavigationSplitViewVisibility = .all
    
    var shoesFavorites: [ShoeModel] {
        shoes.filter { $0.isFavorited  }
    }
    
    var search = ""
    
    var filteredShoes: [ShoeModel] {
        shoes.filter{ shoe in
            if search.isEmpty {
                true
            } else {
                shoe.name.localizedStandardContains(search)
            }
        }
    }
    
    var showAlert = false
    @ObservationIgnored var errorMsg = ""
    
    init(interactor: DataInteractor = Interactor()) {
        self.interactor = interactor
        do {
            self.shoes = try interactor.getShoes()
        } catch {
            self.shoes = []
            errorMsg = "\(error)"
            showAlert.toggle()
        }
    }
    
    func shoesBy(brand: Brand) -> [ShoeModel] {
        shoes.filter { $0.brand == brand }
    }
    
    func toggleFavorited(shoe: ShoeModel) {
        if let index = shoes.firstIndex(of: shoe) {
            shoes[index].isFavorited.toggle()
            selectedShoe = shoes[index]
        }
    }
    
    func resetTools() {
        free = false
        exhibitor = false
    }
}
