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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateRandomPokemons()
    }
    
    private func generateRandomPokemons() {
       Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            guard let location = self.locationManager.location else { return }
            let annotation = MKPointAnnotation()
            annotation.coordinate =  location.coordinate
            annotation.coordinate.latitude += self.generateRandomNumber()
            annotation.coordinate.longitude += self.generateRandomNumber()
            self.mapView.addAnnotation(annotation)
        }
    }
    
    private func generateRandomNumber() -> Double {
        (Double(arc4random_uniform(500)) - 250) / 10000.0
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

