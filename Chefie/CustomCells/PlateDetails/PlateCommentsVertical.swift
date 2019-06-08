//
//  PlatosVerticalCell.swift
//  Chefie
//
//  Created by DAM on 23/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView
import SDWebImage

class PlateCommentsItemInfo : VerticalTableSectionCellBaseInfo {
    
    override func reuseIdentifier() -> String {
       return String(describing: PlateCommentsVerticalCell.self)
    }
    
    override func title() -> String {
        return "Comments"
    }
}

class PlateCommentsVerticalCell : VerticalTableSectionView<Comment> {

    override var modelSet: [Comment]{
        
        didSet{
            
        }
    }
    
    override func getVisibleItemsCount() -> Int {
        return 3
    }
    
    override func setModel(model: AnyObject?) {
        self.modelSet = (model as? [Comment])!.getFirstElements(upTo: getVisibleItemsCount())
    }
    
    override func getModel() -> AnyObject? {
        return modelSet as AnyObject
    }
    
    override func onRequestItemSize() -> CGSize {
        return CGSize(width: self.parentView.getWidth(), height: self.parentView.getHeight().percentageOf(amount: 20))
    }
    
    override func onRequestCell(_ tableView: UITableView, cellForItemAt indexPath: IndexPath) -> UITableViewCell {
        if (modelSet.count == 0) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: getCellIdentifier(), for: indexPath) as! PlateCommentView
            cell.viewController = viewController
            cell.collectionItemSize = onRequestItemSize()
            cell.parentView = tableView
            return cell
        }
        
        if indexPath.row < modelSet.count {
            let cellInfo = self.modelSet[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: getCellIdentifier(), for: indexPath) as! PlateCommentView
            cell.viewController = viewController
            cell.collectionItemSize = onRequestItemSize()
            cell.parentView = tableView
            cell.setModel(model: cellInfo)
            cell.onLoadData()
            
            return cell
        }
     
        return super.onRequestCell(tableView, cellForItemAt: indexPath)
    }
    
    override func onRegisterCells() {
        
        tableView.register(PlateCommentView.self, forCellReuseIdentifier: getCellIdentifier())
    }

    override func onLoadData() {
        super.onLoadData()
        
        tableView.reloadData()
        hideSkeleton()
    }
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        
        onLayoutSection()
    }
    
    override func getCellIdentifier() -> String {
        
        return String(describing: PlateCommentView.self)
    }
    
    override func onCreateViews() {
        super.onCreateViews()

        tableView.delegate = self
        tableView.dataSource = self
    }
}

class PlateCommentView : BaseCell, ICellDataProtocol, INestedCell {
    var collectionItemSize: CGSize!
    
    typealias T = Comment
    
    var model: Comment?
    
    let userIcon : UIImageView = {
        
        let img = UIImageView(maskConstraints: false)
        img.contentMode = ContentMode.scaleToFill
        img.image = UIImage(named: "user")
        return img
    }()
    
    let userName : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultTextFont)
        lbl.text = "user"
        lbl.numberOfLines = 1
        return lbl
    }()
    
    let content : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultTextFont)
        lbl.text = "Birth rich in heavy atoms science prime number quasar a still more glorious dawn awaits. Ship of the imagination stirred by starlight at the edge of forever qui dolorem ipsum quia dolor sit amet "
        lbl.numberOfLines = 4
        return lbl
    }()
    
    override func setModel(model: AnyObject?) {
        self.model = (model as! Comment)
    }
    
    override func getModel() -> AnyObject? {
        return model
    }
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        
        let cellSize = CGSize(width: collectionItemSize.width, height: collectionItemSize.height)

        let iconSize = cellSize.widthPercentageOf(amount: 5)
        let leftMargin = CGFloat(20)
        let topMargin = CGFloat(10)
        
        let firstSectionSize = CGSize(width: size.width, height: cellSize.heightPercentageOf(amount: 8))
        
        let contentSize = CGSize(width: size.width, height: cellSize.heightPercentageOf(amount: 70))
        
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(0)
            maker.size.equalTo(cellSize)
        }
        
        self.userIcon.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(leftMargin)
            maker.topMargin.equalTo(10)
            maker.width.equalTo(iconSize)
            maker.height.equalTo(iconSize)
        }
        
        self.userName.snp.makeConstraints { (maker) in
            maker.leftMargin.equalTo(iconSize * 3)
            maker.topMargin.equalTo(12)
        }
        
        self.content.snp.makeConstraints { (maker) in
            
            maker.top.equalTo(firstSectionSize.height + 20)
            maker.size.equalTo(contentSize)
        }
        
        //self.content.backgroundColor = UIColor.orange
        
      self.backgroundColor = UIColor.purple
    }
    
    override func onLoadData() {
        
    }
    
    @objc func onTouch() {
        
     
    }
    
    override func onCreateViews() {
        super.onCreateViews()

        contentView.addSubview(userIcon)
        contentView.addSubview(userName)
        contentView.addSubview(content)
    }
}
