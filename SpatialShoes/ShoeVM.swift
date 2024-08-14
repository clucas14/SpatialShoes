//
//  ShoeVM.swift
//  Spatial Shoes
//
//  Created by Carlos Lucas Sánchez on 14/8/24.
//

import Foundation

@Observable
final class ShoeVM {
    let interactor: DataInteractor
    
    var shoes: [ShoeModel]
    
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
}
