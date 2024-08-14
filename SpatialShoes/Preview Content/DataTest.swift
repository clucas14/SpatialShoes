//
//  DataTest.swift
//  SpatialShoes
//
//  Created by Carlos Lucas Sánchez on 14/8/24.
//

import Foundation

struct DataTest: DataInteractor {
    var url: URL { Bundle.main.url(forResource: "shoesTest2", withExtension: "json")! }
}

