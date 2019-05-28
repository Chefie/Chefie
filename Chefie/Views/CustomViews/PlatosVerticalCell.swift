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

class PlatosVerticalCellBaseItemInfo : VerticalSectionCellBaseInfo {
    
    override func reuseIdentifier() -> String {
       return String(describing: PlatosVerticalCell.self)
    }
    
    override func title() -> String {
        return "Plates"
    }
}

class PlatosVerticalCell : VerticalSectionView<Plate> {

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
    
    override func onRequestNumberOfSections() -> Int {
        return 1
    }
    
    override func onRequestNumberOfItemsInSection() -> Int {
        return self.modelSet.count == 0 ? AppSettings.DefaultSkeletonCellCount : modelSet.count
    }
    
    override func onRequestItemSize() -> CGSize {
        return CGSize(width: self.parentView.getWidth().minus(amount: 10), height: self.parentView.getHeight().percentageOf(amount: 36))
    }
    
    override func onRequestCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (modelSet.count == 0) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getCellIdentifier(), for: indexPath) as! ImageViewCollectionCell
            cell.collectionItemSize = onRequestItemSize()
            cell.viewController = viewController
            cell.parentView = collectionView
            return cell
        }
        
        let cellInfo = self.modelSet[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getCellIdentifier(), for: indexPath) as! ImageViewCollectionCell
        cell.viewController = viewController
        cell.collectionItemSize = onRequestItemSize()
        cell.parentView = collectionView
        cell.setModel(model: cellInfo)
        cell.onLoadData()
        
        return cell
    }
    
    override func onRegisterCells() {
        
        collectionView.register(ImageViewCollectionCell.self, forCellWithReuseIdentifier: getCellIdentifier())
    }

    override func onLoadData() {
        super.onLoadData()
        
        collectionView.reloadData()
        
        hideSkeleton()
    }
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        
        onLayoutSection()
        
        contentView.showAnimatedGradientSkeleton()
    }
    
    override func verticalSpacing() -> CGFloat {
        return 20
    }
    
    override func getCellIdentifier() -> String {
        
        return String(describing: ImageViewCollectionCell.self)
    }
    
    override func onCreateViews() {
        super.onCreateViews()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        print("Create views called")
    }
}

class ImageViewCollectionCell : BaseCollectionCell, ICellDataProtocol, INestedCell {

    override var isSelected: Bool{
        didSet{
            UIView.animate(withDuration: 2.0) {
                self.frontImageView.transform = self.isSelected ? CGAffineTransform(scaleX: 0.9, y: 0.9) : CGAffineTransform.identity
            }
        }
    }
    
    typealias T = Plate
    
    var model: Plate?
    
    var collectionItemSize: CGSize!
 
    let frontImageView : UIImageView = {
        
        let img = UIImageView(maskConstraints: false)
        img.contentMode = ContentMode.scaleToFill
        return img
    }()
    
    let plateTitle : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultTextFont)
        lbl.text = ""
        lbl.numberOfLines = 1
        return lbl
    }()
    
    override func setModel(model: AnyObject?) {
        self.model = (model as! Plate)
    }
    
    override func getModel() -> AnyObject? {
        return model
    }
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
    
        frontImageView.snp.makeConstraints { (maker) in

            maker.width.equalTo(collectionItemSize.width)
            maker.height.equalTo(collectionItemSize.heightPercentageOf(amount: 88))
            maker.topMargin.equalTo(0)
            maker.bottomMargin.equalTo(6)
        }
        
        self.plateTitle.snp.makeConstraints { (maker) in
            
            maker.bottom.equalTo(0)
            maker.width.equalTo(collectionItemSize.width)
        }
        
        self.frontImageView.setCornerRadius(radius: 8)
    //    self.frontImageView.addShadow(radius: 5)
        
        self.contentView.snp.makeConstraints { (maker) in
            maker.margins.equalToSuperview()
            maker.width.equalTo(size.width)
            maker.height.equalTo(collectionItemSize.height)
        }
        
        plateTitle.displayLines(height: collectionItemSize.heightPercentageOf(amount: 10))
        
        //self.frontImageView.backgroundColor = UIColor.purple
       //self.backgroundColor = UIColor.red
        self.showAnimatedGradientSkeleton()
    }
    
    override func onLoadData() {
        
        self.frontImageView.sd_setImage(with: URL(string: model?.multimedia?[0].url ?? "")){ (image : UIImage?,
            error : Error?, cacheType : SDImageCacheType, url : URL?) in

            self.hideSkeleton()
            self.doFadeIn()
            
            self.plateTitle.text = self.model?.title
            self.plateTitle.hideLines()
            // self.frontImageView.forceAddShadow(radius: 8)
        }
    }
    
    override func onCreateViews() {
        super.onCreateViews()

        self.contentView.addSubview(frontImageView)
        self.contentView.addSubview(plateTitle)
    }
}


