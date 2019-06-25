//
//  NotificationCell.swift
//  Chefie
//
//  Created by DAM on 14/06/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

struct NotificationItemData : Codable, Equatable {
    static func == (lhs: NotificationItemData, rhs: NotificationItemData) -> Bool {
        return lhs.message == rhs.message
    }
    
    var sender : UserMin?
    var type: String?
    var message : String?
}

class NotificationItemInfo : BaseItemInfo {
    
    override func reuseIdentifier() -> String {
        return "NotificationCell"
    }
}

class NotificationCell : BaseCell, ICellDataProtocol {
    var model: NotificationItemData?
    
    typealias T = NotificationItemData
    
    let lblContent : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultTextFont)
        lbl.text = ""
        lbl.textAlignment = NSTextAlignment.left
        return lbl
    }()
    
    let picImageView : UIImageView = {
        let img = UIImageView(maskConstraints: false)
        img.contentMode = ContentMode.scaleToFill
        return img
    }()
    
    override func getSize() -> CGSize {
        return CGSize(width: parentView.getWidth(), height: parentView.heightPercentageOf(amount: 10))
    }
    
    override func getModel() -> AnyObject? {
        return model as AnyObject?
    }
    
    override func setModel(model: AnyObject?) {
        
        self.model = model as? NotificationItemData
    }
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        
        let cellSize = getSize()
        
        let iconSize = CGSize(width: cellSize.widthPercentageOf(amount: 15), height: cellSize.heightPercentageOf(amount: 70))
        
        let marginX = CGFloat(10)
        
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(0)
            maker.size.equalTo(cellSize)
        }
        
        self.picImageView.frame = CGRect(x: 0, y: 0, width: iconSize.width, height: iconSize.height)
        self.picImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(marginX)
            maker.centerY.equalToSuperview()
            maker.size.equalTo(iconSize)
        }
        
        self.lblContent.snp.makeConstraints { (maker) in
            maker.width.equalTo(cellSize.width.minusWithoutPercentage(amount: iconSize.width + marginX * 3))
            maker.left.equalTo(iconSize.width + marginX * 2)
     //       maker.top.equalTo(marginX / 2)
            maker.centerY.equalToSuperview()
        }
        
        picImageView.setCircularImageView()
        self.lblContent.displayLines(height: cellSize.heightPercentageOf(amount: cellSize.height - marginX / 2))
        
     //   self.backgroundColor = UIColor.red
        self.contentView.showAnimatedGradientSkeleton()
    }
    
    override func onLoadData() {
        super.onLoadData()
        
        if let userMin = model?.sender {
            
            appContainer.userRepository.getUserMinByID(idUser: userMin.id!) { (result : ChefieResult<UserMin>) in
                
                switch result {
                    
                case .success(let user):
                    
                    self.picImageView.sd_setImage(with: URL(string: user.profilePic!)){ (image : UIImage?,
                        error : Error?, cacheType : SDImageCacheType, url : URL?) in
  
                    
                        self.picImageView.hideSkeleton()
                    }
                    break
                case .failure(_):

                    self.hideSkeleton()
                    break
                }
                
                self.lblContent.hideLines()
                self.lblContent.text = self.model?.message
                
                self.reloadCell()
                self.lblContent.hideSkeleton()
            }
        }
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        
        self.contentView.addSubview(picImageView)
        self.contentView.addSubview(lblContent)
    }
}
