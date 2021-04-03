//
//  PokeListTableViewController.swift
//  PokemonGO
//
//  Created by Gilberto Silva on 28/03/21.
//

import UIKit

class PokeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    func numberOfSections(in tableView: UITableView) -> Int { 2 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return pokemonsCaptured.count
        }else {
            return pokemonsNotCaptured.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Capturados"
        } else {
            return "Não Capturados"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "pokemonCell")
        let pokemon = getCurrentPokemonBySection(indexPath: indexPath)
        cell.imageView?.image = UIImage(named: pokemon.imageName)
        cell.textLabel?.text = pokemon.name
        return cell
    }
    
    private func getCurrentPokemonBySection(indexPath: IndexPath) -> Pokemon {
        if indexPath.section == 0 {
            return pokemonsCaptured[indexPath.row]
        } else {
            return pokemonsNotCaptured[indexPath.row]
        }
    }
    
    @IBAction func mapButtonClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
