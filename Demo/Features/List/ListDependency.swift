//
//  ListDependency.swift
//  FecthDemo
//
//  Created by Siam Biswas on 4/24/23.
//

import Foundation

protocol ListDependencyProtocol{
    
    var data:Transfigurable<Section<ListModel>> { get }
    
    mutating func setData(data:[ListModel])
}

struct ListDependency: ListDependencyProtocol {
    
    var data:Transfigurable<Section<ListModel>>
    
    
    mutating func setData(data: [ListModel]) {
        self.data.clear()
        self.data.append(Section(identifier: "topics", data: data))
    }
}
