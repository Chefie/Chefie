//
//  UploadRecipeInfoCellView.swift
//  Chefie
//
//  Created by Nicolae Luchian on 23/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import Kingfisher
import SkeletonView
import SDWebImage

class UploadRecipeCellItemInfo : BaseItemInfo {
    
    override func reuseIdentifier() -> String {
        return "UploadRecipeInfoCellView"
    }
}

class FieldValueData {
    
    var label : String?
    var value : String?
}

class UploadRecipeInfoCellView : BaseCell, ICellDataProtocol{
    
    typealias T = FieldValueData
    var model: FieldValueData?
    
    override func getModel() -> AnyObject? {
        return model
    }
    
    override func setModel(model: AnyObject?) {
        self.model = model as? FieldValueData
    }
    
    let labelTitle : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        //lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.isSkeletonable = true
        lbl.frame = CGRect(x: 22, y: 10, width: 100, height: 10)
        lbl.linesCornerRadius = 10
        return lbl
    }()
    
    let labelValue : UITextField = {
        
        let input = UITextField()
        input.backgroundColor = UIColor.greenSea
        
        //input.translatesAutoresizingMaskIntoConstraints = false
        input.placeholder = " Write the title here: "
        input.setCornerRadius()
        
        return input
    }()
    
    override func onLayout(size : CGSize!) {
        
        let cellSize = CGSize(width: size.width, height: size.heightPercentageOf(amount: 18))
        
        let titleFontHeight = max(labelTitle.font.lineHeight, cellSize.height.percentageOf(amount: 12))
        
        labelTitle.setCornerRadius()
        labelTitle.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(cellSize.widthPercentageOf(amount: 5))
            maker.top.equalTo(cellSize.height.percentageOf(amount: 12))
            maker.width.equalTo(cellSize.width.minus(amount: 4))
            maker.height.equalTo(titleFontHeight)
            maker.bottomMargin.equalToSuperview()
        }
        
        labelValue.layer.borderWidth = 1.0
        labelValue.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(cellSize.widthPercentageOf(amount: 5))
            maker.top.equalTo(titleFontHeight + 30)
            maker.width.equalTo(cellSize.width.minus(amount: 10))
            maker.height.equalTo(cellSize.height - 90)
            maker.bottomMargin.equalToSuperview()
        }
        
        self.contentView.snp.makeConstraints { (maker) in
            
            maker.width.equalTo(cellSize.width)
            maker.height.equalTo(cellSize.height)
        }
    
        self.contentView.backgroundColor = UIColor.white
      //  self.showAnimatedGradientSkeleton()
    }
    
    override func onLoadData() {
        
        doFadeIn()
        
        labelTitle.text = model?.label
        labelValue.text = model?.value
        self.hideSkeleton()
       
    }
    
    override func onCreateViews() {
        
      
        self.contentView.addSubview(labelTitle)
        self.contentView.addSubview(labelValue)
         self.isUserInteractionEnabled = true
        //        frontImageView.setTouch(target: self, selector: #selector(onTouch))
        //        self.label.setTouch(target: self, selector: #selector(onLabelTouch))
    }
}


