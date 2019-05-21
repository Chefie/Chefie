//
//  Result.swift
//  Chefie
//
//  Created by Nicolae Luchian on 07/04/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation

enum ChefieResult<T>{
    
    case success (T)
    case failure (String)
}
