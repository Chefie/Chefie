//
//  HeaderTextCellView.swift
//  Chefie
//
//  Created by Nicolae Luchian on 05/06/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit

struct HeaderTextModel {
    var title : String?
}

class HeaderTextCellItemInfo : BaseItemInfo {
    
    override func reuseIdentifier() -> String {
        return "HeaderTextCellView"
    }
}

class HeaderTextCellView : BaseCell, ICellDataProtocol {
    var model: HeaderTextModel?
    
    typealias T = HeaderTextModel
    
    let lblHeader : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultHeaderTextFont)
        lbl.text = ""
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        return lbl
    }()
    
    override func setModel(model: AnyObject?) {
        self.model = (model as! HeaderTextModel)
    }
    
    override func getModel() -> AnyObject? {
        return model as AnyObject?
    }
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        
        lblHeader.snp.makeConstraints { (maker) in
            
            maker.topMargin.equalTo(0)
            maker.left.equalTo(size.widthPercentageOf(amount: 3))
            maker.rightMargin.bottomMargin.equalTo(0)
            maker.width.equalTo(size.width.margin(amount: 0.5))
        }
        
       // self.backgroundColor = UIColor.red
    }
    
    override func onLoadData() {
        super.onLoadData()

        lblHeader.text = model?.title
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        
        contentView.addSubview(lblHeader)
    }
}
