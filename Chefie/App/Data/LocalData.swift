//
//  LocalData.swift
//  Chefie
//
//  Created by Nicolae Luchian on 07/04/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import RxSwift

class LocalData {
    
    var chefieUser = ChefieUser()
    
    let LoginSubject = PublishSubject<ChefieUser>()
    
    init() {
    
    }
    
    func onLogin(user : ChefieUser){
  
        self.chefieUser = user
        appContainer.setup()
        print("Logged User: ", user.userName, ",", user.id)
        LoginSubject.on(.next(user))
    }
}
