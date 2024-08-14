//
//  DataInteractor.swift
//  Spatial Shoes
//
//  Created by Carlos Lucas Sánchez on 14/8/24.
//

import Foundation

protocol DataInteractor: JSONInteractor {
    var url: URL { get }
    func getData() throws -> [ShoeModel]
}

extension DataInteractor {
    var url: URL { Bundle.main.url(forResource: "shoes", withExtension: "json")! }
    
    func getData() throws -> [ShoeModel] {
        try loadJSON(url: url, type: [ShoeModel].self)
    }
}

struct Interactor: DataInteractor {}
