//
//  AppContainer.swift
//  Chefie
//
//  Created by Nicolae Luchian on 07/04/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation

class AppContainer {
    
    var userRepository : UserRepository
    var dataManager : DataManager
    var plateRepository : PlateRepository
    
    init() {
        self.plateRepository = PlateRepository()
        self.userRepository = UserRepository()
        self.dataManager = DataManager()
    }
}
