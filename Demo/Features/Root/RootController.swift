//
//  RootController.swift
//  FecthDemo
//
//  Created by Siam Biswas on 4/24/23.
//

import Foundation
import UIKit

protocol RootControllerProtocol: SplitViewController<RootViewModelProtocol> {
    var list:ListCoordinator { get set }
    var detail:DetailCoordinator { get set }
}

class RootController: SplitViewController<RootViewModelProtocol>, RootControllerProtocol, UISplitViewControllerDelegate {
    
    lazy var list = ListCoordinator(from: self)
    lazy var detail = DetailCoordinator(from: self, object: nil)
    

    override func setupController() {
        super.setupController()
        
        
        self.preferredDisplayMode = .oneBesideSecondary
        self.delegate = self
        self.viewControllers = []
        
        list.start()
        detail.start()
       
        
        self.viewModel.fetchData()
        
        
    }
    
   
    override func setupReactive() {
        super.setupReactive()
        
        self.viewModel.state.observe(DispatchQueue.main) { [weak self] value in
            switch value{
            case .empty:
                
                guard let controller = self?.list.base?.viewController as? ListController else { return }
                controller.viewModel.state.value = .empty
                
            case let .populated(data):
                
                guard let controller = self?.list.base?.viewController as? ListController else { return }
                let newdata = data.compactMap{$0.toList()}
                controller.viewModel.tempState = .populated(newdata)
                controller.viewModel.state.value = .populated(newdata)
                
                guard let detail = self?.detail.base?.viewController as? DetailController, let data = data.first?.toList().toDetail() else { return }
                detail.viewModel.state.value = .populated(data)
                detail.viewModel.fetchData()
                
            case .loading:
                break
            case let .error(message):
               
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }.add(to: &disposal)
    }
    
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
}

