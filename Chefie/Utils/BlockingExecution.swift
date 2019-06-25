//
//  BlockingExecution.swift
//  Chefie
//
//  Created by Nicolae Luchian on 05/06/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit

class AsyncExtensions {
    
    static func callAfter(delay : Int, callback : @escaping () -> Void){
        
        let deadlineTime = DispatchTime.now() + .seconds(delay)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
           callback()
        })
    }
}

extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}

class BlockingExecution {   
    
//    static func doBlockingAsync(count : Int, callback : () -> Void ){
//        
//        var batchCount = count - 1
//        var resultArray = [Any]()
//        var errors  : [Error]?
//        var running = false, finished = false
//        
//        while(!finished){
//            
//            if (!running && !finished) {
//                
//                running = true
//                
//                if (batchCount < 0) {
//                    finished = true
//                    continue
//                }
//            }
//        }
//    }
}
