//
//  ArrayExtensions.swift
//  Chefie
//
//  Created by user155921 on 5/24/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
extension Array {
    
    func getFirstElements(upTo position: Int) -> Array<Element> {
        
        if (self.count < position){
            
            return self
        }
        
        let arraySlice = self[0 ..< position]
        return Array(arraySlice)
    }
}
