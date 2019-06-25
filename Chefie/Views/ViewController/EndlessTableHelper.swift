//
//  EndlessTableHelper.swift
//  Chefie
//
//  Created by user155921 on 6/3/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit

enum DataState {
    case idle, firstLoad, loaded, dataNotFound
}

class EndlessTableHelper {
    
    var isFirst = false
    var firstItemsCount : Int = AppSettings.DefaultSkeletonCellCount {
        
        didSet {
          
            self.itemsCount = firstItemsCount
        }
    }
    var tableView : UITableView
    
    var dataState : DataState = DataState.idle
    var itemsCount : Int = AppSettings.DefaultSkeletonCellCount
    
    var noData : Bool = false
    
    init(table : UITableView) {
        
        self.tableView = table
    }
    
    func begin() {
        
        self.tableView.beginUpdates()
        doFirstItemsCheck()
    }
    
    func end() {
        
        self.tableView.endUpdates()
    }
    
    func setCount(count: Int){
        
        noData = count == 0
        itemsCount = count
    }
    
    func reset(reloadNow : Bool = true) {
        
        noData = true
        self.itemsCount = 0
        if (reloadNow) {
             tableView.reloadData()
        }
    }
    
    func getCount() -> Int {
        
        if (noData){

            return 0
        }
        let count = itemsCount == 0 ? firstItemsCount : itemsCount
        return count
    }

    func removeRows(count : Int){
        
        let rowsToRemove = Array(0..<count).compactMap({ (num) -> IndexPath in
            return IndexPath(row: num, section: 0)
        })
        
        self.tableView.deleteRows(at: rowsToRemove, with: .none)
    }
    
    func loadMoreItems(itemsCount : Int, callback:(() -> Void)){

        if (itemsCount >= 0){
            
            let First = self.isFirst ? true : false
  
            begin()
            callback()
            end()
            
            if (First){
                
                tableView.reloadData()
            }
            addOffset(count: itemsCount)
        }
        else {
            
            print("Load More Items: 0 items found")
        }
    }
    
    func addOffset(count : Int){
       // self.tablePaginator.incrementOffsetBy(delta: count)
        //self.tablePaginator.partialDataFetchingDone()
    }
    
    func insertRowAt(row : Int){
        
        let indexPath:IndexPath = IndexPath(row: row, section:0)
        self.tableView.insertRows(at: [indexPath], with: .fade)
    }
    
    func insertRow(itemsCount : Int){

        let indexPath:IndexPath = IndexPath(row:(itemsCount), section:0)
        self.tableView.insertRows(at: [indexPath], with: .fade)
    }
    
    private func doFirstItemsCheck() {
        
        if (!self.isFirst) {
            
            if (firstItemsCount > 0){

                let skeletonItemsCount = Array(0..<firstItemsCount).compactMap({ (num) -> IndexPath in
                    return IndexPath(row: num, section: 0)
                })
                
                if self.tableView.numberOfRows(inSection: 0) > 0{
                    
                   self.tableView.deleteRows(at: skeletonItemsCount, with: .none)
                }
               
            }
            self.isFirst = true
        }
    }
}
