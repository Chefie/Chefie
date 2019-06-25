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
    
    public static let HOME_FEED_SHOULD_REFRESH = "HOME_FEED_SHOULD_REFRESH"
    
    public static let shared = EventContainer()
    
    public var FilterSubject = PublishSubject<SearchFilter>()
 
    public var HomeSubject = PublishSubject<String>()
    
    public var NewPlateUploaded = PublishSubject<Plate>()
    
    public var NewPostLike = PublishSubject<String>()
    
    public var NewPostComment = PublishSubject<String>()
    
    public var NewStoryUploaded = PublishSubject<String>()
    
    public var ProfileSubject = PublishSubject<Any>()
    
    public var TabBarVC = PublishSubject<Any>()
    
    public func onNewPlateUploaded(plate : Plate){
        
        self.NewPlateUploaded.on(.next(plate))
    }
    
    public func reset(){
        
        FilterSubject.dispose()
        NewPostLike.dispose()
        NewPostComment.dispose()
        NewStoryUploaded.dispose()
        NewPlateUploaded.dispose()
        ProfileSubject.dispose()
        TabBarVC.dispose()
        HomeSubject.dispose()
        
        FilterSubject = PublishSubject<SearchFilter>()
        NewPlateUploaded = PublishSubject<Plate>()
        NewPostLike = PublishSubject<String>()
        NewPostComment = PublishSubject<String>()
        NewStoryUploaded = PublishSubject<String>()
        ProfileSubject = PublishSubject<Any>()
        TabBarVC = PublishSubject<Any>()
        HomeSubject = PublishSubject<String>()
    }
}



