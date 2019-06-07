//
//  ProfileBioCellView.swift
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

class ProfileBioItemInfo : BaseItemInfo {
    override func reuseIdentifier() -> String {
        return "ProfileBioItemView"
    }
}

class ProfileBioCellView : BaseCell, ICellDataProtocol {
    
    typealias T = ChefieUser
    var model: ChefieUser?
    
    override func getModel() -> AnyObject? {
        return model
    }
    override func setModel(model: AnyObject?) {
        super.setModel(model: AnyObject?.self as AnyObject)
        self.model = model as? ChefieUser
    }
    
    let labelBio : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultTextLightFont)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.sizeToFit()
        lbl.textAlignment = .left
        
        //lbl.isSkeletonable = true
        //lbl.linesCornerRadius = 10
       
        //lbl.frame = CGRect(x: 22, y: 40, width: 100, height: 20)
        
       
        return lbl
    }()
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        //let cellSize = CGSize(width: size.width, height: size.heightPercentageOf(amount: CGFloat(labelBio.numberOfLines)))
        
        let cellSize2 = CGSize(width: size.width, height: size.heightPercentageOf(amount: 40))
        
        labelBio.snp.makeConstraints { (maker) in
            //maker.leftMargin.equalTo(size.widthPercentageOf(amount: 0))
            //maker.topMargin.equalTo(2)
             maker.leftMargin.equalTo(1.5)
            maker.rightMargin.equalTo(1.5)
            maker.width.equalTo(cellSize2.width)
            //maker.height.equalTo(40)
        }
        
        labelBio.displayLines(height: 200)
        
        self.showGradientSkeleton()
    }
    
    override func onLoadData() {
        super.onLoadData()
        doFadeIn()
        
        
        self.labelBio.text = String("\(self.model?.biography ?? "")")
        
       
        contentView.snp.makeConstraints { (maker) in
           
            maker.topMargin.bottomMargin.equalTo(2)
           
            maker.width.equalTo(parentView.getWidth())
            maker.height.equalTo(labelBio.calculateTextHeight() + 55)
           // maker.height.equalTo(40)
        }
        
        //self.backgroundColor = UIColor.red
        labelBio.restore()
        self.hideSkeleton()
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        self.contentView.addSubview(labelBio)
    }
    
    
    
    
}
