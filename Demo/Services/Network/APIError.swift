//
//  APIError.swift
//  FecthDemo
//
//  Created by Siam Biswas on 4/24/23.
//

import Foundation



public enum APIError: Error {
    
    case networkError(code: Int)
    case encodingFailed(error: Error)
    case decodingFailed(error: Error)
    case uncharted(description: String)
    case unknown
    
    public var description: String {
        switch self {
        case .networkError(let code):
            return "Network error with code \(code)"
        case .encodingFailed(let error):
            return error.localizedDescription
        case .decodingFailed(let error):
            return error.localizedDescription
        case .uncharted(let description):
            return description
        default:
            return "Error"
        }
    }
}
