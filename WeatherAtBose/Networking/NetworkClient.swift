//
//  NetworkClient.swift
//  WeatherAtBose
//
//  Created by Satish Garlapati on 1/22/20.
//  Copyright © 2020 Blackmoon. All rights reserved.
//

import Foundation

enum CustomError: Error {
    case invalidURL(url: String), invalidJson, invalidData, message(errorMessage: String), jsonEncodingFailed(error: Error)
    
    var message: String {
        switch self {
        case .message(let errorMessage):
            return errorMessage
        default:
            return LocalizedString(.requestFailureMessage)
        }
    }
}

public typealias Parameters = [String: Any]
public typealias HTTPHeaders = [String: String]

enum RequestMethod: String {
    case get, post, delete, put
}

class PMNetworkClient: NSObject {
    
    private let timeout: TimeInterval
    typealias ResponseHandler = (ResponseObject) -> Void
    typealias ResponseObject = (httpUrlResponse: HTTPURLResponse?, data: Data?, error: Error?)
    
    //MARK- Initializers
    init(timeout: TimeInterval = 10.0) {
        self.timeout = timeout
        super.init()
    }
    
    /**
     Global method to perform all request types and chains the response depending on type
     */
    func performRequest(_ requestMethod: RequestMethod,
                        path: String,
                        parameters: Parameters? = nil,
                        headers: [String:String] = [:],
                        responseHandler: @escaping ResponseHandler) {
        //-- BUILD REQUEST
        let request = buildRequest(path, requestMethod: requestMethod, parameters: parameters, headers: headers)
        switch request {
        case .success(let urlRequest):
            URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
                responseHandler((urlResponse as? HTTPURLResponse, data, error))
                }.resume()
        case .failure(let error):
            responseHandler((nil, nil, error))
        }
    }
    
    /**
     builds URLRequest with encoding parameters, if required
     - argument requestMethod: required httpMethod
     - argument OPTIONAL parameters: parameters needed for POST call
     - argument headers: passed on extra httpHeaders
     - returns: Result type of URLRequest and Error.
     */
    @discardableResult
    open func buildRequest(_ urlString: URLConvertible,
                           requestMethod: RequestMethod,
                           parameters: Parameters? = nil,
                           headers: HTTPHeaders = [:]) -> Result<URLRequest, Error> {
        do {
            var request = try URLRequest(url: urlString.asURL(), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeout)
            request.httpMethod = requestMethod.rawValue.uppercased()
            request.httpShouldHandleCookies = false
            request.allHTTPHeaderFields = getHeaders(headers)
            let encodedURLRequest = try request.encodeUrlRequest(with: parameters)
            return .success(encodedURLRequest)
        } catch let error {
            return .failure(error)
        }
    }
    
    /**
     Constructs headers, if passed any. If not, return common headers
     */
    private func getHeaders(_ headers: [String:String]) -> HTTPHeaders {
        var authenticationHeaders = [String: String]()
        for header in headers {
            authenticationHeaders[header.key] = header.value
        }
        return authenticationHeaders
    }
}

protocol URLConvertible {
    /**
     Returns a URL that conforms to RFC 2396 or throws an `Error`.
     - throws: An `Error` if the type cannot be converted to a `URL`.
     - returns: A URL or throws an `Error`.
     */
    func asURL() throws -> URL
}

extension String: URLConvertible {
    public func asURL() throws -> URL {
        guard let url = URL(string: self) else { throw CustomError.invalidURL(url: self) }
        return url
    }
}

protocol ParameterEncoding {
    /**
     Creates a URL request by encoding parameters and applying them onto an existing request.
     - parameter urlRequest: The request to have parameters applied.
     - parameter parameters: The parameters to apply.
     - throws: An `CustomError.parameterEncodingFailed` error if encoding fails.
     - returns: The encoded request.
     */
    mutating func encodeUrlRequest(with parameters: Parameters?) throws -> URLRequest
}

extension URLRequest: ParameterEncoding {
    public mutating func encodeUrlRequest(with parameters: Parameters?) throws -> URLRequest {
        guard let parameters = parameters else { return self }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            
            if self.value(forHTTPHeaderField: "Content-Type") == nil {
                self.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            self.httpBody = data
        } catch {
            throw CustomError.jsonEncodingFailed(error: error)
        }
        
        return self
    }
}
