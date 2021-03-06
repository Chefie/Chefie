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
        
        tableCellRegistrator.add(identifier: LargeTextCellItemInfo().reuseIdentifier(), cellClass: LargeTextCellView.self)
        
         tableCellRegistrator.add(identifier: ProfilePlatesCellItemInfo().reuseIdentifier(), cellClass: ProfilePlatesVerticalCell.self)
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
        
        let userMin = model!
        let userInfo = ChefieUser()
        userInfo.id = userMin.id
        guard let modelUserId = model?.id else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        let dispatchQueue = DispatchQueue(label: "LoadForeignProfile", qos: .background)
        dispatchQueue.async{
            
            let group = DispatchGroup()
            group.enter()
            appContainer.userRepository.getProfileData(idUser: modelUserId) { [weak self] (result:(ChefieResult<ChefieUser>))  in
                switch result {
                case.success(let data):
                    userMin.id = data.id
                    userMin.userName = data.userName
                    userMin.profilePic = data.profilePic
                    userMin.profileBackground = data.profileBackgroundPic
                    userInfo.followers = data.followers
                    userInfo.following = data.following
                    let pInfo = ProfilePicCellItemInfo()
                    pInfo.model = userMin
                    
                    let chefieUserInfo = ProfileInfoItemInfo()
                    chefieUserInfo.model = userInfo
                    
                    let username = ProfileUsernameItemInfo()
                    username.model = userMin
                    
                    let follows = ProfileFollowItemInfo()
                    follows.model = userInfo
                    
                    let bio = LargeTextCellItemInfo()
                    bio.model = LargeTextModel(text: data.biography ?? "") as AnyObject
                    
                    self?.tableItems.append(pInfo)
                    self?.tableItems.append(username)
                    self?.tableItems.append(follows)
                    self?.tableItems.append(bio)
                    self?.mainTable.reloadData()
                    break
                case.failure(_):
                    break
                }
                
                group.leave()
            }
            
            group.wait()
            
            group.enter()
            
            appContainer.plateRepository.getPlatos(idUser: modelUserId, completionHandler: { (result : ChefieResult<[Plate]>) in
                
                switch result {
                    
                case .success(let data) :
                    
                    let items = data.getFirstElements(upTo: 3)
                    
                    let item = ProfilePlatesCellItemInfo()
                    item.setTitle(value: "Recipes")
                    item.UID = "Recipes"
                    item.model = items as AnyObject
                    
                    self.tableItems.append(item)
                    break
                case .failure(_): break
                }
                
                group.leave()
            })
            
            group.wait()
            
            group.notify(queue: .main, execute: {
                
                self.mainTable.reloadData()
            })
        }
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
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: DefaultFonts.ZapFinoXs]
        onSetup()
        onSetupViews()
        onLoadData()
        
        self.setDefaultBackButton()
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
        ce.setBaseItemInfo(info: cellInfo)
        ce.onLoadData()
        return ce
    }
}
