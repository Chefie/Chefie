//
//  PlateInfoCell.swift
//  Chefie
//
//  Created by Nicolae Luchian on 04/06/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

class PlateInfoCellItemInfo : BaseItemInfo {
    
    override func reuseIdentifier() -> String {
        return "PlatoCellView"
    }
}

class PlateInfoCell : BaseCell, ICellDataProtocol{
    var model: Plate?
    
    typealias T = Plate
    
    let picInfoDate : UIImageView = {
       
        let pic = UIImageView(maskConstraints: false)
        pic.image = UIImage(named: "date")
        pic.tintColor = AppSettings.LightColor
        return pic
    }()
    
    let lblInfoDate : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultTextFont)
        lbl.text = ""
        lbl.numberOfLines = 1
        return lbl
    }()
    
    let picInfoUser : UIImageView = {
        
        let pic = UIImageView(maskConstraints: false)
        pic.image = UIImage(named: "user")!.withRenderingMode(.alwaysTemplate)
        pic.tintColor = AppSettings.LightColor
        return pic
    }()
    
    let lblInfoUser : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultTextFont)
        lbl.text = ""
        lbl.numberOfLines = 1
        return lbl
    }()

    override func setModel(model: AnyObject?) {
        self.model = (model as! Plate)
    }
    
    override func getModel() -> AnyObject? {
        return model
    }

    override func getSize() -> CGSize {
        return CGSize(width: parentView.getWidth(), height: parentView.heightPercentageOf(amount: 10))
    }
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        
        let cellSize = getSize()
        
        let iconWidth = cellSize.widthPercentageOf(amount: 5)
        let itemHeight = cellSize.height / 2
        let iconHeight = itemHeight / 2
        
        let leftMargin = CGFloat(20)
        let topMargin = CGFloat(10)
      //  self.backgroundColor = UIColor.purple
        
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(0)
            maker.edges.equalToSuperview()
            maker.size.equalTo(cellSize)
        }
        
        self.picInfoDate.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(10)
            maker.top.equalTo(topMargin)
            maker.width.equalTo(iconWidth)
            maker.height.equalTo(iconHeight)
        }
        
        self.lblInfoDate.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(iconWidth + leftMargin)
            maker.top.equalTo(0)
            maker.height.equalTo(itemHeight)
        }
        
        self.picInfoUser.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(10)
            maker.top.equalTo(itemHeight + topMargin)
            maker.width.equalTo(iconWidth)
            maker.height.equalTo(iconHeight)
        }
        
        self.lblInfoUser.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(iconWidth + leftMargin)
            maker.top.equalTo(itemHeight)
            maker.height.equalTo(itemHeight)
        }
        
        self.showAnimatedGradientSkeleton()
      //  lblInfoDate.backgroundColor = UIColor.red
    }
    
    override func onLoadData() {
        super.onLoadData()
        
        lblInfoUser.text = model?.user?.userName
        
        if let parsed = model?.created_at?.parseToDate(){
            
             lblInfoDate.text = model?.created_at?.extractInfoFromDate(date: parsed)
        }
     
        self.hideSkeleton()
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        
        contentView.addSubview(picInfoDate)
        contentView.addSubview(lblInfoDate)
        
        contentView.addSubview(picInfoUser)
        contentView.addSubview(lblInfoUser)
    }
}
