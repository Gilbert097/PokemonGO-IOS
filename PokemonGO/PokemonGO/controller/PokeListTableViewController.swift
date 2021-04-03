//
//  PokeListTableViewController.swift
//  PokemonGO
//
//  Created by Gilberto Silva on 28/03/21.
//

import UIKit

class PokeListTableViewController: UIViewController {
    
    private let pokemonRepository = PokemonRepository()
    private var pokemonsCaptured: [Pokemon] = []
    private var pokemonsNotCaptured: [Pokemon] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pokemonsCaptured = pokemonRepository.getByCaptured(isCaptured: true)
        print("pokemonsCaptured \(pokemonsCaptured.count)")
        self.pokemonsNotCaptured = pokemonRepository.getByCaptured(isCaptured: false)
        print("pokemonsNotCaptured \(pokemonsNotCaptured.count)")
    }

    @IBAction func mapButtonClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
