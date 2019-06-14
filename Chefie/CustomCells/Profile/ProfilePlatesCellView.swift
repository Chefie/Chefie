//
//  PlatosVerticalCell.swift
//  Chefie
//
//  Created by DAM on 23/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView
import SDWebImage

class ProfilePlatesCellView : VerticalTableSectionCellBaseInfo {
    
    override func reuseIdentifier() -> String {
        return String(describing: ProfilePlatesVerticalCell.self)
    }
    
    override func title() -> String {
        return "Plates"
    }
}

class ProfilePlatesVerticalCell : VerticalTableSectionView<Plate> {

    override var modelSet: [Plate] {
        
        didSet{
            
        }
        
    }
    
    override func getVisibleItemsCount() -> Int {
        return modelSet.count < 3 ? modelSet.count : 3
    }
    
    override func setModel(model: AnyObject?) {
        
        self.modelSet = ((model as? [Plate])!)
    }
    
    override func getModel() -> AnyObject? {
        return modelSet as AnyObject
    }
    
    override func onRequestItemSize() -> CGSize {
        return CGSize(width: self.parentView.getWidth(), height: self.parentView.getHeight().percentageOf(amount: 35))
    }
    
    override func onRequestCell(_ tableView: UITableView, cellForItemAt indexPath: IndexPath) -> UITableViewCell {
        if (modelSet.count == 0) {
            
            return UITableViewCell()
        }
        
        if indexPath.row < modelSet.count {
            let cellInfo = self.modelSet[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: getCellIdentifier(), for: indexPath) as! HomePlatoCellView
            cell.viewController = viewController
            cell.collectionItemSize = onRequestItemSize()
            cell.parentView = tableView
            cell.setModel(model: cellInfo)
            cell.onLoadData()
            
            return cell
        }
        
        return super.onRequestCell(tableView, cellForItemAt: indexPath)
    }
    
    override func onRegisterCells() {
        
        tableView.register(HomePlatoCellView.self, forCellReuseIdentifier: getCellIdentifier())
    }
    
    override func onLoadData() {
        super.onLoadData()
        
        self.hideSkeleton()
    }
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        
        onLayoutSection()
    }
    
    override func getCellIdentifier() -> String {
        
        return String(describing: HomePlatoCellView.self)
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

