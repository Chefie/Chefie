//
//  NotificationRecipeComment.swift
//  Chefie
//
//  Created by user155921 on 6/11/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
struct NotificationPostLike : Codable {
    
    static let NOTIFY_IDENTIFIER : String = "notification_post_liked"
    
    var recipeTitle : String?
}
