//
//  WeatherResourceType.swift
//  WeatherAtBose
//
//  Created by Satish Garlapati on 1/22/20.
//  Copyright © 2020 Blackmoon. All rights reserved.
//

import CoreLocation

enum WeatherResourceType: CaseIterable {
    case openWeatherAPI, rapidAPI
    
    private var baseUrl: String {
        switch self {
        case .openWeatherAPI: return "http://api.openweathermap.org/data/2.5/weather"
        case .rapidAPI: return "https://weather2020-weather-v1.p.rapidapi.com/"
        }
    }
    
    private var appId: String {
        switch self {
        case .openWeatherAPI: return "1dc3cdbfc5628bf05a3939fffdd7c601"
        case .rapidAPI: return ""
        }
    }
    
    func getPath(for coordinate: CLLocationCoordinate2D) -> String {
        switch self {
        case .openWeatherAPI: return "\(baseUrl)?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=metric&APPID=\(appId)"
        case .rapidAPI: return ""
        }
    }
}
