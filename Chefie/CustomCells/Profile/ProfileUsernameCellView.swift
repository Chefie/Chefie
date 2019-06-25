//
//  ProfileUsernameCellView.swift
//  Chefie
//
//  Created by Alex Lin on 28/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import SkeletonView
import SDWebImage

class ProfileUsernameItemInfo : BaseItemInfo {
    override func reuseIdentifier() -> String {
        return "ProfileUsernameCellView"
    }
}

class ProfileUsernameCellView : BaseCell, ICellDataProtocol {
    
    typealias T = UserMin
    var model: UserMin?
    
    override func getModel() -> AnyObject? {
        return model
    }
    
    override func setModel(model: AnyObject?) {
        self.model = model as? UserMin
    }
    
    let labelUsername : MultilineLabel = {
       let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultHeaderTextFont)
        lbl.text = ""
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.numberOfLines = 1
        lbl.adjustsFontForContentSizeCategory = true
        return lbl
    }()
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        let cellSize = CGSize(width: size.width, height: size.heightPercentageOf(amount: 5))
        
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(0)
            maker.size.equalTo(cellSize)
        }
        
        labelUsername.snp.makeConstraints { (maker) in
            
            maker.width.equalTo(cellSize.widthPercentageOf(amount: 50))
            maker.height.equalTo(cellSize.height)
            maker.center.equalToSuperview()
        }

        labelUsername.setCornerRadius()
        self.showAnimatedGradientSkeleton() 
    }
    
    override func onLoadData() {
        super.onLoadData()
        
        doFadeIn()
        
        self.labelUsername.text = "@" + String(describing: self.model?.userName ?? "")

        self.hideSkeleton()
    }
    
    override func onCreateViews() {
        self.contentView.addSubview(labelUsername)
    }
}

