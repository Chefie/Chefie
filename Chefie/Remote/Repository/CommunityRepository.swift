//
//  CommunityRepository.swift
//  Chefie
//
//  Created by user155921 on 6/1/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

class CommunityRepository {
    
    func getCommunities(completionHandler: @escaping (ChefieResult<[Community]>) -> Void ) -> Void {
        
        let communitiesRef = Firestore.firestore().collection("Community")
        communitiesRef.getDocuments { (querySnapshot, err) in
            
            var communities = Array<Community>()
            
            querySnapshot?.documents.forEach({ (document) in
                do {
                    
                    let model = try FirestoreDecoder().decode(Community.self, from: document.data())
                    model.id = document.documentID
                    communities.append(model)
                    
                   // print("Model: \(model)")
                } catch  {
                }
            })
            
            completionHandler(.success(communities))
        }
    }
}
