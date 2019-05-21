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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    func displayLines(height : CGFloat){
        
        self.snp.makeConstraints { (maker) in
            
            heightConstraint =      maker.height.greaterThanOrEqualTo(height).constraint
        }
    }
    
    func deactivate() {
        
        self.numberOfLines = 0
        heightConstraint?.deactivate()
    }
    
    private func setup(){
        
        self.numberOfLines = 4
        self.linesCornerRadius = 10
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textAlignment = .center
        self.font = UIFont.systemFont(ofSize: 16)
        self.textColor = .black
        
        self.lastLineFillPercent = 100
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}


