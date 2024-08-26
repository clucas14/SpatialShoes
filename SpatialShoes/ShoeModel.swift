//
//  ShoeModel.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 16/8/24.
//

import Foundation

struct ShoeModel: Identifiable, Hashable {
    let id: Int
    let name: String
    let brand: Brand
    let size: [Int]
    let price: Float
    let description: String
    let model3DName: String
    let type: ShoeType
    let materials: [String]
    let origin: String
    let gender: String
    let weight: Double
    let colors: [String]
    let warranty: Int
    let certifications: [String]
    var isFavorited: Bool
}

extension ShoeModel {
    var listSize: String {
        let stringSize = size.map{"\($0)"}
        return stringSize.formatted(.list(type: .or).locale(Locale(identifier: "ES")))
    }
    
    var listMaterials: String {
        return materials.formatted(.list(type: .and).locale(Locale(identifier: "ES")))
    }

    var listColors: String {
        return colors.formatted(.list(type: .and).locale(Locale(identifier: "ES")))
    }
    
    var listCertifications: String {
        return certifications.formatted(.list(type: .and).locale(Locale(identifier: "ES")))
    }
    
    var weightFormat: String {
        return String(format: "%.2f", arguments: [weight])
    }
    
    var priceFormat: String {
        return price.formatted(.currency(code: "EUR"))
    }
}
