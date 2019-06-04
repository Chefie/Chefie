//
//  EndlessTableHelper.swift
//  Chefie
//
//  Created by user155921 on 6/3/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
class EndlessTableHelper {
    
    var isFirst = false
    var firstItemsCount = AppSettings.DefaultSkeletonCellCount
    var tableView : UITableView
    var tablePaginator : TableviewPaginatorEx
    
    init(table : UITableView, paginator : TableviewPaginatorEx) {
        
        self.tableView = table
        self.tablePaginator = paginator
    }
    
     func begin() {
        
        self.tableView.beginUpdates()
        doFirstItemsCheck()
    }
    
     func end() {
        
        self.tableView.endUpdates()
    }
    
    func removeRows(count : Int){
        
        let rowsToRemove = Array(0..<count).compactMap({ (num) -> IndexPath in
            return IndexPath(row: num, section: 0)
        })
        
        self.tableView.deleteRows(at: rowsToRemove, with: .none)
    }
    
    func loadMoreItems(itemsCount : Int, callback:(() -> Void)){

        if (itemsCount > 0){
            
            begin()
            callback()
            end()
            
            addOffset(count: itemsCount)
        }
        else {
            
            print("Load More Items: 0 items found")
        }
    }
    
    func addOffset(count : Int){
        self.tablePaginator.incrementOffsetBy(delta: count)
        self.tablePaginator.partialDataFetchingDone()
    }
    
    func insertRow(itemsCount : Int, item : BaseItemInfo){

        let indexPath:IndexPath = IndexPath(row:(itemsCount), section:0)
        self.tableView.insertRows(at: [indexPath], with: .fade)
    }
    
    private func doFirstItemsCheck() {
        
        if (!self.isFirst) {
            
            if (firstItemsCount > 0){

                let skeletonItemsCount = Array(0..<firstItemsCount).compactMap({ (num) -> IndexPath in
                    return IndexPath(row: num, section: 0)
                })
                
                self.tableView.deleteRows(at: skeletonItemsCount, with: .none)
            }
            self.isFirst = true
        }
    }
}