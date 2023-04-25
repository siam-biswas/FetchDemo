//
//  RootCoordinator.swift
//  FecthDemo
//
//  Created by Siam Biswas on 4/24/23.
//

import Foundation
import UIKit

protocol RootCoordinatorProtocol: Coordinator{
    
}

class RootCoordinator: Coordinator, RootCoordinatorProtocol{
    
    init(window:UIWindow?) {
        
        let dependency = RootDependency(api: APIClient.shared)
        let viewModel = RootViewModel(coordinator: self, dependency: dependency)
        let controller = RootController.instantiate(viewModel)
        
        base = .splitViewController(controller)
        navigator = .root(to: base?.splitViewController, from: window, animation: true)
    }
}

