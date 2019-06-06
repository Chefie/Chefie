//
//  RemoteData.swift
//  Chefie
//
//  Created by DAM on 04/06/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import RxSwift

class RemoteData {
    
    let NewPlateSubject = PublishSubject<Plate>()
    
    func onNewPlate(plate : Plate){
        NewPlateSubject.on(.next(plate))
    }
}
