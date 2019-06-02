//
//  RoutesViewController.swift
//  Chefie
//
//  Created by user155921 on 5/27/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import SDWebImage
import SkeletonView

class RoutesViewController: UIViewController, DynamicViewControllerProto{
    
    var tableItems = Array<BaseItemInfo>()
    var tableCellRegistrator = TableCellRegistrator()
    
    @IBOutlet var mainTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        onSetup()
        onSetupViews()
        onLayout()
        onLoadData()
    }
    
    func onLoadData() {
        appContainer.communityRepository.getCommunities { (result : ChefieResult<[Community]>) in
            
            switch result {
                
            case .success(let data):
                
                data.forEach({ (com) in
                    
                    let item = CommunityCellItemInfo()
                    item.model = com
                    self.tableItems.append(item)
                })
             
                self.mainTable.reloadData()
                break
            case .failure(_): break
            }
        }
    }
    
    func onSetup() {
        
        tableCellRegistrator.add(identifier: CommunityCellItemInfo().reuseIdentifier(), cellClass: CommunityCell.self)
        tableCellRegistrator.registerAll(tableView: mainTable)
    }
    
    func onSetupViews() {
        mainTable.setDefaultSettings()
        mainTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        mainTable.dataSource = self
        mainTable.delegate = self
    }
    
    func onLayout() {
        
    }
}

extension RoutesViewController: SkeletonTableViewDataSource, SkeletonTableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
 
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemsCount = tableItems.count == 0 ? AppSettings.DefaultSkeletonCellCount : tableItems.count
        
        return itemsCount
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return tableItems [indexPath.row].reuseIdentifier()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (self.tableItems.count == 0){
            let ce : BaseCell = mainTable.dequeueReusableCell(withIdentifier: tableCellRegistrator.getRandomIdentifier(), for: indexPath) as! BaseCell
            ce.viewController = self
            ce.parentView = tableView
            return ce
        }
        
        let cellInfo = self.tableItems[indexPath.row]
        
        let ce : BaseCell = mainTable.dequeueReusableCell(withIdentifier: cellInfo.reuseIdentifier(), for: indexPath) as! BaseCell
        ce.viewController = self
        ce.parentView = tableView
        ce.setBaseItemInfo(info: cellInfo)
        ce.setModel(model: cellInfo.model)
        ce.onLoadData()
        return ce
    }
}



