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

class ProfileViewController: UIViewController, DynamicViewControllerProto {
    
    var tableItems = Array<BaseItemInfo>()
    var tableCellRegistrator = TableCellRegistrator()
    
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
        
        mainTable.setDefaultSettings(shouldBounce: false)
    }
    
    func onLoadData() {
        
        let userMin = appContainer.getUser().mapToUserMin()

        let userInfo = ChefieUser()
        userInfo.profilePic = userMin.profilePic
        userInfo.profileBackgroundPic = userMin.profileBackground
        userInfo.userName =  userMin.userName
        
        userInfo.followers = 0
        userInfo.following = 0
        
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
 
        //Adding to array
        tableItems.append(pInfo)
        tableItems.append(username)
        tableItems.append(follows)
   
        tableItems.append(bio)
        //tableItems.append(chefieUserInfo)

        mainTable.reloadData()

    }
    
    func onLayout() {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Profile"
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: DefaultFonts.ZapFino]
        view.backgroundColor = .white
        onSetup()
        onSetupViews()
        
        //////////////////////////////////////////////////////
        tableCellRegistrator.add(identifier: ProfilePicCellItemInfo().reuseIdentifier(), cellClass: ProfilePicCellView.self)
        /////////////////////////////////////////////////////
        tableCellRegistrator.add(identifier: ProfileUsernameItemInfo().reuseIdentifier(), cellClass: ProfileUsernameCellView.self)
        //////////////////////////////////////////////////////
        tableCellRegistrator.add(identifier: ProfileFollowItemInfo().reuseIdentifier(), cellClass: ProfileFollowCellView.self)
        //////////////////////////////////////////////////////
        tableCellRegistrator.add(identifier: ProfileBioItemInfo().reuseIdentifier(), cellClass: ProfileBioCellView.self)
        //////////////////////////////////////////////////////
      //   tableCellRegistrator.add(identifier: PlatosVerticalCellBaseItemInfo().reuseIdentifier(), cellClass: PlatosVerticalCell.self)
        //////////////////////////////////////////////////////
        //tableCellRegistrator.add(identifier: RoutesVerticalCellBaseItemInfo().reuseIdentifier(), cellClass: RoutesVerticalCell.self)
        //////////////////////////////////////////////////////
       // tableCellRegistrator.add(identifier: ProfileInfoItemInfo().reuseIdentifier(), cellClass: ProfileInfoCellView.self)
        //////////////////////////////////////////////////////
    
        
        tableCellRegistrator.registerAll(tableView: mainTable)
        appContainer.plateRepository.getPlatos(idUser: "2WT9s7km17QdtIwpYlEZ") { (
            result: ChefieResult<[Plate]>) in
            
            switch result {
                
            case .success(let data):

//                let verticalItemPlateInfo = PlatosVerticalCellBaseItemInfo()
//                verticalItemPlateInfo.setTitle(value: "Plates")
//                verticalItemPlateInfo.model = data as AnyObject
//
//                self.tableItems.append(verticalItemPlateInfo)
//                data.forEach({ (plate) in
//
//                    let cellInfo = PlatoCellItemInfo()
//                    cellInfo.model = plate
//
//                })
//                self.mainTable.reloadData()
                break
            case .failure(_):
                break
            }
        }
        appContainer.userRepository.getUserFollowers(idUser: "2WT9s7km17QdtIwpYlEZ") { (result: (ChefieResult<[UserMin]>)) in
            switch result {
            case .success(_):
                //var followers = [BaseItemInfo]()
                
//                var followersMin = [FollowMin]()
//                followersMin.forEach({ (follower) in
//                    
//                    let followerMin = FollowMin()
//                    followerMin.idFollower = follower.idFollower
//                    followerMin.profilePic = follower.profilePic
//                    followerMin.username = follower.username
//                    followersMin.append(followerMin)
//                    print("Followerss =>\(followerMin)")
//                })
//                
                break
            case .failure(_):
                
                
                break
            }
            
        }

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
