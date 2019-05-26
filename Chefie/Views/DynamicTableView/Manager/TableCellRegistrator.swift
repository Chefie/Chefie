//
//  TableRegistrator.swift
//  Chefie
//
//  Created by DAM on 21/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit

class TableCellRegistrator {
    
    private var items = Array<TableCellRegistrationInfo>()
    
    init() {
        
    }
    
    func add(identifier : String, cellClass : AnyClass) {
     
        if isAlreadyAdded(identifier: identifier) {
            return
        }

        let rInfo = TableCellRegistrationInfo()
        rInfo.identifier = identifier
        rInfo.cellClass = cellClass
        items.append(rInfo)
    }
    
    func registerAll(tableView : UITableView) {
        
        items.forEach { (item) in
            
           register(identifier: item.identifier, tableView: tableView)
        }
    }
    
    func register(identifier : String, tableView : UITableView) -> Bool {
        
        if isRegistered(identifier: identifier) {
            return false
        }
        
        if let item = items.first(where: { $0.identifier == identifier}) {
            
            tableView.register(item.cellClass, forCellReuseIdentifier: item.identifier)
            item.isRegistered = true
            return true
        }
        
        return false
    }
    
    func register(info : BaseItemInfo, tableView : UITableView) -> Bool {
        
        if isRegistered(identifier: info.reuseIdentifier()) {
            return false
        }
        
        if let item = items.first(where: { $0.identifier == info.reuseIdentifier()}) {
            
            tableView.register(item.cellClass, forCellReuseIdentifier: item.identifier)
            item.isRegistered = true
            return true
        }
     
        return false
    }
    
    func isRegistered(identifier : String) -> Bool {
        if let item = items.first(where: { $0.identifier == identifier}) {
            
            return item.isRegistered
        }
        
        return false
    }
    
    func isAlreadyAdded(identifier : String) -> Bool {
        if items.first(where: { $0.identifier == identifier}) != nil {
            
            // Already added to the list!
            return true
        }
        
        return false
    }
    
    var index : Int = 0
    
    func getRandomIdentifier() -> String {
        
     let item = items[index]
        
        index += 1
        if (index >= items.count){
            index = 0
        }
        
        return item.identifier
    }
}

class TableCellRegistrationInfo {
    
    var identifier : String!
    var cellClass : AnyClass!
    var isRegistered : Bool = false
}
