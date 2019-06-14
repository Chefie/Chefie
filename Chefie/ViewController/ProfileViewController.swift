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
import SkeletonView
import SDWebImage
import CRRefresh

class ProfileViewController: UIViewController, DynamicViewControllerProto {
    
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
        
        //////////////////////////////////////////////////////
        tableCellRegistrator.add(identifier: ProfilePicCellItemInfo().reuseIdentifier(), cellClass: ProfilePicCellView.self)
        /////////////////////////////////////////////////////
        tableCellRegistrator.add(identifier: ProfileUsernameItemInfo().reuseIdentifier(), cellClass: ProfileUsernameCellView.self)
        //////////////////////////////////////////////////////
        tableCellRegistrator.add(identifier: ProfileBioItemInfo().reuseIdentifier(), cellClass: ProfileBioCellView.self)
        //////////////////////////////////////////////////////
        tableCellRegistrator.add(identifier: ProfileFollowItemInfo().reuseIdentifier(), cellClass: ProfileFollowCellView.self)
        //////////////////////////////////////////////////////
    }
    
    func onSetupViews() {
        
        self.mainTable.dataSource = self
        self.mainTable.isSkeletonable = true
        self.mainTable.delegate = self
        
        mainTable.backgroundColor = UIColor.white
        
        mainTable.snp.makeConstraints { (make) in
            
            make.width.equalTo(self.view.getWidth())
            make.height.equalTo(self.view.getHeight())
        }
        
        navigationController?.setTintColor()
  
        navigationItem.title = "Profile"
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: DefaultFonts.ZapFino]
        view.backgroundColor = .white
        navigationItem.leftItemsSupplementBackButton = true
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(close))
        //view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(onGoToSettings))
        self.mainTable.setDefaultSettings(shouldBounce: false)
    }
    
    @objc func onGoToSettings() {
      
        let storyboard = UIStoryboard(name: "UpdateProfile", bundle: nil)
        let vc  : SettingsViewController = storyboard.instantiateViewController(withIdentifier: "UpdateProfileStory") as! SettingsViewController

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onLoadData() {
    
        self.model = appContainer.getUser().mapToUserMin()
        
        let userMin = UserMin()
        let userInfo = appContainer.getUser()
        guard let modelUser = model?.id else {
            dismiss(animated: true) {
                
            }
            return
        }
        
        appContainer.userRepository.getProfileData(idUser: modelUser) { (result:(ChefieResult<ChefieUser>)) in
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
                
                //Model ChefieUser
                let chefieUserInfo = ProfileInfoItemInfo()
                chefieUserInfo.model = userInfo
                
                let username = ProfileUsernameItemInfo()
                username.model = userMin
                
                let follows = ProfileFollowItemInfo()
                follows.model = userInfo
                
                let bio = ProfileBioItemInfo()
                bio.model = userInfo
                
                self.tableItems.removeAll()
                self.tableItems.append(pInfo)
                self.tableItems.append(username)
                self.tableItems.append(follows)
                self.tableItems.append(bio)
                self.mainTable.reloadData()
             
                break
            case.failure(_):
                self.dismiss(animated: true
                    , completion: {
                        
                })
                break
            }
            
            self.mainTable.cr.endHeaderRefresh()
        }
        
        //        appContainer.plateRepository.getPlatos(idUser: modelUser) { (result:(ChefieResult<[Plate]>)) in
        //            switch result {
        //            case.success(let data):
        //
        //                let items = data.compactMap({ (plate) -> HomePlatoCellItemInfo? in
        //                    let item = HomePlatoCellItemInfo()
        //                    item.model = plate
        //                    return item
        //
        //
        //                })
        //                items.forEach({ (item) in
        //                    self.tableItems.append(item)
        //                })
        //                break
        //            case.failure(_):
        //                break
        //            }
        //        }
    }
    
    func onLayout() {
        
    }
    
    @objc func settings() {
        
        //present(gallery, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onSetup()
        onSetupViews()
        
        tableCellRegistrator.registerAll(tableView: mainTable)
        
        mainTable.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            
            self?.onLoadData()
        }
       
        self.mainTable.cr.beginHeaderRefresh()
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
