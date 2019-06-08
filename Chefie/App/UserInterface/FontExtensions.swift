//
//  FontExtensions.swift
//  Chefie
//
//  Created by user155921 on 5/25/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit

struct DefaultFonts {
    
    static let DefaultHeaderTextFont : UIFont = {
        
        guard let customFont = UIFont(name: "SamsungSans-Regular", size:  DefaultDimensions.HeaderTextSize) else {
            fatalError("Failed to load Samsung Sans Font"
            )
        }
        
        return customFont
    }()
    
    static let DefaultHeaderTextBoldFont : UIFont = {
        
        guard let customFont = UIFont(name: "SamsungSans-Bold", size:  DefaultDimensions.HeaderTextSize) else {
            fatalError("Failed to load Samsung Sans Font"
            )
        }
        
        return customFont
    }()
    
    static let DefaultHeaderTextLightFont : UIFont = {
        
        guard let customFont = UIFont(name: "SamsungSans-Light", size:  DefaultDimensions.HeaderTextSize) else {
            fatalError("Failed to load Samsung Sans Font"
            )
        }
        
        return customFont
    }()
    
    static let ZapFino : UIFont = {
        
        let font = UIFont(name: "Zapfino", size: 18)
        return font!
    }()
    
    static let DefaultTextFont : UIFont = {
        
        guard let customFont = UIFont(name: "SamsungSans-Regular", size:  DefaultDimensions.DefaultTextSize) else {
            fatalError("Failed to load Samsung Sans Font"
            )
        }
        
        return customFont
    
    }()
    
    static let DefaultTextBoldFont : UIFont = {
        
        guard let customFont = UIFont(name: "SamsungSans-Bold", size:  DefaultDimensions.DefaultTextSize) else {
            fatalError("Failed to load Samsung Sans Bold Font"
            )
        }
        
        return customFont
        
    }()
    
    static let DefaultTextLightFont : UIFont = {
        
        guard let customFont = UIFont(name: "SamsungSans-Light", size: DefaultDimensions.DefaultTextSize) else {
            fatalError("Failed to load Samsung Sans Light Font"
            )
        }
        
        return customFont
        
    }()
}
