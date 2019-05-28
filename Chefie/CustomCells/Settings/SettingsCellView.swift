//
//  SettingsCellView.swift
//  Chefie
//
//  Created by Edgar Doutón Parra on 23/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import SkeletonView
import SDWebImage

class FieldCellItemInfo : BaseItemInfo {
    
    override func uniqueIdentifier() -> String {
        return "FieldCellView"
    }
}

class FieldCellView: BaseCell, ICellDataProtocol {
    var model: FieldValueInfo?
    
    typealias T = FieldValueInfo
    
    let label : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false)
        lbl.text = ""
        return lbl
    }()
    
    
    let textField : UITextField = {
        
        let textField = UITextField(maskConstraints: false)
        textField.text = ""
        return textField
    }()

    override func onLayout(size: CGSize!) {
        
            let cellSize = CGSize(width: size.width, height: size.heightPercentageOf(amount: 20))
        
        label.setCornerRadius()
        label.snp.makeConstraints { (maker) in
            
       
            maker.left.equalTo(cellSize.widthPercentageOf(amount: 2))
            maker.top.equalTo(cellSize.height.percentageOf(amount: 2))
            maker.width.equalTo(cellSize.width.minus(amount: 4))
        }
        
        
        textField.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(cellSize.widthPercentageOf(amount: 2))
            maker.top.equalTo(label.calculateTextHeight())
            maker.width.equalTo(cellSize.width.minus(amount: 4))
        }
    }
    
    override func getModel() -> AnyObject? {
        return model
    }
    
    override func setModel(model: AnyObject?) {
        self.model = model as? FieldValueInfo
    }
    
    override func onLoadData() {
        
        label.text = model?.label
        
        textField.text = model?.value
    }
  
    override func onCreateViews() {
        
        self.contentView.addSubview(label)
          self.contentView.addSubview(textField)
    }
    
    
}

class FieldValueInfo {
    
    var label : String?
    var value : String?
}
