//
//  DImensionExtensions.swift
//  Chefie
//
//  Created by DAM on 24/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func setFont(font : UIFont = DefaultFonts.DefaultTextFont){
        self.font = font
    }
    
    func defaultTextFont(bold : Bool = false) {
        var newFont : UIFont?
        if (bold){
          
             newFont = DefaultFonts.DefaultTextBoldFont
        }
        else {
              newFont = DefaultFonts.DefaultTextFont
        }

        self.font = newFont
    }
    
    func defaultHeaderTextFont(bold : Bool = false) {
        
        var newFont : UIFont?
        if (bold){
            
            newFont = DefaultFonts.DefaultHeaderTextBoldFont
        }
        else {
            newFont = DefaultFonts.DefaultHeaderTextFont
        }
        
        self.font = newFont
    }
    
    func defaultFooterTextFont(bold : Bool = false) {
        
        var newFont : UIFont?
        if (bold){
            
            newFont = DefaultFonts.DefaultTextBoldFont.withSize(DefaultDimensions.FooterTextSize)
        }
        else {
            newFont = DefaultFonts.DefaultHeaderTextFont.withSize(DefaultDimensions.FooterTextSize)
        }
        
        self.font = newFont
    }
}

extension UIButton {
    
    func defaultTextFont(bold : Bool) {
        
        var newFont : UIFont?
        if (bold){
            
            newFont = DefaultFonts.DefaultTextBoldFont
        }
        else {
            newFont = DefaultFonts.DefaultTextFont
        }
        
        self.titleLabel?.font = newFont
    }
}

struct DefaultDimensions {
    
    static let DefaultTextSize = CGFloat(14.0)
    static let HeaderTextSize = CGFloat(20.0)
    static let FooterTextSize = CGFloat(16.0)
}
