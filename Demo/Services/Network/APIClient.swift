//
//  NetworkService.swift
//  FecthDemo
//
//  Created by Siam Biswas on 4/24/23.
//

import Foundation

class APIClient  {
    
    //MARK:- Shared Instance
    static var shared = APIClient()
    
    //MARK:- Request Task


    
    @discardableResult
    func performRequest<T:Decodable>(route: APIRouterProtocol, decoder: JSONDecoder = JSONDecoder(),
                                                    completion:@escaping (Result<T, APIError>) -> Void) -> URLSessionDataTask? {
        return request(route) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    completion(.failure(.uncharted(description:"No data")))
                    return
                }
                do {
                    let decodedResponse = try decoder.decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(.decodingFailed(error: error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    private func request(_ urlRequest: URLRequestConvertible, completion:@escaping (Result<Data?, APIError>) -> Void)
        -> URLSessionDataTask? {
        do {
            let request = try urlRequest.asURLRequest()
            let dataRequest: URLSessionDataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(.uncharted(description:"server error")))
                    return
                }
                guard 200...299 ~= response.statusCode else {
                    completion(.failure(.networkError(code: response.statusCode)))
                    return
                }
                if let error = error {
                    completion(.failure(.uncharted(description: error.localizedDescription)))
                    return
                }
                
                completion(.success(data))
            }
            
            dataRequest.resume()
            return dataRequest
            
        } catch {
            let encodingError = APIError.encodingFailed(error: error)
            completion(.failure(encodingError))
        }
        
        return nil
    }
    

}



