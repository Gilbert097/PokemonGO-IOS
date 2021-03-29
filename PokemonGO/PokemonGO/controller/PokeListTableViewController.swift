//
//  PokeListTableViewController.swift
//  PokemonGO
//
//  Created by Gilberto Silva on 28/03/21.
//

import UIKit

class PokeListTableViewController: UIViewController {
    
    public var pokemons: [Pokemon] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func mapButtonClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
