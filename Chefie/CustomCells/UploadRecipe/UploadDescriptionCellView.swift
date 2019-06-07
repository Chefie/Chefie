//
//  UploadDescriptionCellView.swift
//  Chefie
//
//  Created by Nicolae Luchian on 24/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import SkeletonView
import SDWebImage

class UploadDescriptionCellItemInfo : BaseItemInfo {
    
    override func reuseIdentifier() -> String {
        return "UploadDescriptionCellView"
    }
}

class UploadDescriptionCellView : BaseCell, ICellDataProtocol{
    
    typealias T = Plate
    var model: Plate?
    
    override func getModel() -> AnyObject? {
        return model
    }
    
    override func setModel(model: AnyObject?) {
        self.model = model as? Plate
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
    
    let labelValue : UITextView = {
        
        let input = UITextView()
        input.backgroundColor = UIColor.greenSea
        //input.translatesAutoresizingMaskIntoConstraints = false
        //input.text = " Write the description here: "
        input.setCornerRadius()
        
        return input
    }()
    
    override func onLayout(size : CGSize!) {
        
        let cellSize = CGSize(width: size.width, height: size.heightPercentageOf(amount: 15))
        
        let titleFontHeight = max(labelTitle.font.lineHeight, cellSize.height.percentageOf(amount: 12))
        
        labelTitle.setCornerRadius()
        labelTitle.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(cellSize.widthPercentageOf(amount: 5))
            maker.top.equalTo(cellSize.height.percentageOf(amount: 12))
            maker.width.equalTo(cellSize.width.minus(amount: 4))
            maker.height.equalTo(titleFontHeight + 5)
            maker.bottomMargin.equalToSuperview()
        }
        
        labelValue.layer.borderWidth = 1.0
        labelValue.textColor = UIColor.gray
        labelValue.font = .systemFont(ofSize: 16)
        labelValue.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(cellSize.widthPercentageOf(amount: 5))
            maker.top.equalTo(titleFontHeight + 30)
            maker.width.equalTo(cellSize.width.minus(amount: 10))
            maker.height.equalTo(cellSize.height - 50)
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
        
        labelTitle.text = model?.title
        labelValue.text = model?.description
        self.hideSkeleton()
        
    }
    
    override func onCreateViews() {
    
        self.contentView.addSubview(labelTitle)
        self.contentView.addSubview(labelValue)
        self.isUserInteractionEnabled = true
        
        self.labelValue.setTouch(target: self, selector: #selector(labelValueAction))
        
    
    }
    
    @objc func labelValueAction() {
        
      //  labelValue.gestureRecognizers?.removeAll()
        labelValue.text = ""
        labelValue.textColor = UIColor.black
        labelValue.font = .systemFont(ofSize: 16)
        
        self.labelValue.updateFocusIfNeeded()
        self.updateFocusIfNeeded()
        
       // self.labelValue.touch
    }
}



