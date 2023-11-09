//
//  GPError.swift
//  GlobalPaymentsCodingChallenge
//
//  Created by Kevin Vu on 11/9/23.
//

import Foundation

/**
 If user facing error messages are desired, we can add our own implementation for the custom description
 variable present with `Error`. We can also add associated values to these enum cases and
 pull those into the custom description for the error.
 */
enum GPError: Error {
    /// Error for an invalid request being built and sent through the `URLSession`.
    case invalidRequest
    
    /// Error for an invalid response from the server, resulting in a nil `HTTPURLResponse`.
    case invalidResponse
    
    /// Error for invalid data from the server.
    case invalidData
    
    /// Error for invalid decoding of the server data.
    case invalidDecoding
    
    /// Error for typical internet connection issues which render the request incomplete.
    /// Return this if an error is received in `URLSession.dataTask`
    case unableToComplete
    
    var customDescription: String {
        switch self {
            case .invalidRequest:
                "Invalid request"
            case .invalidResponse:
                "Invalid response"
            case .invalidData:
                "Invalid data"
            case .invalidDecoding:
                "Invalid decoding"
            case .unableToComplete:
                "Unable to complete"
        }
    }
}
