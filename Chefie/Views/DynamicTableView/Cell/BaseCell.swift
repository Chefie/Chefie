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
    
    var baseItemInfo : BaseItemInfo?
    
    var index : Int?
    
    var shouldUseInternalSize : Bool = true
    
    func setBaseItemInfo(info : BaseItemInfo){
        
        self.baseItemInfo = info
    }
    
    open func getBaseItemInfo() -> BaseItemInfo {
        
        return self.baseItemInfo ?? BaseItemInfo()
    }
    
    func cellReuseIdentifier() -> String {
        return ""
    }
    
    func cellUUID() -> String {
        return ""
    }
  
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
    
    func doCellFadeIn() {
        
        self.contentView.doFadeIn()
    }  
    
    func onLayout(size: CGSize!) {
      //   self.contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var cellReloaded : Bool = false
    
    func onCreateViews() {
     
        self.preservesSuperviewLayoutMargins = true
        self.contentView.preservesSuperviewLayoutMargins = true
        
     //   self.contentView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
       //      cell.preservesSuperviewLayoutMargins = false
    }
    
    func isCellReloaded() -> Bool {
        
        return cellReloaded
    }
    
    func reloadCell(force : Bool = false) {
        
        if (force){
            
            cellReloaded = false
        }
        
        if (!cellReloaded){
            
            let table = self.parentView as! UITableView
            table.reloadRows(at: [IndexPath(row: self.index ?? 0, section: 0)], with: .none)
            cellReloaded = true
        }
    }
    
    func reloadTable() {
        
        if let table = self.parentView as? UITableView{

            table.reloadData()
        }
    }
    
    func onLoadData() {
        
    }
    
    func getSize() -> CGSize {
        
        return CGSize()
    }
    
    var didTouchAction: (() -> Void)?
    
    func setModel(model: AnyObject?) {
        
     //   onLoadData()
    }
    
    var cellSize : CGSize?
    
    func getModel() -> AnyObject? {
     
        return NSObject()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        onCreateViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        onCreateViews()
    }
}
