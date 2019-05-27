//
//  ProfileViewController.swift
//  Chefie
//
//  Created by Nicolae Luchian on 22/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn
import Kingfisher
import SkeletonView
import SDWebImage

class ProfileViewController: UIViewController, DynamicViewControllerProto {
    
    var tableItems = Array<BaseItemInfo>()
    var tableCellRegistrator = TableCellRegistrator()
    
    @IBOutlet var mainTable: UITableView!{
        didSet {
            mainTable.setCellsToAutomaticDimension()
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        mainTable.snp.makeConstraints { (make) in
            
            make.width.equalTo(self.view)
            make.height.equalTo(self.view)
        }
    }
    
    func onSetup() {
        
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }
    
    func onSetupViews() {
        
        mainTable.backgroundColor = UIColor.white
        
        self.mainTable.dataSource = self
        self.mainTable.isSkeletonable = true
        self.mainTable.delegate = self
    }
    
    func onLoadData() {
        
        let userMin = UserMin()
        let userInfo = ChefieUser()
        userMin.profilePic = "https://www.cheftochefconference.com/wp-content/uploads/2018/11/John-Folse-web-300x300.jpg"
        userMin.profileBackground = "https://s3.envato.com/files/253777548/FMX_2289.jpg"
        
        userInfo.followers = 222
        userInfo.following = 333
        
        userInfo.userName = "@joseAntonio"
        userInfo.biography = "Me gusta mucho la cocina casera"
        
        
        
        //Model UserMin
        let pInfo = ProfilePicCellItemInfo()
        pInfo.model = userMin
        
        //Model ChefieUser
        let chefieUserInfo = ProfileInfoItemInfo()
        chefieUserInfo.model = userInfo
        
        //Adding to array
        tableItems.append(pInfo)
        tableItems.append(chefieUserInfo)
        
        
        mainTable.reloadData()
    }
    
    func onLayout() {
        
    }
    
    override func viewDidLoad() {
           super.viewDidLoad()
        navigationItem.title = "Chefie"
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Zapfino", size: 13)!]
        view.backgroundColor = .white
        onSetup()
        onSetupViews()
        
        //////////////////////////////////////////////////////
        tableCellRegistrator.add(identifier: ProfilePicCellItemInfo().identifier(), cellClass: ProfilePicCellView.self)
        //////////////////////////////////////////////////////
        tableCellRegistrator.add(identifier: ProfileInfoItemInfo().identifier(), cellClass: ProfileInfoCellView.self)
        
        tableCellRegistrator.registerAll(tableView: mainTable)
        
        onLoadData()
    }
}

extension ProfileViewController: SkeletonTableViewDataSource, SkeletonTableViewDelegate {
    
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
        return tableItems [indexPath.row].identifier()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (self.tableItems.count == 0){
            let ce : BaseCell = mainTable.dequeueReusableCell(withIdentifier: tableCellRegistrator.getRandomIdentifier(), for: indexPath) as! BaseCell
            ce.viewController = self
            ce.parentView = tableView
            return ce
        }
        
        let cellInfo = self.tableItems[indexPath.row]
        
        let ce : BaseCell = mainTable.dequeueReusableCell(withIdentifier: cellInfo.identifier(), for: indexPath) as! BaseCell
        ce.viewController = self
        ce.parentView = tableView
        ce.setModel(model: cellInfo.model)
        ce.onLoadData()
        return ce
    }
}
