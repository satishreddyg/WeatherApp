//
//  AppDelegate.swift
//  WeatherAtBose
//
//  Created by Satish Garlapati on 1/22/20.
//  Copyright © 2020 Blackmoon. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setRootViewController()
        return true
    }
    
    private func setRootViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = PermissionViewController()
        window?.makeKeyAndVisible()
    }
    
    private var rootViewController: UIViewController {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            return UINavigationController(rootViewController: HomeViewController())
        default:
            return PermissionViewController()
        }
    }
}

