//
//  BaseCollectionCell.swift
//  Chefie
//
//  Created by user155921 on 5/22/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
class BaseCollectionCell : UICollectionViewCell, IDynamicCellProtocol{
  
    var baseItemInfo : BaseItemInfo?
    
    func cellReuseIdentifier() -> String {
        return ""
    }
    
    func doCellFadeIn() {
        
       self.contentView.doFadeIn()
    }
    
    func setBaseItemInfo(info : BaseItemInfo){
        
        self.baseItemInfo = info
    }
    
    func cellUUID() -> String {
        return ""
    }
  
    var viewController : UIViewController?
    
    func cellIdentifier() -> String {
        return "BaseCollectionCell"
    }
    
    var parentView : UIView! {
        
        didSet{
            
            let size = CGSize(width: self.parentView.frame.width, height: self.parentView.frame.height)
            onLayout(size: size)
        }
    }
    
    func onLayout(size: CGSize!) {
        
    }
    
    func onCreateViews() {
        self.preservesSuperviewLayoutMargins = true
        self.contentView.preservesSuperviewLayoutMargins = true
    }
    
    func onLoadData() {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        onCreateViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func shrink(down: Bool) {
        UIView.animate(withDuration: 0.5) {
            let scale: CGFloat = 0.99
            self.transform = down ? CGAffineTransform(scaleX: scale, y: scale) : .identity
        }
    }
    
 
    var didTouchAction: (() -> Void)?
    
    func setModel(model: AnyObject?) {
        
    }
    
    func getSize() -> CGSize {
        return CGSize.zero
    }
    
    func getModel() -> AnyObject? {
        return NSObject()
    }
}
