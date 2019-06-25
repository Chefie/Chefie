//
//  NotificationSnapshot.swift
//  Chefie
//
//  Created by user155921 on 6/11/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import CodableFirebase
import Firebase
import FirebaseFirestore

public class NotificationSnapshot<T: Codable>: Codable {
    var type : String?
    var dateStr : String?
    var sender : UserMin?
    var targetUser : UserMin?
    
    var data : T?
    
    var message : String?
    
    init() {
     
        self.dateStr = Date().convertDateToString()
    }
}
