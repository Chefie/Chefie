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

class PlateCommentsVerticalCell : VerticalTableSectionView<Plate> {
    
    var comments = [Comment]()
    
    override var modelSet: [Plate] {
        
        didSet{
            
        }
        
    }
    
    override func getVisibleItemsCount() -> Int {
        return comments.count < 3 ? comments.count : 3
    }
    
    override func setModel(model: AnyObject?) {
        
        self.modelSet = ((model as? [Plate])!)
    }
    
    override func getModel() -> AnyObject? {
        return modelSet as AnyObject
    }
    
    override func onRequestItemSize() -> CGSize {
        return CGSize(width: self.parentView.getWidth(), height: self.parentView.getHeight().percentageOf(amount: 16))
    }
    
    override func onRequestCell(_ tableView: UITableView, cellForItemAt indexPath: IndexPath) -> UITableViewCell {
        if (comments.count == 0) {
            
            //            let cell = tableView.dequeueReusableCell(withIdentifier: getCellIdentifier(), for: indexPath) as! PlateCommentView
            //            cell.viewController = viewController
            //            cell.collectionItemSize = onRequestItemSize()
            //            cell.parentView = tableView
            return UITableViewCell()
        }
        
        if indexPath.row < comments.count {
            let cellInfo = self.comments[indexPath.row]
            
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
        
        //   tableView.reloadData()
        // hideSkeleton()
        
        self.hideSkeleton()
        //self.contentView.backgroundColor = UIColor.purple
        if let plate = modelSet.first {
            
            appContainer.commentRepository.getComments(idRecipe: plate.id!) { (result : ChefieResult<[Comment]>) in
                
                switch result{
                    
                case .success(let data):
                    
                    let shouldReload = data.count > self.comments.count
                    self.comments.removeAll()
                    self.comments.append(contentsOf: data)
                    
                    //  self.comments = data.getFirstElements(upTo: self.getVisibleItemsCount())
                    
                    let count = self.comments.count < 3 ? self.comments.count : 3
                    
                    self.onLayoutSection(count: count)
                    
                    if (shouldReload){
                        
                        self.reloadCell(force: true)
                        self.tableView.reloadData()
                    }
                    
                    self.onReady()
                    
                    break
                    
                case .failure(_): break
                    
                    
                }
            }
        }
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
        lbl.text = ""
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
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
        _ = CGFloat(10)
        
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
        
        self.userIcon.frame = CGRect(x: 0, y: 0, width: iconSize, height: iconSize)
        self.userIcon.setCircularImageView()
        
        self.userName.snp.makeConstraints { (maker) in
            maker.leftMargin.equalTo(iconSize * 2)
            maker.topMargin.equalTo(10.5)
            maker.width.equalTo(cellSize.widthPercentageOf(amount: 40))
            maker.height.equalTo(iconSize)
        }
        
        let marginXInfo = contentSize.marginX(amount: 2)
        let marginYInfo = contentSize.marginY(amount: 10)
        
        self.content.snp.makeConstraints { (maker) in
            
            maker.left.equalTo(marginXInfo.margin)
            maker.top.equalTo(firstSectionSize.height + 24)
            maker.width.equalTo(marginXInfo.amount)
            maker.height.equalTo(marginYInfo.amount)
        }
        
        self.userIcon.showAnimatedSkeleton()
        
        self.contentView.showAnimatedGradientSkeleton()
        
        //self.content.backgroundColor = UIColor.orange
        //  self.backgroundColor = UIColor.purple
    }
    
    override func onLoadData() {
        super.onLoadData()
        
        self.userIcon.sd_setImage(with: URL(string: self.model?.userMin?.profilePic ?? "")){ (image : UIImage?,
            error : Error?, cacheType : SDImageCacheType, url : URL?) in
            
      
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
        //    self.hideSkeleton()
            //        self.doFadeIn()
            self.userName.text = self.model?.userMin?.userName
            self.content.text = self.model?.content
            
            self.hideSkeleton()
        })
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
