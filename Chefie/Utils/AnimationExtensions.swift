//
//  AnimationExtensions.swift
//  Chefie
//
//  Created by user155921 on 5/25/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func doFadeIn() {
        
        if isHidden {
            
            isHidden = false
        }
        
        self.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            self.alpha = 1
        })
    }
    
    func doFadeOut() {
        
        self.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            self.alpha = 1
        })
    }
}
