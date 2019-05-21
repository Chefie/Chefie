//
//  ViewExtensions.swift
//  Chefie
//
//  Created by Nicolae Luchian on 04/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit

let g_ViewRadius = CGFloat(4.0)
extension UIView{
    
    func setSkeleton(value : Bool){
        
        self.isSkeletonable = value
    }
    
    func setTouch(target : Any, selector: Selector){
        
        let singleTap = UITapGestureRecognizer(target: target, action: selector)
        singleTap.numberOfTapsRequired = 1
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(singleTap)
    }

    func addShadow() {
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shouldRasterize = true
    }
    
    func getWidth() -> CGFloat{
    
        return self.frame.width
    }
    
    func getHeight() -> CGFloat{
        
        return self.frame.height
    }
    
    func setCornerRadius() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = CGFloat(g_ViewRadius)
    }
    
    func setCornerRadius(radius : CGFloat){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
}

extension UITableView{
    
    func setCellsToAutomaticDimension() {
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = UITableView.automaticDimension
    }
}
