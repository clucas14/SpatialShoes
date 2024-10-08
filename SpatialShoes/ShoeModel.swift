//
//  ShoeModel.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 16/8/24.
//

import Foundation

struct ShoeModel: Codable, Identifiable, Hashable {
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
        materials.formatted(.list(type: .and).locale(Locale(identifier: "ES")))
    }

    var listColors: String {
        colors.formatted(.list(type: .and).locale(Locale(identifier: "ES")))
    }
    
    var listCertifications: String {
        certifications.formatted(.list(type: .and).locale(Locale(identifier: "ES")))
    }
    
    var weightFormat: String {
        String(format: "%.2f", arguments: [weight])
    }
    
    var priceFormat: String {
        price.formatted(.currency(code: "EUR"))
    }
    
    var brandFormat: String {
        brand.rawValue.formattedBrand()
    }
}
