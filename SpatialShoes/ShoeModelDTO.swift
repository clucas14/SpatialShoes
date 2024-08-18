//
//  ShoeModel.swift
//  Spatial Shoes
//
//  Created by Carlos Lucas Sánchez on 14/8/24.
//

import Foundation

struct ShoeModelDTO: Codable {
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
}

enum ShoeType: String, Codable {
    case botas = "Botas"
    case casual = "Casual"
    case deportivas = "Deportivas"
    case especiales = "Especiales"
    case formales = "Formales"
    case tacones = "Tacones"
}

enum Brand: String, Codable, CaseIterable {
    case athletica = "Athletica"
    case elegancewalk = "EleganceWalk"
    case gentlemenstyle = "GentlemenStyle"
    case urbanstride = "UrbanStride"
}

extension ShoeModelDTO {
    var toPresentation: ShoeModel {
        ShoeModel(
            id: id,
            name: name,
            brand: brand,
            size: size,
            price: price,
            description: description,
            model3DName: model3DName,
            type: type,
            materials: materials,
            origin: origin,
            gender: gender,
            weight: weight,
            colors: colors,
            warranty: warranty,
            certifications: certifications,
            isFavorited: false
        )
    }
}
