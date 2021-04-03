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
    private let pokemonRepository: PokemonRepository = PokemonRepository()
    private var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    private func initialize() {
        mapView.delegate = self
        mapView.showAnnotations(mapView.annotations, animated: true)
        generateRandomPokemonPointAnnotations()
        findPokemons()
    }
    
    private func findPokemons() {
        pokemons = pokemonRepository.getAll()
    }
    
    private func generateRandomPokemonPointAnnotations() {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] (timer) in
            guard
                let self = self,
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
    
    func mapView(
        _ mapView: MKMapView,
        didSelect view: MKAnnotationView
    ) {
        guard
            let annotation = view.annotation,
            let pokemonPointAnnotation = annotation as? PokemonPointAnnotation
        else { return }
        
        mapView.deselectAnnotation(annotation, animated: true)
        applyZoomRegion(coordinate: annotation.coordinate)
        executeScheduledPokemonCapture(pokemonPointAnnotation: pokemonPointAnnotation)
    }
    
    private func executeScheduledPokemonCapture(pokemonPointAnnotation: PokemonPointAnnotation) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] (timer) in
            guard
                let self = self,
                let coordinateUser = self.locationManager.location?.coordinate
            else { return }
            
            let inside = self.isUserCloseToPokemon(coordinateUser: coordinateUser)
            if inside {
                let pokemon = pokemonPointAnnotation.pokemon
                let isSuccess = self.pokemonRepository.capture(pokemon: pokemon)
                
                if isSuccess {
                    self.mapView.removeAnnotation(pokemonPointAnnotation)
                }
                
                self.showMessageCapturePokemonByStatus(
                    isSuccess: isSuccess,
                    pokemon: pokemon
                )
            } else {
                self.showSimpleMessage(
                    title: "Pokemon Longe",
                    message: "Ops, você não pode capturar este pokemon"
                )
            }
        }
    }
    
    private func showMessageCapturePokemonByStatus(
        isSuccess: Bool,
        pokemon: Pokemon
    ) {
        if isSuccess {
            self.showSimpleMessage(
                title:"Parabéns!",
                message: "Você capturou um \(pokemon.name)"
            )
        } else {
            self.showSimpleMessage(
                title:"Error",
                message: "Ocorreu um erro ao capturar o pokemon, tente novamente!"
            )
        }
    }
    
    private func isUserCloseToPokemon(coordinateUser: CLLocationCoordinate2D) -> Bool {
        let userPoint: MKMapPoint = MKMapPoint(coordinateUser);
        let mapRect: MKMapRect = mapView.visibleMapRect;
        return mapRect.contains(userPoint);
    }
    
    private func showSimpleMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(actionOK)
        present(alertController, animated: true, completion: nil)
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

