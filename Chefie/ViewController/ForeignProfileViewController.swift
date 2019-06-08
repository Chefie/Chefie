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
    
    @IBOutlet var mainTable: UITableView!{
        didSet {
            mainTable.setCellsToAutomaticDimension()
            mainTable.separatorStyle = UITableViewCell.SeparatorStyle.none
            mainTable.allowsSelection = false
            mainTable.allowsMultipleSelection = false
            mainTable.showsHorizontalScrollIndicator = false
            mainTable.alwaysBounceHorizontal = false
            mainTable.alwaysBounceVertical = false
            mainTable.bounces = false
            
            mainTable.showsVerticalScrollIndicator = false
            mainTable.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
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
    }
    
    func onLoadData() {
        
        let userMin = UserMin()
        
        let userInfo = ChefieUser()
        userMin.profilePic = "https://www.cheftochefconference.com/wp-content/uploads/2018/11/John-Folse-web-300x300.jpg"
        userMin.profileBackground = "https://s3.envato.com/files/253777548/FMX_2289.jpg"
        userMin.userName = "@joseAntonio"
        
        userInfo.followers = 222
        userInfo.following = 333
        
        userInfo.userName = "@joseAntonio"
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
        
        let btnFollow = ProfileBioItemInfo()
        
        
        //Adding to array
        tableItems.append(pInfo)
        tableItems.append(username)
        tableItems.append(follows)
        tableItems.append(btnFollow)
        tableItems.append(bio)
        //tableItems.append(chefieUserInfo)
        
        
        
        
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
        tableCellRegistrator.add(identifier: ProfilePicCellItemInfo().reuseIdentifier(), cellClass: ProfilePicCellView.self)
        /////////////////////////////////////////////////////
        tableCellRegistrator.add(identifier: ProfileUsernameItemInfo().reuseIdentifier(), cellClass: ProfileUsernameCellView.self)
        //////////////////////////////////////////////////////
        tableCellRegistrator.add(identifier: ProfileFollowItemInfo().reuseIdentifier(), cellClass: ProfileFollowCellView.self)
        //////////////////////////////////////////////////////
        tableCellRegistrator.add(identifier: ProfileBioItemInfo().reuseIdentifier(), cellClass: ProfileBioCellView.self)
        //////////////////////////////////////////////////////
//        tableCellRegistrator.add(identifier: PlatosVerticalCellBaseItemInfo().reuseIdentifier(), cellClass: PlatosVerticalCell.self)
//        //////////////////////////////////////////////////////
//        tableCellRegistrator.add(identifier: RoutesVerticalCellBaseItemInfo().reuseIdentifier(), cellClass: RoutesVerticalCell.self)
        
        //////////////////////////////////////////////////////
        tableCellRegistrator.add(identifier: ProfileFollowBtnItemInfo().reuseIdentifier(), cellClass: ProfileFollowCellView.self)
        
        //////////////////////////////////////////////////////
        // tableCellRegistrator.add(identifier: ProfileInfoItemInfo().reuseIdentifier(), cellClass: ProfileInfoCellView.self)
        
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
        tableCellRegistrator.registerAll(tableView: mainTable)
        
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
