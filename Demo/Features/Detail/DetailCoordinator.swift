//
//  DetailCoordinator.swift
//  FecthDemo
//
//  Created by Siam Biswas on 4/24/23.
//

import Foundation
import UIKit


protocol DetailCoordinatorProtocol: Coordinator{
    
}

class DetailCoordinator: Coordinator, DetailCoordinatorProtocol{
    
    init(from:UISplitViewController?,object:DetailModel?) {
        
        let dependency = DetailDependency(api: APIClient.shared)
        let viewModel = DetailViewModel(coordinator: self, dependency: dependency)
        if let object = object{
            viewModel.state.value = DetailState.populated(object)
        }
        let controller = DetailController.instantiate(viewModel)
        
        
        
        base = .viewController(controller)
        navigator = .split(to: base?.viewController, from: from, detail: object == nil ? false : true)
    }
}

