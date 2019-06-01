//
//  RouteDetailsViewController.swift
//  Chefie
//
//  Created by DAM on 31/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit

class RouteDetailsViewController : UIViewController, DynamicViewControllerProto {
    
    var tableItems = Array<BaseItemInfo>()
    var tableCellRegistrator = TableCellRegistrator()
    
    @IBOutlet weak var mainTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onLayout()
        onSetup()
        onSetupViews()
        onLoadData()
    }
    
    func onLoadData() {
        
    }
    
    func onSetup() {
        
    }
    
    func onSetupViews() {
        mainTable.setDefaultSettings()
    }
    
    func onLayout() {
        
    }
}
