//
//  ListController.swift
//  FecthDemo
//
//  Created by Siam Biswas on 4/24/23.
//

import Foundation
import UIKit

protocol ListControllerProtocol: TableViewController<ListViewModelProtocol>  {
    
}

class ListController: TableViewController<ListViewModelProtocol>, ListControllerProtocol, UISearchResultsUpdating {
    
    
    
    private var searchController:UISearchController?
    
    override func setupController() {
        super.setupController()
        self.title = "Deserts"
        
        self.definesPresentationContext = true
        searchController = UISearchController(searchResultsController: nil)
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.sizeToFit()
        
        self.tableView.tableHeaderView = searchController?.searchBar

        self.tableView.bind(viewModel.dependency.data).view { container, indexPath, data in
            let cell:TableViewCell<ListModel> = container.dequeue()
            cell.viewModel = data[indexPath.row]
            cell.textLabel?.text = data[indexPath.row].title
            return cell
        }.selection { [weak self] container, indexPath, data in
            self?.viewModel.coordinator.next(coordinator: DetailCoordinator(from: self?.splitViewController, object: data[indexPath.row].toDetail()), completion: nil)
        }
    }
    
   
    override func setupReactive() {
        super.setupReactive()
        
        self.viewModel.state.observe(DispatchQueue.main) { value in
            switch value{
            case .empty:
                self.viewModel.dependency.data.clear()
            case let .populated(data):
                self.viewModel.dependency.setData(data: data)
            case .loading:
                break
            case .error(_):
                break
            }
        }.add(to: &disposal)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterData(searchController.searchBar.text)
    }
}


