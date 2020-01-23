//
//  HomeViewModel.swift
//  WeatherAtBose
//
//  Created by Satish Garlapati on 1/22/20.
//  Copyright © 2020 Blackmoon. All rights reserved.
//

import CoreLocation

struct HomeViewModel {
    private let resourceType: WeatherResourceType
    
    init(_ resourceType: WeatherResourceType) {
        self.resourceType = resourceType
    }
    
    func getTodayWeather(completion: @escaping (_ result: TodayWeather?, _ error: CustomError?) -> ()) {
        guard let location = getCurrentLocation() else {
            completion(nil, .message(errorMessage: "No location data found"))
            return
        }
        SessionManager.shared.fetchTodayWeather(forPath: resourceType.getPath(for: location.coordinate)) { (response, error) in
            guard error == nil,
                let responseObj = response else {
                    completion(nil, error != nil ? error : CustomError.invalidData)
                    return
            }
            let todayWeather = TodayWeather(data: responseObj.main, type: responseObj.weather.first?.type)
            completion(todayWeather, nil)
        }
    }
}
