//
//  ChefieCellViewProtocol.swift
//  Chefie
//
//  Created by Nicolae Luchian on 04/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation

import UIKit

protocol ChefieCellViewProtocol {
    
    associatedtype T
    
    var onAction: (() -> Void)? { get set }
    
    var parentView : UIView! { get set }
    var model: T? { get set }
    func onLayout(size: CGSize!)
    func onCreateViews()
    func onLoadData()
}
