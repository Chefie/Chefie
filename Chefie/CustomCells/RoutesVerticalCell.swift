//
//  RoutesVerticalCell.swift
//  Chefie
//
//  Created by Alex Lin on 30/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView
import SDWebImage

class RoutesVerticalCellBaseItemInfo : VerticalTableSectionCellBaseInfo {
    
    override func reuseIdentifier() -> String {
        return String(describing: RoutesVerticalCell.self)
    }
    
    override func title() -> String {
        return "Routes"
    }
    
}

class RoutesVerticalCell : VerticalTableSectionView<Route> {
    override var modelSet: [Route]{
        didSet{
            
        }
    }
    
    override func getVisibleItemsCount() -> Int {
        return 3
    }
    
    override func setModel(model: AnyObject?) {
        self.modelSet = (model as? [Route])!.getFirstElements(upTo: getVisibleItemsCount())
    }
    
    override func getModel() -> AnyObject? {
        return modelSet as AnyObject
    }
    
     override func onRequestCell(_ tableView: UITableView, cellForItemAt indexPath: IndexPath) -> UITableViewCell {
        
        if (modelSet.count == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: getCellIdentifier(), for: indexPath) as! PlatoCellView
            cell.viewController = viewController
            cell.collectionItemSize = onRequestItemSize()
            cell.parentView = tableView
            return cell
        }
        
        let cellInfo = self.modelSet[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: getCellIdentifier(), for: indexPath) as! PlatoCellView
        cell.viewController = viewController
        cell.collectionItemSize = onRequestItemSize()
        cell.parentView = tableView
        cell.setModel(model: cellInfo)
        cell.onLoadData()
        
        return cell
    
    }
    
    
    override func onRegisterCells() {
        
        tableView.register(PlatoCellView.self, forCellReuseIdentifier: getCellIdentifier())
    }
    
    override func onLoadData() {
        super.onLoadData()
        
        tableView.reloadData()
        hideSkeleton()
    }
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        
        onLayoutSection()

    }
    
    override func getCellIdentifier() -> String {
        
        return String(describing: PlatoCellView.self)
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
}
