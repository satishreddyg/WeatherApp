//
//  PermissionCoordinator.swift
//  WeatherAtBose
//
//  Created by Satish Garlapati on 1/22/20.
//  Copyright © 2020 Blackmoon. All rights reserved.
//

import UIKit
import CoreLocation

protocol Coordinator {
    func start()
}

class PermissionCoordinator: NSObject, Coordinator {
    private let locationManager = CLLocationManager()
    let controller: UIViewController
    init(_ controller: UIViewController) {
        self.controller = controller
    }
    
    func start() {
        checkLocationPermission()
    }
    
    private func checkLocationPermission() {
        locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            let alert = UIAlertController(title: "Location Services disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
                guard let url = URL(string: UIApplication.openSettingsURLString),
                    UIApplication.shared.canOpenURL(url) else { return }
                UIApplication.shared.open(url)
            }
            alert.addAction(cancelAction)
            alert.addAction(settingsAction)
            controller.present(alert, animated: true, completion: nil)
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
            let nav = UINavigationController(rootViewController: HomeViewController())
            nav.modalPresentationStyle = .fullScreen
            controller.present(nav, animated: true)
        @unknown default: break
        }
    }
}

extension PermissionCoordinator: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationPermission()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        storeLocation(currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
    }
}

