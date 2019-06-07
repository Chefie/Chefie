//
//  PlateCellView.swift
//  Chefie
//
//  Created by Steven on 27/04/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView
import SDWebImage

class PlateCellView : UITableViewCell, ChefieCellViewProtocol{
    var onAction: (() -> Void)?
    
    typealias T = Plate
    
    var model: Plate?{
        
        didSet{
            
            onLoadData()
        }
    }
    
    let frontImageView : UIImageView = {
        
        let img = UIImageView()
        img.contentMode = ContentMode.scaleToFill
        img.isSkeletonable = true
        img.setRounded()
        return img
    }()
    
    let label : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.text = "Testing Now"
        lbl.isSkeletonable = true
        lbl.frame = CGRect(x: 10, y: 10, width: 100, height: 10)
        lbl.linesCornerRadius = 10
        return lbl
    }()
    
    func onLayout(size : CGSize!) {
    
        let imageHeight = size.height.percentageOf(amount: 91)
        let titleFontHeight = max(label.font.lineHeight, size.height.percentageOf(amount: 9))

        label.setCornerRadius()
        label.snp.makeConstraints { (maker) in
            
        maker.left.equalTo(size.widthPercentageOf(amount: 2))
            maker.top.equalTo(size.height.percentageOf(amount: 2))
            maker.width.equalTo(size.width.minus(amount: 4))
            maker.height.equalTo(titleFontHeight)
        }
        
        frontImageView.setCornerRadius()
        frontImageView.addShadow()
        frontImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(size.widthPercentageOf(amount: 2))
            maker.top.equalTo(titleFontHeight)
            maker.width.equalTo(size.width.minus(amount: 4))
            maker.height.equalTo(imageHeight)
        }
        
      // frontImageView.roundedImage()
       // self.contentView.backgroundColor = UIColor.red
        self.showAnimatedGradientSkeleton()
    }

    var parentView : UIView! {
        
        didSet{

            let size = CGSize(width: self.frame.width, height: self.frame.height)
 
            onLayout(size: size)
        }
    }
 
    func onLoadData() {
        
        self.frontImageView.sd_setImage(with: URL(string: model?.multimedia?[0].url ?? "")){ (image : UIImage?,
            error : Error?, cacheType : SDImageCacheType, url : URL?) in
            self.label.text = self.model?.title
            self.hideSkeleton()
        }
    }
    
    func onCreateViews() {

        self.contentView.addSubview(label)
        self.contentView.addSubview(frontImageView)
       //addSubview(containerView)
      
       frontImageView.setTouch(target: self, selector: #selector(onTouch))
    }
    
    @objc func onTouch() {
     
        onAction?()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
  
       onCreateViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }
}
