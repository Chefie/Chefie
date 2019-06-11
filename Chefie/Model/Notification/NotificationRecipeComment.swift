//
//  NotificationRecipeComment.swift
//  Chefie
//
//  Created by user155921 on 6/11/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
struct NotificationRecipeComment : Codable {
    
    static let NOTIFY_IDENTIFIER : String = "notification_new_recipe_comment"
    
    var comment : Comment?
    var recipeTitle : String?
}
