//
//  ViewExtensions.swift
//  Chefie
//
//  Created by Nicolae Luchian on 04/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

let g_ViewRadius = CGFloat(4.0)
let g_ShadowRadius = CGFloat(2.0)

extension UITableView {
    
    func setDefaultSettings(shouldBounce : Bool = false) {
        
        self.setCellsToAutomaticDimension()
        self.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.allowsSelection = false
        self.allowsMultipleSelection = false
        self.showsHorizontalScrollIndicator = false
        self.alwaysBounceHorizontal = false
        self.alwaysBounceVertical = false
        self.bounces = false
        
        if (shouldBounce){
            
            self.alwaysBounceVertical = true
            self.bounces = true
        }
        self.showsVerticalScrollIndicator = false
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
    }
    
    func setContentInset(top : CGFloat = 0, left : CGFloat = 0,bottom : CGFloat = 0,right : CGFloat = 0){
        self.contentInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
}

extension UILabel {
    
    func calculateTextWidth() -> CGFloat {
        
        return self.text?.width(withConstrainedHeight: self.frame.size.width, font: self.font) ?? DefaultDimensions.DefaultTextSize
    }
    
    func calculateTextHeight() -> CGFloat {
     
        return self.text?.height(withConstrainedWidth: self.frame.size.width, font: self.font) ?? DefaultDimensions.DefaultTextSize
    }
}

extension UILabel {
    
    convenience init(maskConstraints : Bool, font: UIFont = DefaultFonts.DefaultTextFont) {
        
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = maskConstraints
        isSkeletonable = true
        
        self.font = font
        paletteDefaultTextColor()
    }
}

extension UIView{
    
    convenience init(maskConstraints : Bool) {
      
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = maskConstraints
        isSkeletonable = true
    }
    
    func setAutoMaskTranslateToFalse() {
    
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func fitHeightToSubViews(width: CGFloat) {
        
        let height = self.subviews.map({$0.frame.size.height}).reduce(0, +)
        self.snp.makeConstraints { (maker) in
            
            maker.width.equalTo(width)
            maker.height.equalTo(height)
        }
    }
    
    func invalidate() {

        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func hide() {
        
        self.isHidden = true
    }
    
    func show() {
        
        self.isHidden = false
    }
    
    func setSkeleton(value : Bool = true){
        
        self.isSkeletonable = value
    }
    
    func setTouch(target : Any, selector: Selector){
        
        let singleTap = UITapGestureRecognizer(target: target, action: selector)
        singleTap.numberOfTapsRequired = 1
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(singleTap)
    }

    func addShadow(radius : CGFloat = g_ShadowRadius) {
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = radius
        self.layer.shouldRasterize = true
    }
    
    func forceAddShadow(radius : CGFloat, offsetX :  CGFloat = 3.0, offsetY : CGFloat = 2.0){
        
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
        self.layer.shadowOffset = CGSize(width: offsetX, height: offsetY)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1.0
    }
    
    func getWidth() -> CGFloat{
    
        return self.frame.width
    }
    
    func getHeight() -> CGFloat{
        
        return self.frame.height
    }
    
    func setCircularImageView() {
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        
        let mask = CAShapeLayer()
        let path = CGPath(ellipseIn: self.bounds, transform: nil)
        mask.path = path
        self.layer.mask = mask
    }
 
    func removeCornerRadius() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 0
        self.clipsToBounds = false
    }
    
    func setCornerRadius() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = CGFloat(g_ViewRadius)
    }
    
    func setCornerRadius(radius : CGFloat){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
}

extension UITableView{
    
    func setCellsToAutomaticDimension() {
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = UITableView.automaticDimension
    }
}
