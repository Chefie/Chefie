//
//  ProfileFollowCellView.swift
//  Chefie
//
//  Created by Alex Lin on 28/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import SkeletonView
import SDWebImage

class ProfileFollowItemInfo : BaseItemInfo {
    override func reuseIdentifier() -> String {
        return "ProfileFollowItemView"
    }
}

class ProfileFollowCellView : BaseCell, ICellDataProtocol {
    typealias T = ChefieUser
    var model: ChefieUser?
    
    override func getModel() -> AnyObject? {
        return model
    }
    
    override func setModel(model: AnyObject?) {
        self.model = model as? ChefieUser
    }
    
    let labelFollowers : MultilineLabel = {
       let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultTextFont)
        lbl.textColor = .black
        lbl.text = ""
        lbl.isSkeletonable = true
        //lbl.frame = CGRect(x: 22, y: 10, width: 50, height: 20)
        lbl.linesCornerRadius = 10
        lbl.numberOfLines = 2
        return lbl
    }()
    
    let labelFollowing : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultTextFont)
        lbl.textColor = .black
        lbl.text = ""
        lbl.isSkeletonable = true
        //lbl.frame = CGRect(x: 22, y: 10, width: 50, height: 20)
        lbl.linesCornerRadius = 10
        lbl.numberOfLines = 2
        return lbl
    }()
    
    override func onLayout(size: CGSize!) {
        let cellSize = CGSize(width: size.width, height: size.heightPercentageOf(amount: 40))
        
        //let titleFontHeight = max(labelFollowers.font.lineHeight, cellSize.heightPercentageOf(amount: 5))
        
        labelFollowers.snp.makeConstraints { (maker) in
          //  maker.left.equalTo(cellSize.widthPercentageOf(amount: 5))
          //  maker.top.equalTo(cellSize.height.percentageOf(amount: 0))
          //  maker.width.equalTo(cellSize.width.minus(amount: 4))
          //  maker.height.equalTo(titleFontHeight)
            
            maker.leftMargin.equalTo(size.widthPercentageOf(amount: 5))
            maker.topMargin.equalTo(2)
            maker.width.equalTo(size.widthPercentageOf(amount: 20))
            
        }
        
        
        let titleFontHeight2 = max(labelFollowing.font.lineHeight, cellSize.heightPercentageOf(amount: 5))
        
        labelFollowing.snp.makeConstraints { (maker) in
           // maker.left.equalTo(cellSize.widthPercentageOf(amount: 75))
           // maker.top.equalTo(cellSize.height.percentageOf(amount: 0))
           // maker.width.equalTo(cellSize.width.minus(amount: 4))
           // maker.height.equalTo(titleFontHeight2)
            
            maker.right.equalTo(size.widthPercentageOf(amount: -10))
            maker.topMargin.equalTo(2)
            maker.width.equalTo(size.widthPercentageOf(amount: 20))
            
        }
        //labelFollowers.displayLines(height: size.heightPercentageOf(amount: 10))
        //labelFollowing.displayLines(height: size.heightPercentageOf(amount: 10))
        
        self.showAnimatedGradientSkeleton()
        
    }
    
    override func onLoadData() {
        super.onLoadData()
        doFadeIn()
        self.labelFollowers.text = String("Followers\n\(self.model?.followers ?? 0)")
        self.labelFollowing.text = String("Following\n\(self.model?.following ?? 0)")
        self.hideSkeleton()
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        self.contentView.addSubview(labelFollowers)
        self.contentView.addSubview(labelFollowing)
    }
    
    
}
