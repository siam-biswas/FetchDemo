//
//  DetailViewModel.swift
//  FecthDemo
//
//  Created by Siam Biswas on 4/24/23.
//

import Foundation

protocol DetailViewModelProtocol: ViewModel<DetailCoordinatorProtocol,DetailDependencyProtocol,DetailAction,DetailState> {
    func fetchData()
}

class DetailViewModel: ViewModel<DetailCoordinatorProtocol,DetailDependencyProtocol,DetailAction,DetailState>, DetailViewModelProtocol {
    
    override func initialize() {
        super.initialize()
    }
    
    override func setupReactive() {
        super.setupReactive()
    }
    
    func fetchData(){
        guard let data = self.state.value?.data else { return }
        
        self.state.value = .loading
        
        dependency.fetchData(id: data.id) { [weak self] result in
            switch result{
            case let .success(data):
                guard let data = data.meals.first else { return }
                self?.state.value = .populated(data)
            case let .failure(error):
                self?.state.value = .error(error.description)
            }
        }
    }
}
