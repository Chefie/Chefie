//
//  CommentCell.swift
//  Chefie
//
//  Created by user155921 on 5/21/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class CommentCellInfo : BaseItemInfo{
    
    override func reuseIdentifier() -> String {
        return "CommentCell"
    }
}

class CommentCell : BaseCell, ICellDataProtocol{
    
    typealias T = Comment
    
    var model: Comment?
    
    let userLabel : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false)
        lbl.text = ""
        lbl.numberOfLines = 1
        return lbl
    }()
    
    let contentLabel : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false)
        return lbl
    }()
    
    override func setModel(model: AnyObject?) {
        self.model = model as? Comment
    }
    var topConstraint: Constraint? = nil
    override func onLayout(size: CGSize!) {
        
        userLabel.setCornerRadius()
        contentLabel.setCornerRadius(radius: 20)
        
        userLabel.snp.makeConstraints { (maker) in
            
            maker.leftMargin.equalTo(size.widthPercentageOf(amount: 40))
            maker.topMargin.equalTo(10)
            maker.width.equalTo(size.widthPercentageOf(amount: 20))
        }
        
        userLabel.displayLines(height: userLabel.font.lineHeight)
        
        contentLabel.snp.makeConstraints { (maker) in
            
            maker.topMargin.equalTo(userLabel.font.lineHeight + 10)
            maker.left.equalTo(size.widthPercentageOf(amount: 1))
            maker.rightMargin.bottomMargin.equalTo(0)
            maker.width.equalTo(size.width.margin(amount: 0.5))
        }
        
        contentLabel.displayLines(height: size.heightPercentageOf(amount: 10))
        self.showAnimatedGradientSkeleton()
    }
    
    override func onLoadData() {
        
        doFadeIn()
        
        userLabel.text = model?.idUser
        contentLabel.text = model?.content
        contentLabel.hideLines()
        
        self.hideSkeleton()
    }
    
    override func onCreateViews() {
        
        self.contentView.addSubview(userLabel)
        self.contentView.addSubview(contentLabel)
        
    }
}


