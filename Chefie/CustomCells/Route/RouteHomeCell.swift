//
//  RouteHomeCell.swift
//  Chefie
//
//  Created by DAM on 31/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
class RouteHomeCell : BaseCell, ICellDataProtocol {
    var model: Route?
    
    typealias T = Route
    
    override func getModel() -> AnyObject? {
        return model
    }
    
    override func setModel(model: AnyObject?) {
        self.model = (model as! Route)
    }
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        
    }
    
    override func onLoadData() {
        super.onLoadData()
    }
    
    override func onCreateViews() {
        super.onCreateViews()
    }
}
