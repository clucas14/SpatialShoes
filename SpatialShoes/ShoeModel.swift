//
//  ShoeModel.swift
//  Spatial Shoes
//
//  Created by Carlos Lucas Sánchez on 14/8/24.
//

import Foundation

struct ShoeModel: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let brand: String
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
