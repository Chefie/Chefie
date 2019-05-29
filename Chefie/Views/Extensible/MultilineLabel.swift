//
//  MultilineLabel.swift
//  Chefie
//
//  Created by user155921 on 5/21/19.
//  Copyright © 2019 chefie. All rights reserved.
//
import UIKit
import SnapKit
import Foundation

class MultilineLabel : UILabel {
    
    private var heightConstraint: Constraint? = nil
    private var widthConstraint: Constraint? = nil
    
    private var cachedNumLines = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override var numberOfLines: Int {
        
        didSet (value){
            cachedNumLines = value
        }
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    func displayLines(width: CGFloat = 100, height : CGFloat = 400){
        
        self.snp.makeConstraints { (maker) in
            
            //  widthConstraint = maker.width.equalTo(width).constraint
            heightConstraint = maker.height.equalTo(height).constraint
        }
    }
    
    func displayLines(height : CGFloat = 333){
        
        self.snp.makeConstraints { (maker) in
            
          //  widthConstraint = maker.width.equalTo(width).constraint
            heightConstraint = maker.height.equalTo(height).constraint
        }
    }
    
    func hideLines() {
        
        self.numberOfLines = 0
        heightConstraint?.deactivate()
        widthConstraint?.deactivate()
    }
    
    func restore() {
        
        numberOfLines = cachedNumLines
        heightConstraint?.deactivate()
        widthConstraint?.deactivate()
    }
    
    private func setup(){
        
        self.numberOfLines = 4
        self.linesCornerRadius = 10
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textAlignment = .center
        self.font = DefaultFonts.DefaultTextFont
        self.textColor = Palette.TextDefaultColor
        
        self.lastLineFillPercent = 100
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}


