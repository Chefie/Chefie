//
//  AlertService.swift
//  Chefie
//
//  Created by Nicolae Luchian on 29/03/2019.
//  Copyright © 2019 Nicolae Luchian. All rights reserved.
//

import Foundation
import UIKit

class AlertService{
    
    func alert(title:String,body:String,buttonTitle: String) -> AlertViewController{
        
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertVC") as! AlertViewController
        
        alertVC.titleLabel = title
        alertVC.messageLabel = body
        alertVC.actionButtonTitle = buttonTitle
        
        return alertVC
    }
}
