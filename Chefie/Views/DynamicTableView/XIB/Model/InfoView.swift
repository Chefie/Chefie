//
//  InfoView.swift
//  Chefie
//
//  Created by Nicolae Luchian on 04/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class InfoView : UIView {
    
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var contentStackView: UIStackView!
    
    @IBOutlet var dateImageView: UIImageView!
    @IBOutlet var dateStack: UIStackView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func doLayout(){

        contentStackView.isSkeletonable = true
        self.isSkeletonable = true
        
        lblTitle.isSkeletonable = true
        dateStack.isSkeletonable = true
        lblDate.isSkeletonable = true
        dateImageView.isSkeletonable = true
        
        contentStackView.snp.makeConstraints { (maker) in
            maker.width.equalTo(self.frame.width)
            maker.height.equalTo(self.frame.height)
        }
        
        lblTitle.linesCornerRadius = gLabelRadius
        
        lblTitle.snp.makeConstraints { (maker) in
            maker.left.equalTo(10)
            maker.width.equalTo(self.getWidth())
            maker.height.equalTo(self.getHeight().percentageOf(amount: 50))
        }
        
        dateStack.snp.makeConstraints { (maker) in
            
            maker.width.equalTo(self.getWidth())
            maker.height.equalTo(self.heightPercentageOf(amount: 50))
        }
        
        dateImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(10)
            maker.width.equalTo(self.widthPercentageOf(amount: 10))
        }
        
        lblDate.snp.makeConstraints { (maker) in
            
            maker.width.equalTo(self.widthPercentageOf(amount: 70))
            maker.left.equalTo(self.widthPercentageOf(amount: 20))
        }
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("InfoView", owner: self, options: nil)
  
       contentStackView.fixInView(self )
    }
}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        
        
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
