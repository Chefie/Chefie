//
//  FoodTimelineViewController.swift
//  Chefie
//
//  Created by Steven on 27/04/2019.
//  Copyright © 2019 chefie. All rights reserved.
//
import Foundation
import UIKit
import SkeletonView
import SDWebImage

class PlateDetailsViewController : UIViewController, DynamicViewControllerProto {
    
    var tableItems = Array<BaseItemInfo>()
    var tableCellRegistrator = TableCellRegistrator()
    
    var model : Plate?{
        
        didSet{
         
            
        }
    }
    
    @IBOutlet weak var mainTable: UITableView!

    func onLoadData() {
        
        navigationItem.title = model?.title
        
        let plateMediaCarousel = PlateMediaCarousellItemInfo()
        plateMediaCarousel.model = model
        tableItems.append(plateMediaCarousel)
        
        let infoHeader = HeaderTextCellItemInfo()
        infoHeader.model = HeaderTextModel(title: "Info") as AnyObject
        tableItems.append(infoHeader)
        
        let plateInfo = PlateInfoCellItemInfo()
        plateInfo.model = model
        tableItems.append(plateInfo)
        
        let headerDescription = HeaderTextCellItemInfo()
        headerDescription.model = HeaderTextModel(title: "Description") as AnyObject
        tableItems.append(headerDescription)
        
        let description = LargeTextCellItemInfo()
        description.model = LargeTextModel(text: "Rich in mystery quasar intelligent beings encyclopaedia galactica billions upon billions across the centuries. Tendrils of gossamer clouds bits of moving fluff concept of the number one a very small stage in a vast cosmic arena with pretty stories for which there's little good evidence a still more glorious dawn awaits.Rich in mystery quasar intelligent beings encyclopaedia galactica billions upon billions across the centuries. Tendrils of gossamer clouds bits of moving fluff concept of the number one a very small stage in a vast cosmic arena with pretty stories for which there's little good evidence a still more glorious dawn awaits") as AnyObject
        
        tableItems.append(description)
        
        let comments = Array(0...3).compactMap { (num) -> Comment? in
               let comment = Comment()
               comment.likes = Array()
               comment.id = String(describing: num)
               return comment
        }

        let commentVertical = PlateCommentsItemInfo()
        commentVertical.setTitle(value: "Comments")
        commentVertical.model = comments as AnyObject
        tableItems.append(commentVertical)

        mainTable.reloadData()
    }
    
    func onSetup() {
        
        tableCellRegistrator.add(identifier: PlateInfoCellItemInfo().reuseIdentifier(), cellClass: PlateInfoCell.self)
        tableCellRegistrator.add(identifier: LargeTextCellItemInfo().reuseIdentifier(), cellClass: LargeTextCellView.self)
        tableCellRegistrator.add(identifier: HeaderTextCellItemInfo().reuseIdentifier(), cellClass: HeaderTextCellView.self)
        tableCellRegistrator.add(identifier: PlateMediaCarousellItemInfo().reuseIdentifier(), cellClass: PlateMediaCarousellCellView.self)
        
          tableCellRegistrator.add(identifier: PlateCommentsItemInfo().reuseIdentifier(), cellClass: PlateCommentsVerticalCell.self)
        
        tableCellRegistrator.registerAll(tableView: mainTable)
    }
    
    func onSetupViews() {

        mainTable.setDefaultSettings()
        
        mainTable.frame = CGRect(x: 0, y: 0, width: self.view.getWidth(), height: self.view.getHeight())
        mainTable.snp.makeConstraints { (make) in
            
            make.topMargin.equalTo(0)
            
            make.width.equalTo(self.view.getWidth())
            make.height.equalTo(self.view.getHeight())
        }
        
        mainTable.delegate = self
        mainTable.dataSource = self
    }

    func onLayout() {
 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setTintColor()
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    
        onSetup()
        onSetupViews()
        onLayout()
        onLoadData()
    }
}

extension PlateDetailsViewController: SkeletonTableViewDataSource, SkeletonTableViewDelegate {
    
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
        ce.index = indexPath.row
        ce.setBaseItemInfo(info: cellInfo)
        ce.setModel(model: cellInfo.model)
        ce.onLoadData()
        return ce
    }
}
