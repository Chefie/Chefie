//
//  FeedManager.swift
//  Chefie
//
//  Created by user155921 on 6/12/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftEntryKit
import CodableFirebase

class FeedManager {
    
    public static let shared = FeedManager()
    
    private func createFeedEntry(completionHandler: @escaping () -> Void) {
        let UID = appContainer.getUser().id!

        Firestore.firestore().collection("/Feed/\(UID)/data").getDocuments { (snapShot, err) in
            
            if let snap = snapShot{
                
                if snap.isEmpty{
                    
                    let attrRef = Firestore.firestore().collection("Feed").document(UID)
                    attrRef.setData(CollectionManager.shared.getDefaultCollectionData())
                }
            }
            
            completionHandler()
        }
    }
    
    func listenForFeed() {
    
        let UID = appContainer.getUser().id!
        
        createFeedEntry {
            
                let startTimestamp: Timestamp = DateUtils.getCurrentTimeStamp()
            Firestore.firestore().collection("/Feed/\(UID)/data").whereField("timeStamp", isGreaterThanOrEqualTo: startTimestamp).addSnapshotListener({ (snapshot, err) in
                
                if err != nil{
                    
                    print("Feed document snapshot failed")
                }
                else {
                    
                    if snapshot != nil{
                        
                        if !snapshot!.isEmpty{
                            
                            let addedDocuments = snapshot?.documentChanges.filter({ (document) -> Bool in
                                return document.type == DocumentChangeType.added
                            })
                            addedDocuments?.forEach({ (addedDocument) in
                                
                                let snap = addedDocument.document
                                
                                print(snap.documentID)
                                print(snap.data() as Any)
                                
                                print("Feed document got : " + snap.documentID)
                                
                                self.parseFeed(doc: snap.data())
                            })
                        }
                    }
                }
            })
        }
    }
    
    func parseFeed(doc : [String:Any]){
        
        do {

            let plate = try FirestoreDecoder().decode(Plate.self, from: doc)  
            EventContainer.shared.onNewPlateUploaded(plate: plate)
        }
        catch {
            
        }
    }
}
