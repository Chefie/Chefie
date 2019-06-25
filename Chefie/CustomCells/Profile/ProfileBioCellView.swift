//
//  ProfileBioCellView.swift
//  Chefie
//
//  Created by Alex Lin on 28/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView
import SDWebImage

class ProfileBioItemInfo : BaseItemInfo {
    override func reuseIdentifier() -> String {
        return "ProfileBioItemView"
    }
}

class ProfileBioCellView : BaseCell, ICellDataProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    typealias T = ChefieUser
    var model: ChefieUser?
    var imagePicker = UIImagePickerController()
    
    override func getModel() -> AnyObject? {
        return model
    }
    override func setModel(model: AnyObject?) {
        super.setModel(model: AnyObject?.self as AnyObject)
        self.model = model as? ChefieUser
    }
    
    let labelBio : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultTextLightFont)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
  
        let cellSize = CGSize(width: size.width, height: size.heightPercentageOf(amount: 45))
        
        labelBio.snp.makeConstraints { (maker) in
            maker.topMargin.equalTo(10)
            maker.width.equalTo(cellSize.width)
        }
        
        labelBio.displayLines(height: 200)
        
        self.contentView.snp.makeConstraints { (maker) in
            maker.size.equalTo(cellSize)
        }
        
        self.showGradientSkeleton()
    }
    
    override func onLoadData() {
        super.onLoadData()
        doFadeIn()
        
        
        self.labelBio.text = String("\(self.model?.biography ?? "")")
        
        
        contentView.snp.makeConstraints { (maker) in
            
            maker.topMargin.bottomMargin.equalTo(4)
            
            maker.width.equalTo(parentView.getWidth())
            maker.height.equalTo(labelBio.calculateTextHeight() + 55)
            // maker.height.equalTo(40)
        }
        
        //self.backgroundColor = UIColor.red
        labelBio.restore()
        self.hideSkeleton()
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        
        self.contentView.addSubview(labelBio)
    }
    

    
    
    
    
    
}
