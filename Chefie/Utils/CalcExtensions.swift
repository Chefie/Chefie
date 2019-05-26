//
//  CalcUtils.swift
//  Chefie
//
//  Created by Steven on 28/04/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import SnapKit

extension CGRect {
    
    mutating func addY(value : CGFloat){
    
        self.origin.y += value
    }
    
    mutating func setY(value : CGFloat){
        self.origin.y = value
    }
    
}

extension UIView {
    
    func widthPercentageOf(amount: CGFloat) -> CGFloat {
        
        return self.frame.width * (amount / 100)
    }
    
    func heightPercentageOf(amount: CGFloat) -> CGFloat {

      return self.frame.height * (amount / 100)
    }
    
    func sizePercentageOf(widthAmount: CGFloat, heightAmount: CGFloat) -> CGSize {
        
        return CGSize(width: self.frame.width * (widthAmount / 100), height: self.frame.height * (heightAmount / 100))
    }
}

extension CGSize {
    
    func widthPercentageOf(amount: CGFloat) -> CGFloat {
        
        return self.width * (amount / 100)
    }
    
    func heightPercentageOf(amount: CGFloat) -> CGFloat {
        
        return self.height * (amount / 100)
    }
}


extension CGFloat {

    func percentageOf(amount: CGFloat) -> CGFloat {
        
        return self * (amount / 100)
    }
    
    func minusWithoutPercentage(amount: CGFloat) -> CGFloat {
        
        return self - amount
    }
    
    func minus(amount: CGFloat) -> CGFloat {
        
        let _left = self.percentageOf(amount: amount)
        return self - _left
    }
    
    func margin(amount : CGFloat) -> CGFloat {
        let newSize = self.minus(amount: self.percentageOf(amount: amount))
        return newSize
    }
}

extension Int{
    
    func percentageOf(amount: CGFloat) -> Int {
        
        return self * Int((amount / 100))
    }
}
