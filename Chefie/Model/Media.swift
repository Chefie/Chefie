//
//  Media.swift
//  Chefie
//
//  Created by Nicolae Luchian on 14/04/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation

class Media : Codable {
    
    var id: String?
    var type: String?
    var url : String?
    var thumbnail : String?
    
    init(title: String, url: String){
        self.url = url
        self.id = title
    }
    
    required init() {
        
    }
}
