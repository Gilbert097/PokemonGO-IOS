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
        mapView.delegate = self
        mapView.showAnnotations(mapView.annotations, animated: true)
        generateRandomPokemons()
    }
    
    private func generateRandomPokemons() {
       Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            guard let coordinate = self.locationManager.location?.coordinate else { return }
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
        annotation.coordinate.latitude += self.generateRandomNumber()
            annotation.coordinate.longitude += self.generateRandomNumber()
            self.mapView.addAnnotation(annotation)
        }
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
        if annotation is MKUserLocation {
            annotationView.image = UIImage(named: "player")
        } else {
            annotationView.image = UIImage(named: "pikachu-2")
        }
        annotationView.frame = frame
        return annotationView
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

