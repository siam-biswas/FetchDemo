//
//  DetailController.swift
//  FecthDemo
//
//  Created by Siam Biswas on 4/24/23.
//

import Foundation
import UIKit


protocol DetailControllerProtocol: ViewController<DetailViewModelProtocol> {
    
}

class DetailController: ViewController<DetailViewModelProtocol>, DetailControllerProtocol {
    
    lazy var scrollView = with(BaseScrollView()){
        $0.setLayout(.autoLayout)
        $0.backgroundColor = .white
    }
    
    lazy var imageView = with(BaseImageView()){
        $0.setLayout(.autoLayout)
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .white
    }
    
    lazy var textLabel = with(BaseLabel()){
        $0.setLayout(.autoLayout)
        $0.type = .multiline(0)
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    
    override func setupController() {
        super.setupController()
        
        self.viewModel.fetchData()
    }
    
    override func setupView() {
        super.setupView()
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(textLabel)
    }
       
    override func setupLayout() {
        super.setupLayout()
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    }
    
    override func setupViewModel() {
        super.setupViewModel()
        self.setupData(data: viewModel.state.value?.data)
    }
   
    override func setupReactive() {
        super.setupReactive()
        
        viewModel.state.observe { [weak self] value in
            switch value{
            case let .populated(data):
                DispatchQueue.main.async {
                    self?.setupData(data: data)
                }
            case .empty:
                break
            case .loading:
                break
            case .error:
                break
            }
        }.add(to: &disposal)
    }
    
    func setupData(data:DetailModel?){
        
        guard let data = data else { return }
        
        if let url = URL(string: data.image){
            self.imageView.load(url: url, placeholder: UIImage(named: "placeholder"))
        }
       
        self.textLabel.text = data.detail
        self.title = data.title
    }
}

