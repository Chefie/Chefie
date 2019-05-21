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
    
    override func identifier() -> String {
        return "CommentCell"
    }
}

class CommentCell : BaseCell, ICellDataProtocol{
    
    typealias T = Comment
    
    var model: Comment?
    
    let userLabel : UILabel = {
        let lbl = UILabel(maskConstraints: false)
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.isSkeletonable = true
        lbl.linesCornerRadius = 10
        lbl.frame = CGRect(x: 0, y: 0, width: 200, height: 60)
        lbl.setCornerRadius(radius: 4)
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
        
        // userLabel.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
        
        userLabel.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(size.widthPercentageOf(amount: 40))
            maker.top.equalTo(10)
            maker.width.equalTo(size.widthPercentageOf(amount: 20))
            //  maker.height.equalTo(userLabel.font.lineHeight)
        }
        contentLabel.snp.makeConstraints { (maker) in
            
           maker.topMargin.equalTo(userLabel.font.lineHeight + 10)
           maker.leftMargin.equalTo(10)
           maker.rightMargin.bottomMargin.equalToSuperview()
           maker.width.equalTo(size.widthPercentageOf(amount: 90))
        }
   
        contentLabel.displayLines(height: size.heightPercentageOf(amount: 10))


        //    userLabel.text = "User"
        //  contentLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book"
        
        
        self.showAnimatedGradientSkeleton()
        //   userLabel.text = ""
        // contentLabel.text = ""
    }
    
    override func onLoadData() {
        
        doFadeIn()
        
        userLabel.text = model?.idUser
        contentLabel.text = model?.content
        contentLabel.deactivate()
     
       self.hideSkeleton()
    }
    
    override func onCreateViews() {
        
        self.contentView.addSubview(userLabel)
        self.contentView.addSubview(contentLabel)
        
    }
}


