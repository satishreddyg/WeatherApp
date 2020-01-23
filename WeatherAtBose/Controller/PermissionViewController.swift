//
//  PermissionViewController.swift
//  WeatherAtBose
//
//  Created by Satish Garlapati on 1/22/20.
//  Copyright © 2020 Blackmoon. All rights reserved.
//

import UIKit
import CoreLocation

class PermissionViewController: UIViewController {

    private var coordinator: PermissionCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        startCoordinating()
    }
    
    private func startCoordinating() {
        coordinator = PermissionCoordinator(self)
        coordinator.start()
    }
}
