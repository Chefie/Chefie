//
//  ProfilePicsCellView.swift
//  Chefie
//
//  Created by Nicolae Luchian on 22/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import SkeletonView
import SDWebImage
import Gallery

class ProfilePicCellItemInfo : BaseItemInfo {
    
    override func reuseIdentifier() -> String {
        return "ProfilePicCellView"       
    }
}

class ProfilePicCellView : BaseCell, ICellDataProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    typealias T = UserMin
    var model: UserMin?
    var imagePicker = UIImagePickerController()
    let gallery = GalleryController()
    
    override func getModel() -> AnyObject? {
        return model
    }
    
    override func setModel(model: AnyObject?) {
        self.model = model as? UserMin
    }
    
    let backGroundImage : UIImageView = {
        let img = UIImageView(maskConstraints: false)
        img.contentMode = ContentMode.scaleToFill
        return img
    }()
    
    let profilePic : UIImageView = {
        let img = UIImageView(maskConstraints: false)
        img.contentMode = ContentMode.scaleAspectFit
        return img
    }()
    
    let iconChange : UIImageView = {
        let img = UIImageView(maskConstraints: false)
        //img.backgroundColor = .white
        img.image = UIImage(named: "change3")
        img.contentMode = ContentMode.scaleToFill
        return img
    }()
    
    let iconAddRoute : UIImageView = {
        let img = UIImageView(maskConstraints: false)
        //img.backgroundColor = .white
        img.image = UIImage(named: "addRouteIcon")
        img.contentMode = ContentMode.scaleToFill
        return img
    }()
    
    var followBtn : UIButton = {
        var button = UIButton()
        button.contentMode = ContentMode.scaleToFill
        let image = UIImage(named: "followChefie")!.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    override func onLayout(size : CGSize!) {
        
        let cellSize = CGSize(width: size.width, height: size.heightPercentageOf(amount: 35))
        
        self.contentView.snp.makeConstraints { (maker) in
            //backgroundColor = .red
            maker.edges.equalToSuperview()
            maker.left.top.right.bottom.equalTo(0)
            maker.width.equalTo(cellSize.width)
            maker.height.equalTo(cellSize.height)
        }
        
        backGroundImage.snp.makeConstraints { (maker) in
            
            //maker.left.top.right.bottom.equalTo(0)
            maker.width.equalTo(cellSize.width)
            maker.height.equalTo(cellSize.height/1.3)
            //maker.bottomMargin.equalToSuperview()
            
        }
        
        profilePic.setCircularImageView()
        
        //profilePic.addShadow()
        
        profilePic.snp.makeConstraints { (maker) in
            maker.top.equalTo(cellSize.height.percentageOf(amount: 50))
            maker.width.equalTo(cellSize.widthPercentageOf(amount: 40))
            maker.height.equalTo(cellSize.heightPercentageOf(amount: 52))
            maker.leftMargin.equalTo(cellSize.widthPercentageOf(amount: 26))
        }
        
        iconChange.snp.makeConstraints { (maker) in
            maker.top.equalTo(cellSize.height.percentageOf(amount: 90))
            maker.left.equalTo(cellSize.widthPercentageOf(amount: 63))
            maker.width.equalTo(cellSize.widthPercentageOf(amount: 5))
            maker.height.equalTo(cellSize.heightPercentageOf(amount: 6))
        }
        
        iconAddRoute.snp.makeConstraints { (maker) in
            maker.top.equalTo(cellSize.height.percentageOf(amount: 83))
            maker.left.equalTo(cellSize.widthPercentageOf(amount: 12))
            maker.width.equalTo(cellSize.widthPercentageOf(amount: 8.5))
            maker.height.equalTo(cellSize.heightPercentageOf(amount: 11.5))
        }
        
        followBtn.snp.makeConstraints { (maker) in
            
            maker.top.equalTo(cellSize.height.percentageOf(amount: 82))
            maker.left.equalTo(cellSize.widthPercentageOf(amount: 81))
            maker.width.equalTo(cellSize.widthPercentageOf(amount: 10.5))
            maker.height.equalTo(cellSize.heightPercentageOf(amount: 13.5))
        }
        
        iconAddRoute.showAnimatedGradientSkeleton()

        profilePic.setCircularImageView()
        self.showAnimatedGradientSkeleton() 
    }
    
    override func onLoadData() {
        
        if let id = model?.id {
            
            if appContainer.getUser().id != id {
                
                self.iconAddRoute.hide()
            }
        }
        
        appContainer.userRepository.checkIfFollowing(idUser: model!.id!, idFollower: appContainer.dataManager.localData.chefieUser.id!) {
            (result:(ChefieResult<Bool>)) in
            switch result {
            case .success(let data):
                self.changeState(isFollowing: data)
                break
            case .failure(_):
                break
            }
        }
        
        self.backGroundImage.sd_setImage(with: URL(string: model?.profileBackground ?? "")){ (image : UIImage?,
            error : Error?, cacheType : SDImageCacheType, url : URL?) in
        }
        
        self.profilePic.sd_setImage(with: URL(string: self.model?.profilePic ?? "")){ (image : UIImage?,
            error : Error?, cacheType : SDImageCacheType, url : URL?) in
            
        }
        
        self.hideSkeleton()
    }
    
    override func onCreateViews() {
        imagePicker.delegate = self
        self.contentView.addSubview(backGroundImage)
        self.contentView.addSubview(profilePic)
        self.contentView.addSubview(iconChange)
        self.contentView.addSubview(iconAddRoute)
        self.contentView.addSubview(followBtn)
        self.followBtn.setTouch(target: self, selector: #selector(followBtnTapped))
        self.profilePic.setTouch(target: self, selector: #selector(onChangeProfile))
        self.backGroundImage.setTouch(target: self, selector: #selector(onChangeBackground))
        
    }
    
    func changeState(isFollowing : Bool) {
        
        if(isFollowing){
            let image = UIImage(named: "unfollowChefie") as UIImage?
            self.followBtn.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "followChefie") as UIImage?
            self.followBtn.setImage(image, for: .normal)
        }
    }
    
    @objc func followBtnTapped() {
        appContainer.userRepository.checkIfFollowing(idUser: model!.id!, idFollower: appContainer.getUser().id!) {
            (result:(ChefieResult<Bool>)) in
            switch result{
            case .success(let isFollowing):
                if isFollowing {
                    self.unfollowAction()
                    self.rmvFollowing()
                } else {
                    self.followAction()
                    self.addFollowing()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func followAction() {
        let image = UIImage(named: "unfollowChefie") as UIImage?
        self.followBtn.setImage(image, for: .normal)
        appContainer.userRepository.addFollower(idUser: model!.id!, idFollower: appContainer.getUser().id!) {
            (result:(ChefieResult<Bool>)) in
            switch result{
            case .success(let data):
                if data {
                    print("Se ha añadido follower")
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func unfollowAction(){
        let image = UIImage(named: "followChefie") as UIImage?
        self.followBtn.setImage(image, for: .normal)
        appContainer.userRepository.removeFollower(idUser: model!.id!, idFollower: appContainer.getUser().id!) {
            (result: (ChefieResult<Bool>)) in
            switch result{
            case .success(let data):
                if data {
                    print("Se ha borrado follower")
                }
                break
            case .failure(_):
                break
            }
            
        }
    }
    
    func addFollowing(){
        appContainer.userRepository.addFollowing(follower: appContainer.getUser().mapToUserMin(), targetUser: model!) {
            (result: (ChefieResult<Bool>)) in
            switch result{
            case .success(let data):
                if data {
                    print("Se ha añadido following")
                }
                break
            case .failure(_):
                break
                
            }
        }
    }
    
    func rmvFollowing(){
        appContainer.userRepository.removeFollowing(follower: appContainer.getUser().id!, idTargetUser: model!.id!) {
            (result: (ChefieResult<Bool>)) in
            switch result{
            case .success(let data):
                if data {
                    print("Se ha borrado following")
                }
                break
            case .failure(_):
                break
                
            }
        }
    }
    
    var isChangingProfile = false
    
    @objc func onChangeProfile() {
        
        isChangingProfile = true
        
        openGallery()
    }
    
    @objc func onChangeBackground() {
        
        isChangingProfile = false
        
        openGallery()
    }
    @objc func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = true
            viewController?.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            viewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        if (isChangingProfile){
            profilePic.image = image
            appContainer.s3Repository.uploadImage(data: profilePic.image!.rawData()) { (result : Result<S3MediaUploadResult, Error>
                ) in
                
                switch result {
                case .success(let data):
                    
                    let img = appContainer.getUser().mapToUserMin()
                    img.profilePic = data.url
                    appContainer.userRepository.updateUserImageData(userMin: img, completionHandler: { (result:(ChefieResult<Bool>)) in
                        switch result{
                        case .success(let data):
                            if(data) {
                                print("Imagen de perfil updateada correctamente")
                            } else {
                                print("No se ha subido bien")
                            }
                            break
                        case .failure(_):
                            break
                        }
                        
                    })
                    
                    break
                case .failure(let _):
                    print("Fail")
                    break
                }
            }
        }
        
        guard let imageBackground = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        if (!isChangingProfile) {
            backGroundImage.image = imageBackground
            appContainer.s3Repository.uploadImage(data: backGroundImage.image!.rawData()) { (result : Result<S3MediaUploadResult, Error>
                ) in
                switch result {
                case .success(let data):
                    
                    let img = appContainer.getUser().mapToUserMin()
                    img.profileBackground = data.url
                    appContainer.userRepository.updateUserImageData(userMin: img, completionHandler: { (result:(ChefieResult<Bool>)) in
                        switch result{
                        case .success(let data):
                            if(data) {
                                print("Imagen de background updateada correctamente")
                            } else {
                                print("No se ha subido bien")
                            }
                            break
                        case .failure(_):
                            break
                        }
                        
                    })
                    break
                case .failure(let _):
                    print("Fail")
                    break
                }
            }
        }
    }
}


