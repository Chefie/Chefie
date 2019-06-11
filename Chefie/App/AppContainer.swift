//
//  AppContainer.swift
//  Chefie
//
//  Created by Nicolae Luchian on 07/04/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation

class AppContainer {
    
    //static let shared = appContainer()
    
    var userRepository : UserRepository
    var dataManager : DataManager
    var plateRepository : PlateRepository
    var s3Repository : S3Repository
    var mediaRepository : MultiMediaRepository
    var communityRepository : CommunityRepository
    var commentRepository : CommentRepository
    
    func getUser() -> ChefieUser{
        
        return dataManager.localData.chefieUser
    }
    
    init() {
        self.plateRepository = PlateRepository()
        self.userRepository = UserRepository()
        self.dataManager = DataManager()
        self.s3Repository = S3Repository()
        self.mediaRepository = MultiMediaRepository()
        self.communityRepository = CommunityRepository()
        self.commentRepository = CommentRepository()
    }
}
