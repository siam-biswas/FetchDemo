//
//  ListViewModel.swift
//  FecthDemo
//
//  Created by Siam Biswas on 4/24/23.
//

import Foundation

protocol ListViewModelProtocol: ViewModel<ListCoordinatorProtocol,ListDependencyProtocol,ListAction,ListState> {
    
    var tempState:ListState? { get set}
    
    func filterData(_ keyword: String?)
    
}

class ListViewModel: ViewModel<ListCoordinatorProtocol,ListDependencyProtocol,ListAction,ListState>, ListViewModelProtocol {
    
    var tempState:ListState?
    
    
    override func initialize() {
        super.initialize()
    }
    
    override func setupReactive() {
        super.setupReactive()
    }
    
    func filterData(_ keyword: String?){
        
        guard let data = self.tempState?.data else { return }
        
        guard let keyword = keyword, !keyword.isEmpty else {
            self.state.value = tempState
            return
        }
        
        let newData = data.filter{$0.title.contains(keyword)}
        self.state.value = .populated(newData)
    }
    
}
