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

class CommentsHorizontalCellInfo : HorizontalSectionCellBaseInfo {
    
    override func reuseIdentifier() -> String {
        return String(describing: CommentsHorizontalCell.self)
    }
}

class CommentsHorizontalCell : HorizontalSectionView<Comment> {
    
    override var modelSet: [Comment]{
        
        didSet(value){
        }
    }

    override func getCellIdentifier() -> String {
        return String(describing: CommentCollectionCell.self)
    }
    
    override func registerCell() {
        
        collectionView.register(CommentCollectionCell.self, forCellWithReuseIdentifier: getCellIdentifier())
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
         return CGSize(width: collectionView.getWidth() / 2, height: parentView.heightPercentageOf(amount: 28))
    }
    
    override func onRequestCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (modelSet.count == 0) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getCellIdentifier(), for: indexPath) as! CommentCollectionCell
            cell.viewController = viewController
            cell.collectionItemSize = onRequestItemSize()
            cell.parentView = collectionView
            return cell
        }
        
        let cellInfo = self.modelSet[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getCellIdentifier(), for: indexPath) as! CommentCollectionCell
        cell.viewController = viewController
        cell.collectionItemSize = onRequestItemSize()
        cell.parentView = collectionView
        cell.setModel(model: cellInfo)
        cell.onLoadData()
        
        return cell
    }
}

class CommentCollectionCell : BaseCollectionCell, ICellDataProtocol, INestedCell {
    
    var collectionItemSize: CGSize!
    
    typealias T = Comment
    
    var model: Comment?
    
    let label : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultTextFont)
        lbl.text = "Text"
        return lbl
    }()

  
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        
        self.contentView.snp.makeConstraints { (maker) in
            // this makes collectionview not responsible??
         //   maker.top.left.right.bottom.equalToSuperview()
            maker.width.equalTo(collectionItemSize.width)
            maker.height.equalTo(collectionItemSize.height)
        }
        
        label.snp.makeConstraints { (maker) in

            maker.top.equalTo(0)
            maker.bottomMargin.equalTo(0)
          //  maker.topMargin.equalTo(10)
            maker.leftMargin.rightMargin.equalTo(10)
            maker.width.equalTo(size.widthPercentageOf(amount: 20))
            
            maker.height.equalTo(collectionItemSize.height - 10)
        }


        label.paletteDefaultTextColor()
        
  
        //    label.displayLines(height: 500)
        
        //self.backgroundColor = UIColor.red
        //    self.showAnimatedGradientSkeleton()
    }
    
    override func setModel(model: AnyObject?) {
        self.model = (model as! Comment)
    }
    
    override func getModel() -> AnyObject? {
        return model
    }
    
    override func onLoadData() {
        

       label.text = model?.content
        
        label.hideLines()
        
    }
    
    override func onCreateViews() {
        super.onCreateViews()
 
    //    self.contentView.addShadow()
       // self.contentView.addSubview(cardView)
        self.contentView.addSubview(label)
        
        
     //   self.contentView.setTouch(target: self, selector: #selector(onTouch))
    }
    
    @objc func onTouch() {
        
       print("test")
    }
}
