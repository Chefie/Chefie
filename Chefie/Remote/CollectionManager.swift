//
//  CollectionManager.swift
//  Chefie
//
//  Created by DAM on 12/06/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import Firebase
import FirebaseCore

class CollectionManager {
    
    public static let shared = CollectionManager()
    func initialSetup() {
        
        let UID = appContainer.getUser().id!
        
        createFollowingCollection(id: UID)
      //  createLikeCollection(id: UID)
        createFollowersCollection(id: UID)
    }
    
    func getDefaultCollectionData() -> [String: Any]{
        
    return   [
            "created_at" : Date().convertDateToString(),
            "email" : appContainer.getUser().email! ,
            "user" : appContainer.getUser().userName!]
    }
    
    func createFollowersCollection(id : String){
        Firestore.firestore().collection("/Followers/\(id)/data").getDocuments { (snapShot, err) in
            
            if let snap = snapShot{
                
                if snap.isEmpty{
                    
                    let attrRef = Firestore.firestore().collection("Followers").document(id)
                    attrRef.setData(self.getDefaultCollectionData())
                }
            }
        }
    }
    
    func createLikeCollection(id : String){
        Firestore.firestore().collection("/Likes/\(id)/data").getDocuments { (snapShot, err) in
            
            if let snap = snapShot{
                
                if snap.isEmpty{
                    
                    let attrRef = Firestore.firestore().collection("Likes").document(id)
                    attrRef.setData(self.getDefaultCollectionData())
                }
            }
        }
    }
    
    func createFollowingCollection(id: String) {
        
        Firestore.firestore().collection("/Following/\(id)/data").getDocuments { (snapShot, err) in
            
            if let snap = snapShot{
                
                if snap.isEmpty{
                    
                    let attrRef = Firestore.firestore().collection("Following").document(id)
                    attrRef.setData(self.getDefaultCollectionData())
                }
            }
        }
    }
}
