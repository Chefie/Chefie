//
//  LargeTextCellView.swift
//  Chefie
//
//  Created by Nicolae Luchian on 05/06/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit

struct LargeTextModel {
    var text : String?
}

class LargeTextCellItemInfo : BaseItemInfo {
    
    override func reuseIdentifier() -> String {
        return "LargeTextCellView"
    }
    
    var alignment : NSTextAlignment = .center
}

class LargeTextCellView : BaseCell, ICellDataProtocol {

    var model: LargeTextModel?
    
    typealias T = LargeTextModel
    
    let lblContent : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultTextFont)
        lbl.text = ""
        lbl.textAlignment = .center
        return lbl
    }()
    
    override func setModel(model: AnyObject?) {
        self.model = (model as! LargeTextModel)
    }
    
    override func getModel() -> AnyObject? {
        return model as AnyObject?
    }
    
    override func getSize() -> CGSize {
        return CGSize(width: parentView.getWidth(), height: parentView.heightPercentageOf(amount: 20))
    }
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
  
        lblContent.snp.makeConstraints { (maker) in
            
            maker.topMargin.equalTo(2)
            maker.left.equalTo(size.widthPercentageOf(amount: 1))
            maker.rightMargin.bottomMargin.equalTo(0)
            maker.width.equalTo(size.width.margin(amount: 0.5))
        }

        lblContent.displayLines(height: size.heightPercentageOf(amount: 10))

        //self.backgroundColor = UIColor.purple
    }
    
    override func setBaseItemInfo(info: BaseItemInfo) {
        super.setBaseItemInfo(info: info)
        
        guard let itemInfo = info as? LargeTextCellItemInfo else {
            return
        }
        
        lblContent.textAlignment = itemInfo.alignment
    }
    
    override func onLoadData() {
        super.onLoadData()
 

        lblContent.text = model?.text
        lblContent.hideLines()
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        
        contentView.addSubview(lblContent)
    
        lblContent.setTouch(target: self, selector: #selector(onTouchContent))
    }
    
    @objc func onTouchContent() {

//         let newHeight = lblContent.text?.height(withConstrainedWidth: parentView.getWidth(), font: lblContent.font) ?? 0
//        self.contentView.snp.remakeConstraints { (maker) in
//            maker.left.top.right.bottom.equalTo(0)
//            maker.edges.equalToSuperview()
//            maker.width.equalTo(parentView.getWidth())
//            maker.height.equalTo(newHeight)
//        }
//
//        lblContent.snp.remakeConstraints { (maker) in
//
//            maker.height.equalTo(newHeight)
//        }
//
//        let table = parentView as! UITableView
//        table.reloadRows(at: [IndexPath(row: index ?? 0, section: 0)], with: .none)
    }
}
