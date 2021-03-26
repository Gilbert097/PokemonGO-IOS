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

