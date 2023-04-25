//
//  FecthDemo.swift
// Transfiguration
//
// Copyright (c) 2020 Siam Biswas.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation
import UIKit

public protocol Transfiguration {
    associatedtype Section:Sectionable
    var provider:Provider<Section> { get set }
    var action : Actionable<Action> { get set }
}

extension Transfiguration{
    
    public func clear(){
        self.provider.data.removeAll()
        self.action.value = .reload
    }
    
    func insert(sections:[Int] = [],indexPaths:[IndexPath] = [],animation:Bool,reload:Bool){
        self.action.value = reload ? .reload : .insert(sections,indexPaths,animation)
    }
    
    func update(sections:[Int]  = [],indexPaths:[IndexPath] = [],animation:Bool,reload:Bool){
        self.action.value = reload ? .reload : .update(sections,indexPaths,animation)
    }
    
    func delete(sections:[Int] = [],indexPaths:[IndexPath] = [],animation:Bool,reload:Bool){
        self.action.value = reload ? .reload : .delete(sections,indexPaths,animation)
    }
}

extension Transfiguration where  Section:Identifiable{
    
    public mutating func insert(_ newElement: Section,animation:Bool = true,reload:Bool = false){
        if let update = self.provider.update(newElement){
            let sections =  [update]
            self.update(sections: sections, animation: animation, reload: reload)
            return
        }
        let sections = [self.provider.insert(newElement)]
        self.insert(sections: sections, animation: animation, reload: reload)
    }
    
    public mutating func append(contentsOf: [Section],animation:Bool = true,reload:Bool = false){
        if let updates = self.provider.update(contentsOf){
            self.update(sections: updates.0, animation: animation, reload: reload)
            
            if updates.1.count > 0{
                let sections = self.provider.insert(updates.1)
                self.insert(sections: sections, animation: animation, reload: reload)
            }
            
            return
        }
        let sections = self.provider.insert(contentsOf)
        self.insert(sections: sections, animation: animation, reload: reload)
    }
    
    public mutating func remove(_ identifier: String,animation:Bool = true,reload:Bool = false){
        guard let section = self.provider.remove(identifier) else { return }
        self.delete(sections: [section], animation: animation, reload: reload)
    }
    
    public mutating func remove(_ element: Section,animation:Bool = true,reload:Bool = false){
        guard let section = self.provider.remove(element) else { return }
        self.delete(sections: [section], animation: animation, reload: reload)
    }
    
}


extension Transfiguration where Section: Operatable{
    
    public mutating func append(_ newElement: Section,animation:Bool = true,reload:Bool = false){
        let sections = [self.provider.append(newElement)]
        self.insert(sections: sections, animation: animation, reload: reload)
    }
    
    public mutating func insert(_ newElement:Section,at:Int?,animation:Bool = true,reload:Bool = false){
        let sections = [self.provider.insert(newElement, at: at)]
        self.insert(sections: sections, animation: animation, reload: reload)
        
    }
    
    public mutating func append(contentsOf: [Section],animation:Bool = true,reload:Bool = false){
        let sections = self.provider.append(contentsOf: contentsOf)
        self.insert(sections: sections, animation: animation, reload: reload)
    }
    
    public mutating func update(_ newElement:Section,at: Int,animation:Bool = true,reload:Bool = false){
        guard self.provider.update(newElement, at: at) else { return }
        self.delete(sections: [at], animation: animation, reload: reload)
    }
    
    public mutating func remove(at: Int,animation:Bool = true,reload:Bool = false){
        guard self.provider.remove(at: at) else { return }
        self.delete(sections: [at], animation: animation, reload: reload)
    }
    
    
    public mutating func appendItem(_ newElement:Section.T, section:Int = 0,animation:Bool = true,reload:Bool = false){
        let indexPath = self.provider.append(newElement, section: section)
        self.insert(indexPaths: [indexPath], animation: animation, reload: reload)
    }
    
    public mutating func insertItem(_ newElement:Section.T, at: Int?, section:Int = 0,animation:Bool = true,reload:Bool = false){
        let indexPath = self.provider.insert(newElement, at: at, section: section)
        self.insert(indexPaths: [indexPath], animation: animation, reload: reload)
    }
    
    public mutating func updateItem(_ newElement: Section.T,at: Int, section:Int = 0,animation:Bool = true,reload:Bool = false){
        guard let indexPath = self.provider.update(newElement, at: at, section: section) else { return }
        self.update(indexPaths: [indexPath], animation: animation, reload: reload)
    }
    
    public mutating func removeItem(at: Int, section:Int = 0,animation:Bool = true,reload:Bool = false){
        guard let indexPath = self.provider.remove(at: at, section: section) else { return }
        self.delete(indexPaths: [indexPath], animation: animation, reload: reload)
    }
    
}



public class Transfigurable<Section:Sectionable>:Transfiguration {
    
    var presenter:Any? = nil
    public var provider:Provider<Section> = Provider(data: [])
    public var action : Actionable<Action> = Actionable()
    
    public subscript(section at: Int) -> Section? {
        return provider.data[safeIndex: at]
    }
    
    public init(){
        self.provider = Provider(data: [])
    }
    
    public init(_ data:[Section]){
        self.provider = Provider(data: data)
    }
    
    public init(_ data:Section){
        self.provider = Provider(data: [data])
    }
}


