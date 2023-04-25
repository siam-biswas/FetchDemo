//
//  DetailDependency.swift
//  FecthDemo
//
//  Created by Siam Biswas on 4/24/23.
//

import Foundation


protocol DetailDependencyProtocol{
    var api:APIClient { get }
    
    func fetchData(id:String,completion:@escaping ((Result<DetailResponse,APIError>) -> Void))
    
}

struct DetailDependency: DetailDependencyProtocol {
    var api: APIClient
    
    func fetchData(id:String, completion:@escaping ((Result<DetailResponse,APIError>) -> Void)) {
       api.performRequest(route: APIRouter.getDetails(id), completion: completion)
    }
}
