//
//  CommentDialogView.swift
//  Chefie
//
//  Created by user155921 on 6/9/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class CommentDialogView : UIView {
    
    @IBOutlet var contentText: SpringTextView!
    
    func setup(view : UIView) {
        
        self.contentText.backgroundColor = .clear
        contentText.snp.makeConstraints { (maker) in
            
            maker.left.top.right.bottom.equalTo(0)
            maker.width.equalTo(view.getWidth())
            maker.height.equalTo(self)
        }  
    }
}
