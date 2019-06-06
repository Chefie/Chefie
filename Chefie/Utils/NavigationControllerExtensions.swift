//
//  NavigationControllerExtensions.swift
//  Chefie
//
//  Created by Nicolae Luchian on 04/06/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {

    func setTintColor(color : UIColor = UIColor.lightGray){
         navigationItem.leftItemsSupplementBackButton = true
        self.navigationBar.tintColor = UIColor.lightGray
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<", style: .plain, target: self, action: nil)
    }
}
