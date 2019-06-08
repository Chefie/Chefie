//
//  EventContainer.swift
//  Chefie
//
//  Created by user155921 on 6/7/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import RxSwift

class EventContainer {

    public static let shared = EventContainer()

    public let FilterSubject = PublishSubject<SearchFilter>()
}

struct SearchFilter  {
    
    var community : String?
    var searchDest : SearchQueryInfo
}


