//
//  SettingsViewController.swift
//  Chefie
//
//  Created by Edgar Doutón Parra on 23/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn
import Kingfisher
import SkeletonView
import SDWebImage

class SettingsViewController: UIViewController, DynamicViewControllerProto {
    var tableItems = Array<BaseItemInfo>()
    var tableCellRegistrator = TableCellRegistrator()
    
    var updates: [[String]] = [["Username", ""], ["Passsword", ""], ["Confirm password", ""], []]

    @IBOutlet weak var mainTable: UITableView!{
        didSet {
            mainTable.setCellsToAutomaticDimension()
        }
    }
    override func updateViewConstraints() {

        mainTable.snp.makeConstraints { (make) in

            make.width.equalTo(self.view)
            make.height.equalTo(self.view)
        }

        super.updateViewConstraints()
    }

    func onSetup() {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()

        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        

      
    }

    func onSetupViews(){

        mainTable.backgroundColor = UIColor.white

        self.mainTable.dataSource = self
        self.mainTable.isSkeletonable = true
        self.mainTable.delegate = self
        
        
    }

    func onLoadData() {

    }

    func onLayout() {

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        onSetup()
        onSetupViews()
        
        tableCellRegistrator.add(identifier: FieldCellItemInfo().uniqueIdentifier(), cellClass: FieldCellView.self)
        
        tableCellRegistrator.registerAll(tableView: mainTable)
        
        
        for _ in 0...3 {
            let info = FieldValueInfo()
            info.label = "Title"
            info.value = ""
            
            let fieldItemInfo = FieldCellItemInfo()
            fieldItemInfo.model = info
            tableItems.append(fieldItemInfo)
            
        }
        
//        appContainer.userRepository.get
//        switch result {
//        case .success(let data):
//            var items = [BaseItemInfo]()
//
//
//            let info = FieldValueInfo ()
//            info.label = "Username"
//            info.value = "Test"
//
//
//            let fI = FieldCellItemInfo()
//            fI.model = info
//            items.append(fI)
//            self.tableItems = items
//            self.mainTable.reloadData()
//        case .failure(_):
//            break;
//        }
        
        
        

    }

}

extension SettingsViewController: SkeletonTableViewDataSource, SkeletonTableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItems.count == 0 ? 4 : tableItems.count
    }

    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return tableItems [indexPath.row].uniqueIdentifier()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (self.tableItems.count == 0){
            let ce : BaseCell = mainTable.dequeueReusableCell(withIdentifier: tableCellRegistrator.getRandomIdentifier(), for: indexPath) as! BaseCell
            ce.viewController = self
            ce.parentView = tableView
            return ce
        }

        let cellInfo = self.tableItems[indexPath.row]

        let ce : BaseCell = mainTable.dequeueReusableCell(withIdentifier: cellInfo.uniqueIdentifier(), for: indexPath) as! BaseCell
        ce.viewController = self
        ce.parentView = tableView
        ce.setModel(model: cellInfo.model)
        ce.onLoadData()
        return ce
    }
}

