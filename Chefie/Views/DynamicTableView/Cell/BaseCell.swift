////
////  BaseCell.swift
////  Chefie
////
////  Created by Nicolae Luchian on 20/05/2019.
////  Copyright © 2019 chefie. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//protocol ICellModel {}
//
import UIKit
class BaseCell : UITableViewCell, IDynamicCellProtocol{
  
    var viewController : UIViewController?
    
    func identifier() -> String {
         return "CellBase"
    }
    
    var parentView : UIView! {
        
        didSet{
            
            let size = CGSize(width: self.parentView.frame.width, height: self.parentView.frame.height)
            onLayout(size: size)
        }
    }
    
    func doFadeIn() {
        
        self.contentView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            self.contentView.alpha = 1
        })
    }
    
    func onLayout(size: CGSize!) {
        
    }
    
    func onCreateViews() {
        
    }
    
    func onLoadData() {
        
    }
    
    func getSize() -> CGSize {
        
        return CGSize()
    }
    
    var didTouchAction: (() -> Void)?
    
    func setModel(model: AnyObject?) {
        
        onLoadData()
    }
    
    func getModel() -> AnyObject? {
     
        return NSObject()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        onCreateViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
