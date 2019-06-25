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
import SDWebImage

class StoriesHorizontalItemInfo : HorizontalSectionCellBaseInfo {
    
    override func reuseIdentifier() -> String {
        return String(describing: StoriesHorizontalView.self)
    }
    
    override func title() -> String {
        return "Stories"
    }
}

class StoriesHorizontalView : HorizontalSectionView<Story> {
    
    override var modelSet: [Story]{
        
        didSet(value){
        }
    }
    
    override func getCellIdentifier() -> String {
        return String(describing: StoryViewCell.self)
    }
    
    override func registerCell() {
        
        collectionView.register(StoryViewCell.self, forCellWithReuseIdentifier: getCellIdentifier())
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
        return CGSize(width: collectionView.getWidth() / 2, height: parentView.heightPercentageOf(amount: 20))
    }
    
    override func onRequestCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (modelSet.count == 0) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getCellIdentifier(), for: indexPath) as! StoryViewCell
            cell.viewController = viewController
            cell.collectionItemSize = onRequestItemSize()
            cell.parentView = collectionView
            return cell
        }
        
        let cellInfo = self.modelSet[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getCellIdentifier(), for: indexPath) as! StoryViewCell
        cell.viewController = viewController
        cell.collectionItemSize = onRequestItemSize()
        cell.parentView = collectionView
        cell.setModel(model: cellInfo)
        cell.onLoadData()
        
        return cell
    }
}

class StoryViewCell : BaseCollectionCell, ICellDataProtocol, INestedCell {
    
    var collectionItemSize: CGSize!
    
    typealias T = Story
    
    var model: Story?
    
    let backImageView : UIImageView = {
        
        let view = UIImageView(maskConstraints: false)
        return view
    }()
    
    let userIconView : UIImageView = {
        
        let view = UIImageView(maskConstraints: false)
        view.image = UIImage(named: "AppIcon")
        return view
    }()
    
    let label : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultTextFont)
        lbl.text = ""
        return lbl
    }()
    
    var mainRect = CGRect()
    var userPicRect = CGRect()
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)

        self.contentView.snp.makeConstraints { (maker) in
            maker.width.equalTo(collectionItemSize.width)
            maker.height.equalTo(collectionItemSize.height)
        }
        
        let userIconSize = CGSize(width: collectionItemSize.widthPercentageOf(amount: 18), height: collectionItemSize.heightPercentageOf(amount: 20))
        mainRect = CGRect(x: 0, y: 0, width: collectionItemSize.width, height: collectionItemSize.height.minus(amount: 15))
        userPicRect = CGRect(x: 0, y: mainRect.maxX - userIconSize.height.remainder(dividingBy: 2) , width: userIconSize.width, height: userIconSize.height)

        //self.backImageView.frame = mainRect
        self.backImageView.snp.makeConstraints { (maker) in
            maker.size.equalTo(mainRect.size)
            maker.centerY.equalToSuperview()
        }
        
        self.userIconView.frame = userPicRect
        self.userIconView.snp.makeConstraints { (maker) in

            maker.size.equalTo(userPicRect.size)
            maker.center.equalToSuperview()
        }

        self.label.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
            maker.width.equalTo(size.width)
            maker.bottom.equalTo(10)
        }
        
        self.backImageView.setCornerRadius(radius: 10)
        self.backImageView.addShadow()
        self.userIconView.setCircularViewWith()
    }
    
    override func setModel(model: AnyObject?) {
        self.model = (model as! Story)
    }
    
    override func getModel() -> AnyObject? {
        return model
    }
    
    override func onLoadData() {
        super.onLoadData()
        
     //   self.userIconView.borderColor = UIColor.red
        
        backImageView.sd_setImage(with: URL(string: model?.media?.url ?? "")){ (image : UIImage?,
            error : Error?, cacheType : SDImageCacheType, url : URL?) in
            
            self.backImageView.image = image?.drawDarkRect(alpha: 0.2)
        }
        
        
     //   self.label.text = model?.user?.userName
        
//        userIconView.sd_setImage(with: URL(string: model?.user?.profilePic ?? "")){ (image : UIImage?,
//            error : Error?, cacheType : SDImageCacheType, url : URL?) in
//
//
//        }
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        
        self.addSubview(backImageView)
        self.addSubview(userIconView)
        self.addSubview(label)
    }
}
