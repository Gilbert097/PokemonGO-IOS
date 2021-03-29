//
//  ViewController.swift
//  PokemonGO
//
//  Created by Gilberto Silva on 20/03/21.
//

import UIKit
import MapKit

class ViewController: MapLocationViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    private var pokemonRepository: PokemonRepository?
    private var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    private func initialize() {
        mapView.delegate = self
        mapView.showAnnotations(mapView.annotations, animated: true)
        generateRandomPokemons()
        initPokemonRepository()
        findPokemons()
    }
    
    private func findPokemons() {
        if let repository = pokemonRepository {
            pokemons = repository.getAll()
        }
    }
    
    private func initPokemonRepository() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            pokemonRepository = PokemonRepository(viewContext: context)
        }
    }
    
    private func generateRandomPokemons() {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            guard
                let coordinate = self.locationManager.location?.coordinate
            else { return }
            let pokemon = self.getRandomPokemon()
            self.addPokemonPointAnnotation(pokemon, coordinate)
        }
    }
    
    private func getRandomPokemon() -> Pokemon {
        let countPokemons = UInt32(self.pokemons.count)
        let indexPokemon = Int(arc4random_uniform(countPokemons))
        return self.pokemons[indexPokemon]
    }
    
    private func addPokemonPointAnnotation(_ pokemon: Pokemon, _ coordinate: CLLocationCoordinate2D) {
        let annotation = PokemonPointAnnotation(pokemon: pokemon)
        annotation.coordinate = coordinate
        annotation.coordinate.latitude += self.generateRandomNumber()
        annotation.coordinate.longitude += self.generateRandomNumber()
        self.mapView.addAnnotation(annotation)
    }
    
    private func generateRandomNumber() -> Double {
        (Double(arc4random_uniform(100)) - 50) / 10000.0
    }
    
    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
       
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        var frame = annotationView.frame
        frame.size.height = 40
        frame.size.width = 40
        annotationView.image = createImageByAnnotationType(annotation: annotation)
        annotationView.frame = frame
        return annotationView
    }
    
    private func createImageByAnnotationType(annotation: MKAnnotation) -> UIImage? {
        if annotation is MKUserLocation {
            return UIImage(named: "player")
        } else if annotation is PokemonPointAnnotation {
            guard
                let pokemonAnnotation = annotation as? PokemonPointAnnotation
            else {
                return nil
            }
            return UIImage(named: pokemonAnnotation.pokemon.imageName)
        }
        return nil
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        centralizeUserMap()
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func compassButtonClick(_ sender: UIButton) {
        centralizeUserMap()
    }
    
    @IBAction func pokeballButtonClick(_ sender: UIButton) {
    }
    
    private func centralizeUserMap() {
        if let location = locationManager.location {
            applyZoomRegion(coordinate: location.coordinate)
        }
    }
    
    private func applyZoomRegion(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(region, animated: true)
    }
}
