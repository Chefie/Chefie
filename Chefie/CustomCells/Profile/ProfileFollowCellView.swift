//
//  ProfileFollowCellView.swift
//  Chefie
//
//  Created by Alex Lin on 28/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
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
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultHeaderTextLightFont)
        let borderColorPalette = UIColor.black
        lbl.textColor = .black
        lbl.text = ""
        lbl.isSkeletonable = true
        lbl.linesCornerRadius = 10
        lbl.numberOfLines = 2
        return lbl
    }()
    
    let labelFollowing : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultHeaderTextLightFont)
        lbl.textColor = .black
        lbl.text = ""
        lbl.isSkeletonable = true
        lbl.linesCornerRadius = 10
        lbl.numberOfLines = 2
        return lbl
    }()
    
    func addRightBorder(color: UIColor, thickness: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: frame.size.width - thickness, y: 0, width: thickness, height: frame.size.height)
        addSubview(border)
    }
    
    override func onLayout(size: CGSize!) {
        
        let cellSize = CGSize(width: size.width, height: size.heightPercentageOf(amount: 8))
        
        labelFollowers.snp.makeConstraints { (maker) in
            maker.leftMargin.equalTo(size.widthPercentageOf(amount: 65))
            maker.width.equalTo(size.widthPercentageOf(amount: 25))
            maker.topMargin.equalTo(20)
            
        }
     
        labelFollowing.snp.makeConstraints { (maker) in
            maker.leftMargin.equalTo(size.widthPercentageOf(amount: 5))
            maker.width.equalTo(size.widthPercentageOf(amount: 25))
            maker.topMargin.equalTo(20)
        }
        
        self.contentView.snp.makeConstraints { (maker) in
            maker.size.equalTo(cellSize)
        }
        
        self.showAnimatedGradientSkeleton()
    }
    
    override func onLoadData() {
        super.onLoadData()
        
        appContainer.userRepository.getUserFollowingCount(userId: model!.id!) { (count) in
            
            self.labelFollowing.text = String("Following\n\(count)")
        }
        
        appContainer.userRepository.getUserFollowersCount(userId: model!.id!) { (count) in
            self.labelFollowers.text = String("Followers\n\(count)")
            
            self.hideSkeleton()
            self.doFadeIn()
        }
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.contentView.addSubview(labelFollowers)
        self.contentView.addSubview(labelFollowing)
    }
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
}
