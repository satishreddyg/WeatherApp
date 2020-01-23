//
//  OpenWeatherTodayResponse.swift
//  WeatherAtBose
//
//  Created by Satish Garlapati on 1/22/20.
//  Copyright © 2020 Blackmoon. All rights reserved.
//

import Foundation

struct OpenWeatherTodayResponse: Codable {
    let coordinates: GeoJson
    let main: Main
    let weather: [WeatherInfo]
    let cityName: String
    let sunInfo: SunInfo
    let wind: Wind
    enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case main, weather, wind
        case cityName = "name"
        case sunInfo = "sys"
    }
}

struct GeoJson: Codable {
    let lat, lon: Double
}

struct WeatherInfo: Codable {
    let type: String
    enum CodingKeys: String, CodingKey {
        case type = "description"
    }
}

struct Main: Codable {
    let temp, feels_like, temp_min, temp_max, humidity: Double
}

struct Wind: Codable {
    let speed: Double
}

struct SunInfo: Codable {
    let sunrise, sunset: Double
}
