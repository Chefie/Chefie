//
//  Story.swift
//  Chefie
//
//  Created by DAM on 14/06/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit

class Story : Codable {
    
    var tintColor : String?
    var media : Media?
    var user : UserMin?
}

extension Story {
    
    func mapTintToUIColor() -> UIColor {
        
        if let str = tintColor?.components(separatedBy: ";") {
            
            let rgbValues = str.compactMap({ (val) -> CGFloat in
               
                return val.CGFloatValue() ?? 0
            })
            
            
            return rgbaToUIColor(red: rgbValues[1], green: rgbValues[1], blue:  rgbValues[1], alpha:  rgbValues[1])
        }
   
        return UIColor.orange
    }
}
