//
//  PlatosRepository.swift
//  Chefie
//
//  Created by Nicolae Luchian on 14/04/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase
class PlateRepository {
    
    func getPlatos(completionHandler: @escaping (ChefieResult<[Plate]>) -> Void ) -> Void {
        
        let platesRef = Firestore.firestore().collection("Platos")
        platesRef.getDocuments(completion: { (querySnapshot, err) in
            
            var plates = Array<Plate>()
            
            if let documents = querySnapshot?.documents {
                
                querySnapshot?.documents.forEach({ (document) in
                    do {
                        
                        let model = try FirestoreDecoder().decode(Plate.self, from: document.data())
                        model.id = document.documentID
                        plates.append(model)
                        
                        print("Model: \(model)")
                    } catch  {
                        print("Invalid Selection.")
                    }
                })
                
                let filteredPlates =  plates.map({ (plate) -> Plate in
                    
                    let multiMedia = plate.multimedia?.filter({ (media) -> Bool in
                        return media.type != "video"
                    })
                    
                    plate.multimedia = multiMedia
                    
                    return plate
                })
                
                
                completionHandler(.success( filteredPlates))
            } else {
                completionHandler(.failure(err as! String))
            }
        })
    }
    
    func getPlatos(idUser : String, completionHandler: @escaping (ChefieResult<[Plate]>) -> Void ) -> Void {
        
        let platesRef = Firestore.firestore().collection("Platos")
        let query = platesRef.whereField("idUser", isEqualTo: idUser)
   
        query.getDocuments(completion: { (querySnapshot, err) in
            
            var plates = Array<Plate>()

            if let documents = querySnapshot?.documents {
                
                querySnapshot?.documents.forEach({ (document) in
                    do {
                        
                        let model = try FirestoreDecoder().decode(Plate.self, from: document.data())
                        model.id = document.documentID
                        plates.append(model)
                        
                        print("Model: \(model)")
                    } catch  {
                        print("Invalid Selection.")
                    }
                })

              let filteredPlates =  plates.map({ (plate) -> Plate in
                    
                    let multiMedia = plate.multimedia?.filter({ (media) -> Bool in
                             return media.type != "video"
                    })
                    
                    plate.multimedia = multiMedia
                    
                    return plate
                })


                completionHandler(.success( filteredPlates))
            } else {
                completionHandler(.failure(err as! String))
            }
        })
    }

}
