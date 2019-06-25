//
//  ArrayExtensions.swift
//  Chefie
//
//  Created by user155921 on 5/24/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    func removingDuplicates() -> Array {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}

extension Array {
    
    func filterDuplicates(includeElement: @escaping (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()
        
        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        
        return results
    }
    
    func getFirstElements(upTo position: Int) -> Array<Element> {
        
        if (self.count < position){
            
            return self
        }
        
        let arraySlice = self[0 ..< position]
        return Array(arraySlice)
    }
}
