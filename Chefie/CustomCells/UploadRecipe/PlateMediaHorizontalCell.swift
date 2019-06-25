//
//  CommentsHorizontalCell.swift
//  Chefie
//
//  Created by user155921 on 5/22/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView
import Gallery

struct MultimediaData {
    
    var video : Video?
    var image : Image?
    var contentType : String?
}

struct MediaData {
    
    var image : Image?
    
}
class PlateMediaHorizontalBaseInfo : HorizontalSectionCellBaseInfo {
    
    override func reuseIdentifier() -> String {
        return String(describing: PlateMediaHorizontalCell.self)
    }
    
    override func uniqueIdentifier() -> String {
        return "PlateMedia"
    }
}

class PlateMediaHorizontalCell : HorizontalSectionView<MultimediaData> {
    
    override var modelSet: [MultimediaData]{
        
        didSet(value){
        }
    }
    
    override func getCellIdentifier() -> String {
        return String(describing: PlateMediaCell.self)
    }
    
    override func registerCell() {
        
        collectionView.register(PlateMediaCell.self, forCellWithReuseIdentifier: getCellIdentifier())
        
        // collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "VideoCell")
    }
    
    override func onLoadData() {
        
        collectionView.reloadData()
        super.onLoadData()
    }
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        
        setActionButtonSize(size: CGSize(width: 20, height: 18))
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func onRequestItemSize() -> CGSize {
        return CGSize(width: collectionView.getWidth() / 2, height: parentView.getHeight() - 10)
    }
    
    override func onRequestCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (modelSet.count == 0) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getCellIdentifier(), for: indexPath) as! PlateMediaCell
            cell.viewController = viewController
            cell.collectionItemSize = onRequestItemSize()
            cell.parentView = collectionView
            return cell
        }
        
        let cellInfo = self.modelSet[indexPath.row]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getCellIdentifier(), for: indexPath) as! PlateMediaCell
        cell.viewController = viewController
        cell.collectionItemSize = onRequestItemSize()
        cell.parentView = collectionView
        cell.setModel(model: cellInfo as AnyObject)
        cell.index = indexPath.row
        cell.parent = self
        cell.onLoadData()
        
        return cell
    }
    
    func removeAt(index : Int){
        
        self.modelSet.remove(at: index)
        
        self.collectionView.reloadData()
    }
}

class PlateMediaCell : BaseCollectionCell, ICellDataProtocol, INestedCell {
    var model: MultimediaData?

    var collectionItemSize: CGSize!
    
    typealias T = MultimediaData
    
    var parent : PlateMediaHorizontalCell?
    
    let frontImageView : UIImageView = {
        
        let img = UIImageView(maskConstraints: false)
        img.contentMode = ContentMode.scaleToFill
        return img
    }()
    
    let deleteMediaImageView : UIImageView = {
        
        let img = UIImageView(maskConstraints: false)
        img.contentMode = ContentMode.scaleAspectFit
        img.image = UIImage(named: "close_media_view")?.imageWithColor(tintColor: UIColor.white)
        return img
    }()
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)

        self.contentView.snp.makeConstraints { (maker) in
            maker.width.equalTo(collectionItemSize.width)
            maker.height.equalTo(collectionItemSize.height)
        }
        
        self.frontImageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(collectionItemSize.width)
            maker.height.equalTo(collectionItemSize.height)
        }
        
        let deleteSize = CGSize(width: collectionItemSize.widthPercentageOf(amount: 10), height: collectionItemSize.heightPercentageOf(amount: 10))
        
        self.deleteMediaImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(20)
            maker.right.equalTo(0)
            maker.size.equalTo(deleteSize)
        }
        
        self.frontImageView.setCornerRadius(radius: 2)
    }
    
    override func setModel(model: AnyObject?) {
        self.model = (model as! MultimediaData)
    }
    
    override func getModel() -> AnyObject? {
        return model as AnyObject?
    }
    
    override func onLoadData() {
        super.onLoadData()
        
        if (model?.contentType == "image"){
            
            Image.resolve(images: [(model?.image!)!], completion: { [weak self] resolvedImages in
                
                let imageResolved = resolvedImages.first!
                
                self?.frontImageView.image = imageResolved
                self?.doFadeIn()
            })
        }
        else {
            model?.video?.fetchThumbnail(size: collectionItemSize, completion: { (image : UIImage?) in
             
                let image2 = image?.drawDarkRect().with(image: "play_video", rectCalculation: { (parentSize, newSize) -> (CGRect) in
                    return CGRect(x: parentSize.width / 2 - 50, y: parentSize.height / 2 - 60, width: 60, height: 60)
                })
                self.frontImageView.image = image2
                self.doFadeIn()
            })
        }
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        
        self.contentView.addSubview(frontImageView)
        self.contentView.addSubview(deleteMediaImageView)
        
        self.deleteMediaImageView.setTouch(target: self, selector: #selector(onRemoveMedia))
    }
    
    @objc func onRemoveMedia(){
        
        parent?.removeAt(index: index!)
    }
    
    @objc func onTouch() {
        
      
    }
}
