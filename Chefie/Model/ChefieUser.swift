//
//  ChefieUser.swift
//  Chefie
//
//  Created by Nicolae Luchian on 07/04/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation

class ChefieUser : Codable {
    required init() {
        
    }
    
    var id : String?
    var userName : String?
    var email : String?
//    var password: String?
    var fullName: String?
    var following : Int?
    var followers: Int?
    var profilePic: String?
    var profileBackgroundPic : String?
    var biography: String?
    var isPremium : Bool?
    var deleted: Bool?
    var gender : String?
    var location: String?
    var community: String?
    
//    init(email: String, password: String) {
//        
//        self.email = email
//        self.password = password
//    }
}

extension ChefieUser {
    
    func mapToUserMin() -> UserMin {
    
        let min = UserMin()
        min.id = id
        min.profileBackground = profileBackgroundPic
        min.profilePic = profilePic
        min.userName = userName
        
        return min
    }
}
