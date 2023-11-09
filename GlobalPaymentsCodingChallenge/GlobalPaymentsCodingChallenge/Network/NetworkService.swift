//
//  NetworkService.swift
//  GlobalPaymentsCodingChallenge
//
//  Created by Kevin Vu on 11/9/23.
//

import Foundation

protocol NetworkService {
    // do not allow consumers to set the session aside from where we initialize
    // the service
    var session: URLSession { get }
    
    func request<T: Decodable>(type: T.Type, router: Router) async throws -> T
}

/**
 Instead of having separate protocols and network adapters that we provide for each use case,
 we have this generic request method in which we pass a specific router that is associated with
 each use case. We of course do still want to have the parent service protocol to allow us to swap out
 the specific implementation (i.e. in the event we would like to switch to GraphQL or some other
 networking format).
 */
final class RestNetworkServiceAdapter: NetworkService {
    var session: URLSession
    
    // Singleton
    static let instance = RestNetworkServiceAdapter(configuration: .default)
    
    private init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    func request<T: Decodable>(type: T.Type, router: Router) async throws -> T {
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.queryItems = router.parameters
        
        guard let url = components.url else {
            throw GPError.invalidRequest
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw GPError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(type, from: data)
        } catch {
            throw GPError.invalidDecoding
        }
    }
    
}

enum Router {
    // MARK: -- Specific endpoints
    case getLaunchesList
    case getLaunchDetails(String)
    
    // MARK: -- URL Components
    var scheme: String {
        switch self {
            default: "https"
        }
    }
    
    var host: String {
        switch self {
            default: "api.spacexdata.com"
        }
    }
    
    var path: String {
        let basePath = "/v3/launches"
        switch self {
            case .getLaunchesList:
                return basePath
            case .getLaunchDetails(let launchId):
                return "\(basePath)/\(launchId)"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
            default:
                // api doesn't seem to require standard query parameters,
                // just passed as a further path
                return []
        }
    }
    
    var method: String {
        switch self {
            case .getLaunchesList, .getLaunchDetails(_):
                return "GET"
        }
    }
}
