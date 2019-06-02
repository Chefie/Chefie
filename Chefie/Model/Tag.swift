//
//  Tag.swift
//  Chefie
//
//  Created by Nicolae Luchian on 14/04/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation

class Tag : Codable{
    
    var id : String?
    var label : String?
    
    init(label : String) {
        
        self.label = label
    }
    
    required init() {
        
    }
}
