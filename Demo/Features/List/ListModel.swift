//
//  ListModel.swift
//  FecthDemo
//
//  Created by Siam Biswas on 4/24/23.
//

import Foundation

protocol ListModelProtocol: Model {
    var title:String { get set }
    var id:String { get set }
    var image:String { get set }
}

struct ListModel: ListModelProtocol{
    var title:String
    var id:String
    var image:String
    
    func toDetail() -> DetailModel{
        return DetailModel(title: title, id: id, image: image) 
    }
}


