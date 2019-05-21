//
//  CellDataProtocl.swift
//  Chefie
//
//  Created by user155921 on 5/20/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
protocol ICellDataProtocol {
    associatedtype T
    var model: T? { get set }
}
