//
//  UIColorExtensions.swift
//  Chefie
//
//  Created by user155921 on 6/1/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    func toRgba(r: CGFloat, g: CGFloat, b : CGFloat, alpha: CGFloat) -> UIColor {
        
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
}
