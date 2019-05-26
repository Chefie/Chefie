//
//  PalleteExtensions.swift
//  Chefie
//
//  Created by DAM on 24/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func paletteDefaultTextColor() {
        
        self.textColor = Palette.TextDefaultColor
    }
}

extension UIButton {
    
    func paletteDefaultTextColor() {
        
        self.setTitleColor(Palette.TextDefaultColor, for: .normal)
    }
}

struct Palette {

     static let TextDefaultColor = UIColor(red: 144/255, green: 144/255, blue: 144/255, alpha: 1.0)
}
