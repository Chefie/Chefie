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
        img.contentMode = ContentMode.scaleToFill
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
        let image = UIImage(named: "followChefie") as UIImage?
        button.setImage(image, for: .normal)
        return button
    }()
    
    
    
//    let buttonUpload: UIButton = {
//        let button = UIButton()
//        let image = UIImage(named: "addButton") as UIImage?
//        //button.backgroundColor = UIColor.green
//        button.contentMode = ContentMode.scaleToFill
//        button.setTitle("Upload recipe", for: .normal)
//        button.setImage(image, for: .normal)
//        //button.setTouch(target: self, selector: #selector(buttonAction))
//        return button
//
//    }()
    
    
    
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
            //     maker.left.top.right.bottom.equalTo(0)
            //   maker.bottomMargin.equalToSuperview()
            //maker.bottomMargin.equalTo(cellSize.height.percentageOf(amount: 150))
            //maker.center.equalToSuperview()
//            maker.left.equalTo(cellSize.widthPercentageOf(amount: 31))
            
             maker.leftMargin.equalTo(cellSize.widthPercentageOf(amount: 26))
        }
        
        iconChange.snp.makeConstraints { (maker) in
            maker.top.equalTo(cellSize.height.percentageOf(amount: 90))
            maker.left.equalTo(cellSize.widthPercentageOf(amount: 63))
            maker.width.equalTo(cellSize.widthPercentageOf(amount: 5))
            maker.height.equalTo(cellSize.heightPercentageOf(amount: 6))
        }
        
        iconAddRoute.snp.makeConstraints { (maker) in
            maker.top.equalTo(cellSize.height.percentageOf(amount: 82))
            maker.left.equalTo(cellSize.widthPercentageOf(amount: 12))
            maker.width.equalTo(cellSize.widthPercentageOf(amount: 7))
            maker.height.equalTo(cellSize.heightPercentageOf(amount: 10))
        }
        
        followBtn.snp.makeConstraints { (maker) in
            
            maker.top.equalTo(cellSize.height.percentageOf(amount: 82))
            maker.left.equalTo(cellSize.widthPercentageOf(amount: 81))
            maker.width.equalTo(cellSize.widthPercentageOf(amount: 9))
            maker.height.equalTo(cellSize.heightPercentageOf(amount: 12))
        }
        
        
        //buttonUpload.addShadow()
        
//        buttonUpload.snp.makeConstraints { (maker) in
//
//            maker.width.equalTo(cellSize.widthPercentageOf(amount: 32))
//            maker.height.equalTo(cellSize.heightPercentageOf(amount: 20))
//            maker.top.rightMargin.equalToSuperview()
//        }
        
        //    profilePic.frame = CGRect(x: 20, y: 20, width: cellSize.widthPercentageOf(amount: 20), height: cellSize.heightPercentageOf(amount: 18))
        
        
        
        layoutIfNeeded()
        
        
        
        profilePic.setCircularImageView()
        
        
        //   profilePic.backgroundColor = UIColor.yellow
        //Trying to make a rounded profile Pic
        
        //profilePic.setCircularImageView()
        //profilePic.layer.cornerRadius = profilePic.frame.height/2
        //profilePic.layer.borderWidth = 1
        //profilePic.layer.borderColor = UIColor.black.cgColor
        //profilePic.layer.masksToBounds = false
        //profilePic.clipsToBounds = true
        
        
        self.showAnimatedGradientSkeleton()
        
        
        
    }
    
    override func onLoadData() {
        
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
        //self.contentView.addSubview(buttonUpload)
        self.contentView.addSubview(iconChange)
        self.contentView.addSubview(iconAddRoute)
        self.contentView.addSubview(followBtn)
        //self.isUserInteractionEnabled = true
        
        self.profilePic.setTouch(target: self, selector: #selector(onChangeProfile))
        self.backGroundImage.setTouch(target: self, selector: #selector(onChangeBackground))
        
    }
    
//    @objc func buttonAction() {
//
//        print("*********VAMOS AL SETTINGS")
//        let storyboard = UIStoryboard(name: "UpdateProfile", bundle: nil)
//        let vc  : UpdateProfileViewController = storyboard.instantiateViewController(withIdentifier: "UpdateProfileStory") as! UpdateProfileViewController
//
//        self.viewController?.navigationController?.pushViewController(vc, animated: true)
//
//    }
    
    
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
        }
       
       
        guard let imageBackground = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        if (!isChangingProfile) {
            backGroundImage.image = imageBackground
        }
        
        
//        appContainer.s3Repository.uploadImage(data: profilePic.image!.rawData()) { (result : Result<S3MediaUploadResult, Error>
//            ) in
//
//
//            switch result {
//            case .success(let data):
//
//                print("Uploaded")
//                break
//            case .failure(let error):
//                print("Fail")
//                break
//            }
//
//
//
//        }
    }
}


