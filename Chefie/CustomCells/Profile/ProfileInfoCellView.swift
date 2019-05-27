//
//  ProfileInfoCellView.swift
//  Chefie
//
//  Created by Nicolae Luchian on 22/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import Foundation
import Foundation
import UIKit
import Kingfisher
import SkeletonView
import SDWebImage

class ProfileInfoItemInfo : BaseItemInfo {
    
    override func identifier() -> String {
        return "ProfileInfoCellView"
    }
}

class ProfileInfoCellView : BaseCell, ICellDataProtocol{

    typealias T = ChefieUser
    var model: ChefieUser?
    
    
    override func getModel() -> AnyObject? {
        return model
    }
    
    override func setModel(model: AnyObject?) {
        self.model = model as? ChefieUser
    }
    
    let labelFollowers : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        //lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.text = ""
        lbl.isSkeletonable = true
        lbl.frame = CGRect(x: 22, y: 10, width: 100, height: 10)
        lbl.linesCornerRadius = 10
        return lbl
    }()
    
    let labelFollowing : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        //lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.text = ""
        lbl.isSkeletonable = true
        lbl.frame = CGRect(x: 22, y: 10, width: 100, height: 10)
        lbl.linesCornerRadius = 10
        return lbl
    }()
    
    let labelUsername : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.text = ""
        lbl.isSkeletonable = true
        lbl.frame = CGRect(x: 22, y: 40, width: 100, height: 10)
        lbl.linesCornerRadius = 10
        return lbl
    }()
    
    let labelBio : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.italicSystemFont(ofSize: 16)
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.text = ""
        lbl.isSkeletonable = true
        lbl.frame = CGRect(x: 22, y: 40, width: 100, height: 10)
        lbl.linesCornerRadius = 10
        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl.numberOfLines = 0
        lbl.sizeToFit()
        return lbl
        
    }()
    
    
    override func onLayout(size : CGSize!) {
        
        let cellSize = CGSize(width: size.width, height: size.heightPercentageOf(amount: 30))
        
        let titleFontHeight = max(labelFollowers.font.lineHeight, cellSize.height.percentageOf(amount: 15))
      
        labelFollowers.setCornerRadius()
        labelFollowers.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(cellSize.widthPercentageOf(amount: 5))
            maker.top.equalTo(cellSize.height.percentageOf(amount: 12))
            maker.width.equalTo(cellSize.width.minus(amount: 4))
            maker.height.equalTo(titleFontHeight)
        }
        
        let titleFontHeight2 = max(labelFollowing.font.lineHeight, cellSize.height.percentageOf(amount: 15))
        
        
        labelFollowing.setCornerRadius()
        labelFollowing.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(cellSize.widthPercentageOf(amount: 50))
            maker.top.equalTo(cellSize.height.percentageOf(amount: 12))
            maker.width.equalTo(cellSize.width.minus(amount: 4))
            maker.height.equalTo(titleFontHeight2)
        }
        
        let titleFontHeight3 = max(labelUsername.font.lineHeight, cellSize.height.percentageOf(amount: 15))
        
        
        labelUsername.setCornerRadius()
        labelUsername.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(cellSize.widthPercentageOf(amount: 5))
            maker.top.equalTo(cellSize.height.percentageOf(amount: 2))
            maker.width.equalTo(cellSize.width.minus(amount: 4))
            maker.height.equalTo(titleFontHeight3)
        }
        
        let titleFontHeight4 = max(labelBio.font.lineHeight, cellSize.height.percentageOf(amount: 15))
        
        
        labelBio.setCornerRadius()
        labelBio.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(cellSize.widthPercentageOf(amount: 5))
            maker.top.equalTo(cellSize.height.percentageOf(amount: 20))
            maker.width.equalTo(cellSize.width.minus(amount: 4))
            maker.height.equalTo(titleFontHeight4)
        }
        
        self.showAnimatedGradientSkeleton()
    }
    
    override func onLoadData() {
        
        doFadeIn()

        self.labelFollowers.text = String("Followers:\(self.model?.followers)")
        self.labelFollowing.text = String("Following:\(self.model?.following)")
        self.labelUsername.text = String(describing: self.model?.userName)
        self.labelBio.text = String(describing: self.model?.biography)
        
        self.hideSkeleton()
    }
    
    
    override func onCreateViews() {
        
        self.contentView.addSubview(labelFollowers)
        self.contentView.addSubview(labelFollowing)
        self.contentView.addSubview(labelUsername)
        self.contentView.addSubview(labelBio)
        //        frontImageView.setTouch(target: self, selector: #selector(onTouch))
        //        self.label.setTouch(target: self, selector: #selector(onLabelTouch))
    }
}

