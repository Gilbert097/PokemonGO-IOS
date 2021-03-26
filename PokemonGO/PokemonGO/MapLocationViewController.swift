//
//  LocationManagerDelegate.swift
//  PokemonGO
//
//  Created by Gilberto Silva on 25/03/21.
//

import UIKit
import MapKit

class MapLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    open var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManager()
    }
    
    private func initLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        let status = manager.authorizationStatus
        print("Status: \(status.rawValue)")
        
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else if status == .denied {
            showAlertRequestPermissionLocation()
        }
    }
    
    private func showAlertRequestPermissionLocation() {
        let alertController = UIAlertController(title: "Permissão de localização",
                                                message: "Necessário permissão para à sua localização!",
                                                preferredStyle: .actionSheet)
        addAlertActions(alertController)
        present(alertController, animated: true, completion: nil)
    }
    
    private func addAlertActions(_ alertController: UIAlertController) {
        let configurationAction = UIAlertAction(title: "Abrir configurações",
                                                style: .default) { (action) in
            
            if let bundleId = Bundle.main.bundleIdentifier,
               let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)"),
               UIApplication.shared.canOpenURL(url)
            {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        
        alertController.addAction(configurationAction)
        alertController.addAction(cancelAction)
    }
}
