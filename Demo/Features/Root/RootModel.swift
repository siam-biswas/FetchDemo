//
//  RootModel.swift
//  FecthDemo
//
//  Created by Siam Biswas on 4/24/23.
//

import Foundation


protocol RootModelProtocol: Model {
    var meals:[Meals] { get set }
}

struct RootModel: RootModelProtocol{
    
    var meals:[Meals]

}


struct Meals:Model, Equatable,Hashable{
    
    static func == (lhs: Meals, rhs: Meals) -> Bool {
        return lhs.idMeal == rhs.idMeal
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(idMeal)
    }
    
    
    var strMeal:String
    var strMealThumb:String
    var idMeal:String
    
    func toList() -> ListModel{
        
        return ListModel(title:  strMeal, id: idMeal, image: strMealThumb)
    }
}
