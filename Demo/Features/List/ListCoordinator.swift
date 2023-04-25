//
//  ListCoordinator.swift
//  FecthDemo
//
//  Created by Siam Biswas on 4/24/23.
//

import Foundation
import UIKit

protocol ListCoordinatorProtocol: Coordinator{
    
}

class ListCoordinator: Coordinator, ListCoordinatorProtocol{
    
    init(from:UISplitViewController?) {
        
        let dependency = ListDependency(data: Transfigurable())
        let viewModel = ListViewModel(coordinator: self, dependency: dependency)
        let controller = ListController.instantiate(viewModel)
        
        base = .navigationController(BaseNavigationController(rootViewController: controller))
        navigator = .split(to: base?.navigationController, from: from, detail: false)
    }
    
}

