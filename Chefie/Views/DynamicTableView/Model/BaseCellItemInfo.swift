//
//  BaseCellInfo.swift
//  Chefie
//
//  Created by user155921 on 5/21/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
class BaseItemInfo : ICellDataInfo {
    func identifier() -> String {
        return ""
    }
    
    var model : AnyObject?
}
