//
//  AlertServiceDelete.swift
//  Chefie
//
//  Created by Nicolae Luchian on 01/06/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit

class AlertServiceDelete{
    
    func alert(title:String,body:String,buttonTitle: String) -> AlertDeleteController{
        
        let storyboard = UIStoryboard(name: "AlertDeleteProfile", bundle: .main)
        
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertVC") as! AlertDeleteController
        
        alertVC.titleLabel = title
        alertVC.messageLabel = body
        alertVC.actionButtonTitle = buttonTitle
        
        return alertVC
    }
}
