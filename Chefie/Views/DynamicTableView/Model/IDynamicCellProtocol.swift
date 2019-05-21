//
//  ICellDataModel.swift
//  Chefie
//
//  Created by Nicolae Luchian on 20/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import UIKit
protocol IDynamicCellProtocol {

    func identifier() -> String
    var parentView : UIView! { get set }
    func onLayout(size: CGSize!)
    func onCreateViews()
    func onLoadData()
    
    var didTouchAction: (() -> Void)? { get }
    
    func setModel(model : AnyObject?)
    
    func getSize() -> CGSize
    
    func getModel() -> AnyObject?
}
