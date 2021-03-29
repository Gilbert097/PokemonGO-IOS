//
//  PokemonAnnotation.swift
//  PokemonGO
//
//  Created by Gilberto Silva on 28/03/21.
//

import UIKit
import MapKit

class PokemonPointAnnotation: MKPointAnnotation {
    public let pokemon: Pokemon
    
    public init(pokemon: Pokemon){
        self.pokemon = pokemon
    }
        
}
