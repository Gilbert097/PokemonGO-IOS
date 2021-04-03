//
//  PokemonRepository.swift
//  PokemonGO
//
//  Created by Gilberto Silva on 28/03/21.
//

import Foundation
import CoreData
import UIKit

public class PokemonRepository {
    
    private var viewContext: NSManagedObjectContext? = nil
    
    public init() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.viewContext = appDelegate.persistentContainer.viewContext
        }
    }
    
    public func save(pokemon: Pokemon) -> Bool {
        do {
            addPokemonEntity(pokemon)
            
            guard let viewContext = self.viewContext else { return false }
            try viewContext.save()
            print("Pokemon salvo com sucesso!")
            return true
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
    
    private func addPokemonEntity(_ pokemon: Pokemon) {
        guard let viewContext = self.viewContext else { return }
        let pokemonEntity = PokemonEntity(context: viewContext)
        pokemonEntity.id = pokemon.id
        pokemonEntity.name = pokemon.name
        pokemonEntity.captured = pokemon.captured
        pokemonEntity.image_name = pokemon.imageName
    }
    
    public func saveAll(pokemons: [Pokemon]) -> Bool {
        do {
            pokemons.forEach { addPokemonEntity($0)}
            guard let viewContext = self.viewContext else { return false }
            try viewContext.save()
            print("Pokemons salvos com sucesso!")
            return true
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return false
    }
    
    public func getAll() -> [Pokemon] {
        do {
            guard let viewContext = self.viewContext else { return [] }
            let pokemonEntitys = try viewContext.fetch (PokemonEntity.fetchRequest()) as? [PokemonEntity]
            
            guard
                let entitys = pokemonEntitys,
                entitys.count > 0
            else {
                self.populateDatabase()
                return self.getAll()
            }
            
            return entitys.map{
                Pokemon(
                    id: $0.id,
                    name: $0.name ?? "",
                    imageName: $0.image_name ?? "",
                    captured: $0.captured
                )
            }
        }catch {
            print("Error: \(error.localizedDescription)")
        }
        return []
    }
    
    public func getByCaptured(isCaptured: Bool) -> [Pokemon] {
        do {
            let request = PokemonEntity.fetchRequest() as NSFetchRequest<PokemonEntity>
            request.predicate = NSPredicate(format: "captured = %@", argumentArray: [isCaptured])
            
            guard let viewContext = self.viewContext else { return [] }
            let pokemonEntitys = try viewContext.fetch(request)
        
            return pokemonEntitys.map{
                Pokemon(
                    id: $0.id,
                    name: $0.name ?? "",
                    imageName: $0.image_name ?? "",
                    captured: $0.captured
                )
            }
        }catch {
            print("Error: \(error.localizedDescription)")
        }
        return []
    }
    
    private func getEntityById(id: String) -> PokemonEntity? {
        do {
            let request = PokemonEntity.fetchRequest() as NSFetchRequest<PokemonEntity>
            request.predicate = NSPredicate(format: "id = %@", argumentArray: [id])
            
            guard let viewContext = self.viewContext else { return nil }
            let pokemonEntitys = try viewContext.fetch(request)

            return pokemonEntitys.first
        }catch {
            print("Error: \(error.localizedDescription)")
        }
        return nil
    }
    
    public func capture(pokemon: Pokemon) -> Bool {
        
        do {
            guard
                let pokemonEntity = self.getEntityById(id: pokemon.id),
                let viewContext = self.viewContext
            else {
                return false
            }
            pokemonEntity.captured = true
            try viewContext.save()
            return true
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        return false
    }
    
    public func populateDatabase() {
        
        var pokemons:[Pokemon] = []
        pokemons.append(Pokemon(name: "Mew", imageName: "mew", captured: false))
        pokemons.append(Pokemon(name: "Meowth", imageName: "meowth", captured: false))
        pokemons.append(Pokemon(name: "Pikachu", imageName: "pikachu-2", captured: true))
        pokemons.append(Pokemon(name: "Squirtle", imageName: "squirtle", captured: false))
        pokemons.append(Pokemon(name: "Charmander", imageName: "charmander", captured: false))
        pokemons.append(Pokemon(name: "Caterpie", imageName: "caterpie", captured: false))
        pokemons.append(Pokemon(name: "Bullbasaur", imageName: "bullbasaur", captured: false))
        pokemons.append(Pokemon(name: "Bellsprout", imageName: "bellsprout", captured: false))
        pokemons.append(Pokemon(name: "Psyduck", imageName: "psyduck", captured: false))
        pokemons.append(Pokemon(name: "Rattata", imageName: "rattata", captured: false))
        pokemons.append(Pokemon(name: "Snorlax", imageName: "snorlax", captured: false))
        pokemons.append(Pokemon(name: "Zubat", imageName: "zubat", captured: false))
        
        _ = self.saveAll(pokemons: pokemons)
    }
}
