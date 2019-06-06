//
//  Plato.swift
//  Chefie
//
//  Created by Nicolae Luchian on 14/04/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import CodableFirebase

class Plate : Codable
{
    required init() {
        
    }
    
    var id: String?
    var created_at : String?
    var idUser : String?
    var title : String?
    var description : String?
    var multimedia: Array<Media>?
    var numLikes : Array<Like>?
    var numVisits : Int?
    var comments : Array<Comment>?
    var community : Community?
    var tags : Array<Tag>?
    var ingredients : Array<String>?
    var user : UserMin?
}
