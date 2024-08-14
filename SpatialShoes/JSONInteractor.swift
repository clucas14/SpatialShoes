//
//  JSONInteractor.swift
//  Spatial Shoes
//
//  Created by Carlos Lucas Sánchez on 14/8/24.
//

import Foundation

protocol JSONInteractor {}

extension JSONInteractor {
    func loadJSON<JSON>(url: URL, type: JSON.Type, decoder: JSONDecoder = JSONDecoder()) throws -> JSON where JSON: Codable {
        let data = try Data(contentsOf: url)
        return try decoder.decode(type, from: data)
    }
}
