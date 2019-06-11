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
    
    let labelUsername : UILabel = {
       let lbl = UILabel(maskConstraints: false, font: DefaultFonts.DefaultHeaderTextFont)
        let border = CALayer()
        lbl.text = ""
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.isSkeletonable = true
        lbl.adjustsFontForContentSizeCategory = true
        //lbl.backgroundColor = .red

        //lbl.frame = CGRect(x: 22, y: 40, width: 100, height: 10)
        //lbl.linesCornerRadius = 10
        return lbl
    }()
    
    override func onLayout(size: CGSize!) {
        
        let cellSize = CGSize(width: size.width, height: size.heightPercentageOf(amount: 3))
        
       // let titleFontHeight = max(labelUsername.font.lineHeight, cellSize.height.percentageOf(amount: 5))
        
        labelUsername.snp.makeConstraints { (maker) in
            
          //  maker.leftMargin.equalTo(size.widthPercentageOf(amount: 0))
            maker.topMargin.equalTo(10)
            maker.width.equalTo(cellSize.width)
            //maker.centerXWithinMargins.equalTo(50)
            
          //  maker.left.equalTo(cellSize.widthPercentageOf(amount: 1))
          //  maker.top.equalTo(cellSize.height.percentageOf(amount: 2))
          //  maker.width.equalTo(cellSize.width.minus(amount: 4))
          //  maker.height.equalTo(titleFontHeight)
        }
        
        self.contentView.snp.makeConstraints { (maker) in
            maker.size.equalTo(cellSize)
        }
        
        self.showAnimatedGradientSkeleton()
        
        
    }
    
    override func onLoadData() {
        
        doFadeIn()
        
        self.labelUsername.text = String(describing: self.model?.userName ?? "")
        
        self.hideSkeleton()
        
    }
    
    override func onCreateViews() {
        self.contentView.addSubview(labelUsername)
    }

}

