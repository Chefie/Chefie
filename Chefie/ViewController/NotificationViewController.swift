//
//  NotificationViewController.swift
//  Chefie
//
//  Created by DAM on 14/06/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView
import CRRefresh

class NotificationViewController : UIViewController, DynamicViewControllerProto{
    
    var tableItems = Array<BaseItemInfo>()
    var tableCellRegistrator = TableCellRegistrator()
    var endlessTableHelper : EndlessTableHelper!
    
    @IBOutlet var mainTable: UITableView!
    
    var retrieveInfo = RetrieveNotificationInfo()
    
    func onSetup() {
        
        endlessTableHelper = EndlessTableHelper(table: mainTable)
        endlessTableHelper.firstItemsCount = 10
        mainTable.setDefaultSettings(shouldBounce: true)
        
        tableCellRegistrator.add(identifier: NotificationItemInfo().reuseIdentifier(), cellClass: NotificationCell.self)
    }
    
    func onSetupViews() {
        
        view.backgroundColor = .white
        
        navigationController?.setTintColor()
        
        navigationController?.setTitle(title: "Notifications")
        
        mainTable.frame = CGRect(x: 0, y: 0, width: self.view.getWidth(), height: self.view.getHeight())
        mainTable.snp.makeConstraints { (make) in
            
            make.topMargin.equalTo(20)
            
            make.width.equalTo(self.view.getWidth())
            make.height.equalTo(self.view.getHeight())
        }
        
        self.mainTable.dataSource = self
        self.mainTable.isSkeletonable = true
        self.mainTable.delegate = self
    }
    
    func onLayout() {
        
        
    }
    
    func onLoadData() {
        
        let UID = appContainer.getUser().id!
        
        appContainer.notificationRepository.getNotificationFeedFrom(idUser: UID, retrieveInfo: retrieveInfo) { (result : ChefieResult<RetrieveNotificationInfo>) in
            
            switch result {
                
            case .success(let res):
                
                self.retrieveInfo.update(result: res)
                
                if let data = res.data {
                    
                    let items = data.removingDuplicates().compactMap({ (item) -> NotificationItemInfo in
                        let info = NotificationItemInfo()
                        info.model = item as AnyObject
                        return info
                    })
                    
                    self.endlessTableHelper.loadMoreItems(itemsCount: items.count
                        , callback: {
                            
                            items.forEach({ (item) in
                                
                                self.tableItems.append(item)
                                self.endlessTableHelper.insertRow(itemsCount: self.tableItems.count - 1)
                            })
                            
                            self.endlessTableHelper.setCount(count: self.tableItems.count)
                    })
                }
                
                break
            case .failure(_): break
            }
            
            self.mainTable.cr.endHeaderRefresh()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onSetup()
        onSetupViews()
        tableCellRegistrator.registerAll(tableView: mainTable)
        //   onLoadData()
        
        let barButton = UIBarButtonItem()
        barButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = barButton
        
        navigationItem.title = "Notifications"
        
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: DefaultFonts.ZapFinoXs]
        
        mainTable.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            
            self?.onLoadData()
        }
        
        mainTable.cr.beginHeaderRefresh()
        
        self.setDefaultBackButton()
    }
}

extension NotificationViewController: SkeletonTableViewDataSource, SkeletonTableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let itemsCount = endlessTableHelper.getCount()
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
