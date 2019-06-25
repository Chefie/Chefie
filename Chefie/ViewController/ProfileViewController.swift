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
        tableCellRegistrator.add(identifier: LargeTextCellItemInfo().reuseIdentifier(), cellClass: LargeTextCellView.self)
        //////////////////////////////////////////////////////
        tableCellRegistrator.add(identifier: ProfileFollowItemInfo().reuseIdentifier(), cellClass: ProfileFollowCellView.self)
        //////////////////////////////////////////////////////
        tableCellRegistrator.add(identifier: ProfilePlatesCellItemInfo().reuseIdentifier(), cellClass: ProfilePlatesVerticalCell.self)
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
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: DefaultFonts.ZapFinoXs]
        view.backgroundColor = .white
        navigationItem.leftItemsSupplementBackButton = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "notificationicon"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(onGoToNotifications))
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem?.tintColor =  Palette.TextDefaultColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(onGoToSettings))
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.tintColor = Palette.TextDefaultColor
        self.mainTable.setDefaultSettings(shouldBounce: false)
    }
    
    @objc func onGoToNotifications() {
        
        let storyboard = UIStoryboard(name: "NotificationScreen", bundle: nil)
        let vc  : NotificationViewController = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func onGoToSettings() {
        
        let storyboard = UIStoryboard(name: "UpdateProfile", bundle: nil)
        let vc  : UpdateProfileViewController = storyboard.instantiateViewController(withIdentifier: "UpdateProfileStory") as! UpdateProfileViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onLoadData() {
        self.tableItems.removeAll()
        self.model = appContainer.getUser().mapToUserMin()
        
        let userMin = UserMin()
        let userInfo = appContainer.getUser()
        guard let modelUser = model?.id else {
            
            return
        }
        
        let dispatchQueue = DispatchQueue(label: "LoadProfileData", qos: .background)
        dispatchQueue.async{
            
            let group = DispatchGroup()
            
            group.enter()
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
                    
                    let chefieUserInfo = ProfileInfoItemInfo()
                    chefieUserInfo.model = userInfo
                    
                    let username = ProfileUsernameItemInfo()
                    username.model = userMin
                    
                    let follows = ProfileFollowItemInfo()
                    follows.model = userInfo
                    
                    let bio = LargeTextCellItemInfo()
                    bio.model = LargeTextModel(text: data.biography ?? "") as AnyObject
                    
                    self.tableItems.append(pInfo)
                    self.tableItems.append(username)
                    self.tableItems.append(follows)
                    self.tableItems.append(bio)
                    break
                case.failure(_):
                    self.dismiss(animated: true
                        , completion: {
                            
                    })
                    break
                }
                
                group.leave()
            }
            
            group.wait()
            
            group.enter()
            appContainer.plateRepository.getPlatos(idUser: appContainer.getUser().id!, completionHandler: { (result : ChefieResult<[Plate]>) in
                
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
    
    @objc func settings() {
        
        //present(gallery, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onSetup()
        onSetupViews()
        
        tableCellRegistrator.registerAll(tableView: mainTable)
        
        _ = EventContainer.shared.ProfileSubject.subscribe { (event ) in
            
            self.onLoadData()
        }
        
        self.onLoadData()
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
        ce.setBaseItemInfo(info: cellInfo)
        ce.onLoadData()
        return ce
    }
}
