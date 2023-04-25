//
//  ListEvent.swift
//  FecthDemo
//
//  Created by Siam Biswas on 4/24/23.
//

import Foundation

enum ListState{
    case empty,populated([ListModel]),loading,error(String)
    
    var data:[ListModel]?{
        switch self{
        case let .populated(data) : return data
        default : return nil
        }
    }
}

enum  ListAction{
    case next
}

