//
//  CommentCell.swift
//  Chefie
//
//  Created by user155921 on 5/21/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit

class CommentCellInfo : BaseItemInfo{
    
    override func identifier() -> String {
        return "CommentCell"
    }
}

class CommentCell : BaseCell, ICellDataProtocol{
    
    typealias T = Comment
    
    var model: Comment?
    
    let userLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
         lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.text = "Steven"
        lbl.isSkeletonable = true
        lbl.frame = CGRect(x: 50, y: 10, width: 100, height: 10)
        lbl.linesCornerRadius = 10
        lbl.setCornerRadius(radius: 4)
        return lbl
    }()
    
    let contentLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.text = "Item Info"
        lbl.isSkeletonable = true
        lbl.frame = CGRect(x: 50, y: 10, width: 100, height: 10)
        lbl.linesCornerRadius = 10
        return lbl
    }()
    
    override func setModel(model: AnyObject?) {
        self.model = model as? Comment
    }
    
    override func onLayout(size: CGSize!) {

        userLabel.setCornerRadius()
        contentLabel.setCornerRadius(radius: 20)
        
        userLabel.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
        
        userLabel.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(size.widthPercentageOf(amount: 40))
            maker.top.equalTo(10)
        }
        
        contentLabel.numberOfLines = 0
        contentLabel.snp.makeConstraints { (maker) in
            
            maker.topMargin.equalTo(userLabel.font.lineHeight + 10)
            maker.leftMargin.equalTo(10)
            maker.rightMargin.equalToSuperview()
            maker.bottomMargin.equalToSuperview()
        }
        
        doFadeIn()
    }
    
    override func onLoadData() {
        
        userLabel.text = model?.idUser
        contentLabel.text = model?.content
    }
    
    override func onCreateViews() {
        
        self.contentView.addSubview(userLabel)
        self.contentView.addSubview(contentLabel)
    }
}
