//
//  BlockingExecution.swift
//  Chefie
//
//  Created by Nicolae Luchian on 05/06/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation

class BlockingExecution {
    
    static func doBlockingAsync(count : Int, callback : () -> Void ){
        
        var batchCount = count
        var resultArray = [Any]()
        var errors  : [Error]?
        var running = false, finished = false
        
        while(!finished){
            
            if (!running) {
                    
            }
        }
    }
}
