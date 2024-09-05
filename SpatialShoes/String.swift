//
//  Extensions.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 5/9/24.
//

import Foundation

extension String {
    func formattedBrand() -> String {
        // Agrega un espacio antes de cada letra mayúscula (excepto la primera)
        self.replacingOccurrences(of: "([A-Z])", with: " $1", options: .regularExpression, range: self.index(after: self.startIndex)..<self.endIndex).trimmingCharacters(in: .whitespaces)
    }
}
