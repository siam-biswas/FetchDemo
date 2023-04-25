//
//  RootViewModel.swift
//  FecthDemo
//
//  Created by Siam Biswas on 4/24/23.
//

import Foundation

protocol RootViewModelProtocol: ViewModel<RootCoordinatorProtocol,RootDependencyProtocol,RootAction,RootState> {
    func fetchData()
}

class RootViewModel: ViewModel<RootCoordinatorProtocol,RootDependencyProtocol,RootAction,RootState>, RootViewModelProtocol {
    
    func fetchData(){
        
        self.state.value = .loading
        dependency.fetchData { [weak self] result in
            switch result{
            case let .success(data):
                self?.state.value = data.meals.count > 0 ? .populated(data.meals) : .empty
            case let .failure(error):
                self?.state.value = .error(error.description)
            }
        }
    }
    
    override func initialize() {
        super.initialize()
    }
    
    override func setupReactive() {
        super.setupReactive()
    }
    
}
