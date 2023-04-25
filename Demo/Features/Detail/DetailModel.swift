//
//  DetailModel.swift
//  FecthDemo
//
//  Created by Siam Biswas on 4/24/23.
//

import Foundation

protocol DetailModelProtocol: Model {
    
    var title:String { get set }
    var id:String { get set }
    var image:String { get set }
    var instruction:String { get set }
    var items:[Item] { get set }
}

struct DetailModel: DetailModelProtocol{
    
    var title:String
    var id:String
    var image:String
    var instruction:String
    var items:[Item] = []
    
    var detail:String{
        
        var detail = ""
        
        
        if items.count > 0 {
            detail.append("Ingredients & Measurements #\n\n")
            
            items.forEach { item in
                detail.append("\(item.ingredient) : \(item.measurement) \n")
            }
            
            detail.append("\n\n")
        }
        
        if !instruction.isEmpty{
            detail.append("Instruction #\n\n")
            detail.append(instruction)
        }
        
        
        if detail.isEmpty{
            detail.append("Ingredients, Measurements & Instruction is not available for this item")
        }
        
        
        
        return detail
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "strMeal"
        case id = "idMeal"
        case image = "strMealThumb"
        case instruction = "strInstructions"
    }
    
    struct CustomCodingKeys:CodingKey{
        
        var intValue: Int?
        var stringValue: String
        
        init?(intValue: Int) {
            self.intValue = intValue
            self.stringValue = ""
        }

        
        init?(stringValue: String){
            self.stringValue = stringValue
        }
    }
    
    init(title: String, id: String, image: String) {
        self.title = title
        self.id = id
        self.image = image
        self.instruction = ""
        self.items = []
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.id = try container.decode(String.self, forKey: .id)
        self.image = try container.decode(String.self, forKey: .image)
        self.instruction = try container.decode(String.self, forKey: .instruction)
        
        for i in 1...20{
            let customContainer = try decoder.container(keyedBy: CustomCodingKeys.self)
            if let ingredientKey = CustomCodingKeys(stringValue: "strIngredient\(i)"), let measurementKey = CustomCodingKeys(stringValue: "strMeasure\(i)"){
                let ingredient = try customContainer.decode(String.self, forKey: ingredientKey)
                let measurement = try customContainer.decode(String.self, forKey: measurementKey)
                
                if !ingredient.isEmpty && !measurement.isEmpty{
                    self.items.append(Item(ingredient: ingredient, measurement: measurement))
                }
               
            }
           
        }
    }
}

struct Item:Model{
    var ingredient:String
    var measurement:String
}

struct DetailResponse:Model{
    var meals:[DetailModel]
}

