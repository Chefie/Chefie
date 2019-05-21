//
//  DynamicViewControllerProto.swift
//  Chefie
//
//  Created by Nicolae Luchian on 04/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation

// Protocol class for View Controllers
protocol DynamicViewControllerProto {
    
    func onLoadData()
    func onSetup()
    func onSetupViews()
    func onLayout()
}
