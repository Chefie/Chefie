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
import Kingfisher
import SkeletonView
import SDWebImage



class ProfilePicCellItemInfo : BaseItemInfo {
    
    override func reuseIdentifier() -> String {
        return "ProfilePicCellView"
        
    }
    
}



class ProfilePicCellView : BaseCell, ICellDataProtocol{
    
    typealias T = UserMin
    var model: UserMin?
    
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
    
    
    
    let buttonUpload: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "addButton") as UIImage?
        //button.backgroundColor = UIColor.green
        button.contentMode = ContentMode.scaleToFill
        button.setTitle("Upload recipe", for: .normal)
        button.setImage(image, for: .normal)
        //button.setTouch(target: self, selector: #selector(buttonAction))
        return button
        
    }()
    
    
    
    override func onLayout(size : CGSize!) {
        
        let cellSize = CGSize(width: size.width, height: size.heightPercentageOf(amount: 35))
        
        self.contentView.snp.makeConstraints { (maker) in
            
            maker.edges.equalToSuperview()
            maker.left.top.right.bottom.equalTo(0)
            maker.width.equalTo(cellSize.width)
            maker.height.equalTo(cellSize.height)
            
        }
        
        
        
        backGroundImage.snp.makeConstraints { (maker) in
            
            maker.left.top.right.bottom.equalTo(0)
            maker.width.equalTo(cellSize.width)
            maker.height.equalTo(cellSize.height)
            maker.bottomMargin.equalToSuperview()
            
        }
        
        
        
        //profilePic.setCornerRadius()
        
        
        
        //profilePic.addShadow()
        
        profilePic.snp.makeConstraints { (maker) in
            
            maker.width.equalTo(cellSize.widthPercentageOf(amount: 36))
            maker.height.equalTo(cellSize.heightPercentageOf(amount: 42))
            //     maker.left.top.right.bottom.equalTo(0)
            //   maker.bottomMargin.equalToSuperview()
            maker.center.equalToSuperview()
            
        }
        
        
        
        buttonUpload.addShadow()
        
        buttonUpload.snp.makeConstraints { (maker) in
            
            maker.width.equalTo(cellSize.widthPercentageOf(amount: 32))
            maker.height.equalTo(cellSize.heightPercentageOf(amount: 20))
            maker.top.rightMargin.equalToSuperview()
        }
        
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
        
        
        // self.showAnimatedGradientSkeleton()
        
        
        
    }
    
    
    
    override func onLoadData() {
        
        self.backGroundImage.sd_setImage(with: URL(string: model?.profileBackground ?? "")){ (image : UIImage?,
            error : Error?, cacheType : SDImageCacheType, url : URL?) in
            
            self.profilePic.sd_setImage(with: URL(string: self.model?.profilePic ?? "")){ (image : UIImage?,
                error : Error?, cacheType : SDImageCacheType, url : URL?) in
                self.hideSkeleton()
            }
            
        }
        
    }
    
    
    
    override func onCreateViews() {
        self.contentView.addSubview(backGroundImage)
        self.contentView.addSubview(profilePic)
        self.contentView.addSubview(buttonUpload)
        
        //self.isUserInteractionEnabled = true
        
        self.buttonUpload.setTouch(target: self, selector: #selector(buttonAction))
        
    }
    
    @objc func buttonAction() {

        print("*********VAMOS AL SETTINGS")
        let storyboard = UIStoryboard(name: "UpdateProfile", bundle: nil)
        let vc  : UpdateProfileViewController = storyboard.instantiateViewController(withIdentifier: "UpdateProfileStory") as! UpdateProfileViewController

        self.viewController?.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


