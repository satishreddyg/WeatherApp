//
//  SessionManager.swift
//  WeatherAtBose
//
//  Created by Satish Garlapati on 1/22/20.
//  Copyright © 2020 Blackmoon. All rights reserved.
//

import Foundation

class SessionManager: PMNetworkClient {
    
    static let shared = SessionManager()
    private init() {}
    
    //MARK: API calls
    func fetchTodayWeather(forPath path: String, completion: @escaping (_ result: OpenWeatherTodayResponse?, _ error: CustomError?) -> ()) {
        performRequest(.get, path: path) { [weak self] responseObject in
            self?.responseDataHandler(response: responseObject, completionHandler: { (zoneSearchResult, error) in
                completion(zoneSearchResult, error)
            })
        }
    }
}

extension SessionManager {
    //MARK: Generic method
    
    func responseDataHandler<T: Codable>(response: ResponseObject, completionHandler: @escaping (_ result: T?, _ error: CustomError?) -> ()) {
        DispatchQueue.main.async {
            guard response.error == nil else {
                completionHandler(nil, response.error as? CustomError)
                return
            }
            do {
                guard let _data = response.data else {
                    completionHandler(nil, CustomError.invalidData)
                    return
                }
                let result = try JSONDecoder().decode(T.self, from: _data)
                completionHandler(result, nil)
            } catch let error {
                print("error at parsing is: \(error)")
                completionHandler(nil, error as? CustomError)
            }
        }
    }
}
