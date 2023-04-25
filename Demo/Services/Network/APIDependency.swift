//
//  APIDependency.swift
//  FecthDemo
//
//  Created by Siam Biswas on 4/24/23.
//

import Foundation

public typealias Parameters = [String : Any]

public protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

public enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case accessToken = "accesstoken"
    case userAgent = "User-Agent"
    case acceptLanguage = "Accept-Language"
}

enum ContentType: String {
    case json = "application/json"
    case multipartFormData = "multipart/form-data"
}
