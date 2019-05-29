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

class PlatosVerticalCellBaseItemInfo : VerticalTableSectionCellBaseInfo {
    
    override func reuseIdentifier() -> String {
       return String(describing: PlatosVerticalCell.self)
    }
    
    override func title() -> String {
        return "Plates"
    }
}

class PlatosVerticalCell : VerticalTableSectionView<Plate> {

    override var modelSet: [Plate]{
        
        didSet{
            
        }
    }
    
    override func getVisibleItemsCount() -> Int {
        return 3
    }
    
    override func setModel(model: AnyObject?) {
        self.modelSet = (model as? [Plate])!.getFirstElements(upTo: getVisibleItemsCount())
    }
    
    override func getModel() -> AnyObject? {
        return modelSet as AnyObject
    }
    
    override func onRequestItemSize() -> CGSize {
        return CGSize(width: self.parentView.getWidth(), height: self.parentView.getHeight().percentageOf(amount: 36))
    }
    
    override func onRequestCell(_ tableView: UITableView, cellForItemAt indexPath: IndexPath) -> UITableViewCell {
        if (modelSet.count == 0) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: getCellIdentifier(), for: indexPath) as! PlatoCellView
            cell.viewController = viewController
            cell.collectionItemSize = onRequestItemSize()
            cell.parentView = tableView
            return cell
        }
        
        if indexPath.row < modelSet.count {
            let cellInfo = self.modelSet[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: getCellIdentifier(), for: indexPath) as! PlatoCellView
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
        
        tableView.register(PlatoCellView.self, forCellReuseIdentifier: getCellIdentifier())
    }

    override func onLoadData() {
        super.onLoadData()
        
        tableView.reloadData()
        hideSkeleton()
    }
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        
        onLayoutSection()
        
        //contentView.showAnimatedGradientSkeleton()
    }
    
    override func getCellIdentifier() -> String {
        
        return String(describing: PlatoCellView.self)
    }
    
    override func onCreateViews() {
        super.onCreateViews()

        tableView.delegate = self
        tableView.dataSource = self
    }
}

//class ImageViewCollectionCell : BaseCell, ICellDataProtocol, INestedCell {
//
//    typealias T = Plate
//
//    var model: Plate?
//
//    var collectionItemSize: CGSize!
//
//    let frontImageView : UIImageView = {
//
//        let img = UIImageView(maskConstraints: false)
//        img.contentMode = ContentMode.scaleToFill
//        return img
//    }()
//
//    let plateTitle : MultilineLabel = {
//        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultTextFont)
//        lbl.text = ""
//        lbl.numberOfLines = 1
//        //lbl.textColor = UIColor.white
//        //lbl.backgroundColor = UIColor.blue
//        return lbl
//    }()
//
//    override func setModel(model: AnyObject?) {
//        self.model = (model as! Plate)
//    }
//
//    override func getModel() -> AnyObject? {
//        return model
//    }
//
//    override func onLayout(size: CGSize!) {
//        super.onLayout(size: size)
//
//        self.contentView.snp.makeConstraints { (maker) in
//            maker.edges.equalToSuperview()
//            maker.left.top.right.bottom.equalTo(0)
//            maker.width.equalTo(size.width)
//            maker.height.equalTo(collectionItemSize.height)
//        }
//
//        frontImageView.snp.makeConstraints { (maker) in
//
//            maker.width.equalTo(collectionItemSize.width.minus(amount: 10))
//            maker.height.equalTo(collectionItemSize.heightPercentageOf(amount: 88))
//            maker.topMargin.equalTo(0)
//            maker.bottomMargin.equalTo(10)
//            maker.left.equalTo(collectionItemSize.widthPercentageOf(amount: 5))
//      //      maker.centerX.equalTo(contentView)
//        }
//
//        self.plateTitle.snp.makeConstraints { (maker) in
//
//            maker.width.equalTo(collectionItemSize.width.minus(amount: 20))
//            maker.height.equalTo(collectionItemSize.heightPercentageOf(amount: 10))
//            maker.bottomMargin.equalToSuperview().offset(4)
//            maker.centerX.equalToSuperview()
//        }
//
//        self.frontImageView.setCornerRadius(radius: 8)
//
//       plateTitle.displayLines(height: collectionItemSize.heightPercentageOf(amount: 10))
//
//       // self.backgroundColor = UIColor.purple
//       //self.backgroundColor = UIColor.red
//       contentView.showAnimatedGradientSkeleton()
//    }
//
//    override func onLoadData() {
//
//        self.frontImageView.sd_setImage(with: URL(string: model?.multimedia?[0].url ?? "")){ (image : UIImage?,
//            error : Error?, cacheType : SDImageCacheType, url : URL?) in
//
//           self.hideSkeleton()
//        //    self.doFadeIn()
//
//           self.plateTitle.text = self.model?.title
//            self.plateTitle.hideLines()
//            // self.frontImageView.forceAddShadow(radius: 8)
//        }
//    }
//
//    override func onCreateViews() {
//        super.onCreateViews()
//
//        self.contentView.addSubview(frontImageView)
//        self.contentView.addSubview(plateTitle)
//    }
//}
//
//
