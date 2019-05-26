//
//  CFMargin.swift
//  Chefie
//
//  Created by user155921 on 5/25/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit

public struct CFMargin {
    
     var left: CGFloat = 0
     var right: CGFloat = 0
     var top: CGFloat = 4
     var bottom : CGFloat = 0

     init(left: CGFloat = 0, top: CGFloat = 0, right: CGFloat , bottom : CGFloat = 0){
    
        self.left = left
        self.top = top
        self.right = right
        self.bottom = bottom
    }
}
