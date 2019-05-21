//
//  MediaCellView.swift
//  Chefie
//
//  Created by user155921 on 5/21/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit

class MediaCellItemInfo : BaseItemInfo {
    
    override func identifier() -> String {
        return "MediaCellView"
    }
}

class MediaCellView : BaseCell, ICellDataProtocol {
    var model: Media?
    
    typealias T = Media
    
    override func getModel() -> AnyObject? {
        return model
    }
    
    override func setModel(model: AnyObject?) {
        self.model = model as? Media
    }
    
    let label : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.text = "Item Info"
        lbl.isSkeletonable = true
        lbl.frame = CGRect(x: 50, y: 10, width: 100, height: 10)
        lbl.linesCornerRadius = 10
        return lbl
    }()
    
    override func getSize() -> CGSize {
        
        return CGSize(width: self.parentView.frame.width, height: self.parentView.heightPercentageOf(amount: 20))
    }
    
    override func onLayout(size: CGSize!) {
        
        label.setCornerRadius()
        label.snp.makeConstraints { (maker) in
         
            maker.topMargin.equalToSuperview()
            maker.bottomMargin.equalToSuperview()
        }
        
        
    }
    
    override func onLoadData() {
        
    }
    
    override func onCreateViews() {
        self.contentView.addSubview(label)
    }
}
