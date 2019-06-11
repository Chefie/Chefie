//
//  ForeignProfileViewController.swift
//  Chefie
//
//  Created by Alex Lin on 03/06/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn
import SkeletonView
import SDWebImage

class ForeignProfileViewController: UIViewController, DynamicViewControllerProto {

    var tableItems = Array<BaseItemInfo>()
    var tableCellRegistrator = TableCellRegistrator()
    
    var model : UserMin?{
        
        didSet{
            
            
        }
    }
    
    @IBOutlet var mainTable: UITableView!{
        didSet {
          
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
        
        tableCellRegistrator.add(identifier: ProfilePicCellItemInfo().reuseIdentifier(), cellClass: ProfilePicCellView.self)
       
        tableCellRegistrator.add(identifier: ProfileUsernameItemInfo().reuseIdentifier(), cellClass: ProfileUsernameCellView.self)
        
        tableCellRegistrator.add(identifier: ProfileFollowItemInfo().reuseIdentifier(), cellClass: ProfileFollowCellView.self)
      
        tableCellRegistrator.add(identifier: ProfileBioItemInfo().reuseIdentifier(), cellClass: ProfileBioCellView.self)

        tableCellRegistrator.add(identifier: ProfileFollowBtnItemInfo().reuseIdentifier(), cellClass: ProfileFollowBtnCellView.self)
    }
    
    func onSetupViews() {
    
        mainTable.backgroundColor = UIColor.white
        
        self.mainTable.dataSource = self
        self.mainTable.isSkeletonable = true
        self.mainTable.delegate = self
        
        mainTable.backgroundColor = UIColor.white
        mainTable.snp.makeConstraints { (make) in
            
            make.width.equalTo(self.view.getWidth())
            make.height.equalTo(self.view.getHeight())
        }

        tableCellRegistrator.registerAll(tableView: mainTable)
  
        mainTable.setDefaultSettings(shouldBounce: false)
    }
    
    func onLoadData() {
        
        let userMin = UserMin()
        
        let userInfo = ChefieUser()
        userMin.profilePic = model?.profilePic
        userMin.profileBackground = model?.profileBackground
        userMin.userName =  model?.userName
        
        userInfo.followers = 222
        userInfo.following = 333
        
        userInfo.userName = userMin.userName
        userInfo.biography = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam lacus orci, lacinia nec arcu et, dictum tincidunt elit. Mauris in nibh ut lorem euismod commodo. Integer nec est neque. Quisque et turpis commodo, suscipit elit id, efficitur augue."
        
        
        //Model UserMin
        let pInfo = ProfilePicCellItemInfo()
        pInfo.model = userMin
        
        //Model ChefieUser
        let chefieUserInfo = ProfileInfoItemInfo()
        chefieUserInfo.model = userInfo
        
        let username = ProfileUsernameItemInfo()
        username.model = userMin
        
        let follows = ProfileFollowItemInfo()
        follows.model = userInfo
        
        let bio = ProfileBioItemInfo()
        bio.model = userInfo
        
        let btnFollow = ProfileFollowBtnItemInfo()

        btnFollow.model = model
        //Adding to array
        tableItems.append(pInfo)
        tableItems.append(username)
        tableItems.append(follows)
        tableItems.append(btnFollow)
        tableItems.append(bio)
    }
    
    func onLayout() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        navigationController?.setTintColor()
        navigationItem.title = model?.userName
        view.backgroundColor = .white
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        onSetup()
        onSetupViews()
        onLoadData()
    }
}

extension ForeignProfileViewController: SkeletonTableViewDataSource, SkeletonTableViewDelegate {
    
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
        ce.setModel(model: cellInfo.model)
        ce.onLoadData()
        return ce
    }
}
