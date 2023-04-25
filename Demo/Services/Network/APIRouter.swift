//
//  NetworkRouter.swift
//  FecthDemo
//
//  Created by Siam Biswas on 4/24/23.
//

import Foundation

enum APIRouter : APIRouterProtocol {

    case getData
    case getDetails(String)

    internal var method: HTTPMethod {
        switch self {
        case .getData,.getDetails:
            return .get
        }
    }
    
    internal var basePath: String {
        switch self {
        case .getData,.getDetails:
            return "https://themealdb.com/"
        }
    }
    
    internal var commonPath: String {
        switch self {
        case .getData,.getDetails:
            return "api/json/v1/1/"
        }
    }

    
    internal var path: String {
        switch self {
        case .getData:
            return "filter.php"
        case .getDetails:
            return "lookup.php"
        }
    }

    
    internal var parameters: Parameters? {
        switch self {
        case .getData: return ["c" : "Dessert"]
        case let .getDetails(id): return ["i" : id]
        }
    }

    
    internal var bodyData: Data? {
        switch self {
        default:
            return nil
        }
    }

    
    internal var contentType: String? {
        switch self {
        default:
            return ContentType.json.rawValue
        }
    }
}


protocol APIRouterProtocol: URLRequestConvertible{
    // MARK: - HTTPMethod
    var method: HTTPMethod { get }
    // MARK: - Base Path
    var basePath: String { get }
    // MARK: - Common Path
    var commonPath: String { get }
    // MARK: - Path
    var path: String { get }
    // MARK: - Parameters
    var parameters: Parameters? { get }
    // MARK: - bodyData
    var bodyData: Data? { get }
    // MARK: ContentType
    var contentType: String? { get }
}


extension APIRouterProtocol  {
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        

        var urlComponents = URLComponents(string: basePath + commonPath + path)!

        var httpBody: Data?
        if let parameters = parameters {
            do {
                if method == .get {
                    if let items = paramsToQueryItems(parameters) {
                        urlComponents.queryItems = items
                    }
                } else {
                    httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                }
            } catch {
                throw error
            }
        } else if let bodyData = bodyData {
            httpBody = bodyData
        }

        //var urlRequest = URLRequest(url: urlComponents.url!)
        var urlRequest = URLRequest(url: urlComponents.url!,
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: TimeInterval(30))
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = httpBody
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        
        if let contentType = contentType {
            urlRequest.setValue(contentType, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        }
        

        return urlRequest
    }
}

// MARK: - Helpers
extension APIRouterProtocol {

    /// Encode complex key/value objects in URLQueryItem pairs
    private func queryItems(_ key: String, _ value: Any?) -> [URLQueryItem] {
        var result = [] as [URLQueryItem]
        
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                result += queryItems("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            let arrKey = key
            for value in array {
                result += queryItems(arrKey, value)
            }
        } else if let value = value {
            result.append(URLQueryItem(name: key, value: "\(value)"))
        } else {
            result.append(URLQueryItem(name: key, value: nil))
        }
        return result
    }

    /// Encodes complex [String: AnyObject] params into array of URLQueryItem
    private func paramsToQueryItems(_ params: [String: Any]?) -> [URLQueryItem]? {
        guard let params = params else { return nil }
        var result = [] as [URLQueryItem]
        for (key, value) in params  {
            result += queryItems(key, value)
        }
        return result
    }
}



