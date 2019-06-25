//
//  FeedRepository.swift
//  Chefie
//
//  Created by user155921 on 6/12/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import Firebase
import FirebaseCore
import CodableFirebase

struct RetrieveFeedInfo {
    
    var currentOffset : Int = 0
    var limit: Int = 5
    var snapShot : QueryDocumentSnapshot?
    var data : [Plate]?
    
    mutating func update(result : RetrieveFeedInfo){
        
        if let data = result.data{
            
            self.currentOffset =  self.currentOffset + data.count
            
            if !data.isEmpty{
                self.snapShot = result.snapShot
            }
        }
    }
    
    mutating func reset()  {
        self.currentOffset = 0
        self.snapShot = nil
    }
}

class FeedRepository {
    
    func getLastFeedFromUser(idUser: String, completion: @escaping () -> Void ){
        
        let collection = Firestore.firestore().collection("Platos")
        let query =  collection.order(by: "timeStamp", descending: true).whereField("idUser", isEqualTo: idUser).limit(to: 5)
        
        query.getDocuments { (snapshot, err) in
            
            if let documents = snapshot?.documents {
             
                DispatchQueue.global().async {
                    
                    let group = DispatchGroup()
                    
                    documents.forEach({ (snap) in
                        group.enter()
                        let data = snap.data()
                        self.sendFeedTo(id: appContainer.getUser().id!, data: data, completionHandler: { (result : ChefieResult<Bool>) in


                            group.leave()
                        })
                    })

                    group.wait()

                    group.notify(queue: DispatchQueue.main) {
                        completion()
                        print("executed")
                    }
                }
            }
        }
    }
    
    func removeUserPlatesFromMyFeed(idUser: String, completion: @escaping () -> Void ){
        let collection = Firestore.firestore().collection("/Feed/\(appContainer.getUser().id!)/data")
        
        collection.whereField("idUser", isEqualTo: idUser).getDocuments { (snapshot, err) in
            snapshot?.documents.forEach({ (snap) in
                snap.reference.delete()
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
               completion()
            })
        }
    }
    
    func sendFeedToFollowers(idUser: String, plate: Plate, timeStamp: Timestamp) {
        
        // For now we will load all followers beacuse is not necessary to optimize for few users
        appContainer.userRepository.getUserFollowers(idUser: idUser) { (result : ChefieResult<[UserMin]>) in
            
            switch result {
                
            case .success(let data):
                print("Send feed to followers began")
                
                data.forEach({ (user) in
                    
                    let UID = user.id!
                    
                    self.sendFeedTo(id: UID, timeStamp: timeStamp, data: plate, completionHandler: { (result : ChefieResult<Bool>) in
                        
                    })
                })
                
                break
            case .failure(_):
                
                print("Send feed to followers failed")
                break
            }
        }
    }
    
    func sendFeedTo<T: Codable>(id: String, timeStamp: Timestamp, data: T, completionHandler: @escaping (ChefieResult<Bool>) -> Void ) -> Void {
        let collection = Firestore.firestore().collection("/Feed/\(id)/data")
        
        do {
            
            var model = try FirestoreEncoder().encode(data)
            model["timeStamp"] = timeStamp
            collection.addDocument(data: model) { (err) in
                
            }
            
            print("Sent feed to myself")
        }catch {
            print("Couldn't decode feed data")
        }
    }
    
    func sendFeedTo(id: String, data: [String:Any], completionHandler: @escaping (ChefieResult<Bool>) -> Void ) -> Void {
        let collection = Firestore.firestore().collection("/Feed/\(id)/data")
        
        collection.addDocument(data: data) { (err) in
            
            completionHandler(.success(true))
        }
    }
    
    func getFeed(userId : String, retrieveInfo : RetrieveFeedInfo, completionHandler: @escaping (ChefieResult<RetrieveFeedInfo>) -> Void ) -> Void {
        
        let collection = Firestore.firestore().collection("/Feed/\(userId)/data")
        
        var query = collection.limit(to: retrieveInfo.limit).order(by: "timeStamp", descending: true)
        
        if retrieveInfo.snapShot != nil {
            query = query.start(afterDocument: retrieveInfo.snapShot!)
        }
        //
        
        query.getDocuments { (snapshot, err) in
            
            if let documents = snapshot?.documents {
                var plates = Array<Plate>()
                documents.forEach({ (document) in
                    do {
                        
                        let model = try FirestoreDecoder().decode(Plate.self, from: document.data())
                        plates.append(model)
                    } catch  {
                        print("Couldn't decode feed")
                    }
                })
                
                var result = RetrieveFeedInfo()
                result.limit = retrieveInfo.limit
                result.data = plates
                
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
