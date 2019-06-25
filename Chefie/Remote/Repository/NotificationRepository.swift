//
//  NotificationRepository.swift
//  Chefie
//
//  Created by DAM on 14/06/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

public struct RetrieveNotificationInfo{
    
    var currentOffset : Int = 0
    var limit: Int = 5
    var snapShot : QueryDocumentSnapshot?
    var data : [NotificationItemData]?
    
    mutating func update(result : RetrieveNotificationInfo){
        
        if let data = result.data{
            
            self.currentOffset =  self.currentOffset + data.count
            
            if !data.isEmpty{
                self.snapShot = result.snapShot
            }
        }
    }
}

class NotificationRepository {

    func getNotificationFeedFrom(idUser : String,  retrieveInfo : RetrieveNotificationInfo, completionHandler: @escaping (ChefieResult<RetrieveNotificationInfo>) -> Void ) -> Void {
        
        let notificationCollection = Firestore.firestore().collection("/Notifications/\(idUser)/data")
        
        var query = notificationCollection.limit(to: retrieveInfo.limit).order(by: "timeStamp", descending: true)
        
        if retrieveInfo.snapShot != nil {
            query = query.start(afterDocument: retrieveInfo.snapShot!)
        }
        
        query.getDocuments { (snapshot, err) in
            
            if (err != nil){
                
                completionHandler(.failure(err!.localizedDescription))
                return
            }
            
            if let documents = snapshot?.documents {
                
                var items = Array<NotificationItemData>()
                
                snapshot?.documents.forEach({ (snapshot) in
                    
                    do {
                        
                        let model = try FirebaseDecoder().decode(NotificationItemData.self, from: snapshot.data())
                        
                        items.append(model)
                    } catch {
                        
                    }
                })
                
                var result = RetrieveNotificationInfo()
                result.limit = retrieveInfo.limit
                result.data = items
                
                if !documents.isEmpty {
                    
                    result.snapShot = documents.last
                }
                
                completionHandler(.success(result))        
            } else {
                completionHandler(.failure(err as! String))
            }
        }
    }
}
