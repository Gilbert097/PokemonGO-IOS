//
//  Pokemon.swift
//  PokemonGO
//
//  Created by Gilberto Silva on 28/03/21.
//

import Foundation

public struct Pokemon {
    let id: String
    let name: String
    let imageName: String
    let capturedQuantity: Int64
    
    public init(
        id: String? = nil,
        name: String,
        imageName: String,
        capturedQuantity: Int64
    ) {
        self.id = id ?? UUID().uuidString
        self.name = name
        self.imageName = imageName
        self.capturedQuantity = capturedQuantity
    }
}
