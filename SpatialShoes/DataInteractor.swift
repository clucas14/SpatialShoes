//
//  DataInteractor.swift
//  Spatial Shoes
//
//  Created by Carlos Lucas Sánchez on 14/8/24.
//

import Foundation

protocol DataInteractor: JSONInteractor {
    var url: URL { get }
    var docURL: URL { get }
}

extension DataInteractor {
    var url: URL { Bundle.main.url(forResource: "shoes", withExtension: "json")! }
    var docURL: URL { URL.documentsDirectory.appending(path: "shoesCollection.json")}
    
    func getShoes() throws -> [ShoeModel] {
        if !FileManager.default.fileExists(atPath: docURL.path()) {
            let shoes = try loadJSON(url: url, type: [ShoeModelDTO].self).map(\.toPresentation)
            try saveJSON(url: docURL, json: shoes)
            return shoes
        } else {
           return try loadJSON(url: docURL, type: [ShoeModel].self)
        }
    }
    
    func saveShoes(json: [ShoeModel]) throws {
        try saveJSON(url: docURL, json: json)
    }
}

struct Interactor: DataInteractor {}
