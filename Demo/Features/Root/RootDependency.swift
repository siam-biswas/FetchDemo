//
//  RootDependency.swift
//  FecthDemo
//
//  Created by Siam Biswas on 4/24/23.
//

import Foundation

protocol RootDependencyProtocol{
    var api:APIClient { get }
    
    func fetchData(completion:@escaping ((Result<RootModel,APIError>) -> Void))
}

struct RootDependency: RootDependencyProtocol {
    
    var api: APIClient
    
    func fetchData(completion:@escaping ((Result<RootModel,APIError>) -> Void)) {
       api.performRequest(route: APIRouter.getData, completion: completion)
    }
    
}
