//
//  Comment.swift
//  Chefie
//
//  Created by Nicolae Luchian on 14/04/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation

class Comment : Codable {
    
    var id : String?
    var idUser: String?
    var content : String?
    var likes: Array<Like>?
    var parentCommentId : String?
    required init() {
        
    }
}
