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


public struct RetrievePlatesInfo{
    
    var currentOffset : Int = 0
    var limit: Int = 5
    var snapShot : QueryDocumentSnapshot?
    var data : [Plate]?
    
    mutating func update(result : RetrievePlatesInfo){
        
        if let data = result.data{
            
            self.currentOffset =  self.currentOffset + data.count
        }
    }
}


class PlateRepository {
    
    func getPlatos(completionHandler: @escaping (ChefieResult<[Plate]>) -> Void ) -> Void {
        
        let platesRef = Firestore.firestore().collection("Platos")
        platesRef.getDocuments(completion: { (querySnapshot, err) in
            
            var plates = Array<Plate>()
            
            if let documents = querySnapshot?.documents {
                
                querySnapshot?.documents.forEach({ (document) in
                    do {
                        
                        let model = try FirestoreDecoder().decode(Plate.self, from: document.data())
                   //     model.id = document.documentID
                        plates.append(model)
                        
                        print("Model: \(model)")
                    } catch  {
                        print("Invalid Selection.")
                    }
                })
                
                let filteredPlates = plates.map({ (plate) -> Plate in
                    
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
    
    var userRepository = UserRepository()

    func getPlatos(idUser : String, request: RetrievePlatesInfo, completionHandler: @escaping (ChefieResult<RetrievePlatesInfo>) -> Void ) -> Void {
        
        let platesRef = Firestore.firestore().collection("Platos")
     
    }
    
    func getPlatos(idUser : String, completionHandler: @escaping (ChefieResult<[Plate]>) -> Void ) -> Void {
        
        let platesRef = Firestore.firestore().collection("Platos")
        let query = platesRef.whereField("idUser", isEqualTo: idUser)
        
        query.getDocuments(completion: { (querySnapshot, err) in
            
            var plates = Array<Plate>()
            
            if (querySnapshot?.documents) != nil {
                
                querySnapshot?.documents.forEach({ (document) in
                    do {
                        
                        let model = try FirestoreDecoder().decode(Plate.self, from: document.data())
                        //      model.id = document.documentID
                        plates.append(model)
                        
                        print("Model: \(model)")
                    } catch  {
                        print("Could not decode plate")
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
    
    func giveLike(idPlate: String, idUser: String, completionHandler: @escaping (ChefieResult<Bool>) -> Void ) -> Void {
        
        let plateRef = Firestore.firestore().collection("Platos")
        plateRef.document("\(idPlate)").updateData([
            "likes" : "\(idUser)"])
        
    }
    
    func giveDislike(idPlate: String, idUser: String, completionHandler: @escaping (ChefieResult<Bool>) -> Void ) -> Void {
        
        let plateRef = Firestore.firestore().collection("Platos")
        plateRef.whereField("likes", arrayContains: "\(idUser)").getDocuments { (querySnapshot, err) in
            if querySnapshot != nil {
                
            }
        }
        plateRef.document("\(idPlate)").setData([
            "likes" : "[\(idUser)"])  
    }
    
    func checkIfLiked(idPlate: String, idLike: String, completionHandler: @escaping (ChefieResult<Bool>) -> Void) -> Void {
        
        Firestore.firestore().collection("Plates")
            .whereField("idPlate", isEqualTo: idPlate)
            .whereField("likes", arrayContains: "\(idLike)").getDocuments { (querySnapshot, err) in
                if querySnapshot != nil {
                    completionHandler(ChefieResult.success(true))
                } else {
                    completionHandler(ChefieResult.success(false))
                }
        }
    }
    
    func uploadRecipe(plate: Plate) {
        let platesRef = Firestore.firestore().collection("Platos")
        
        let plateRef = platesRef.document()
        do {
            
            plate.id = plateRef.documentID
            let model = try FirestoreEncoder().encode(plate)
            
            //   platesRef.document().setData(["": 1])
            //platesRef.document().setData(model)
            platesRef.addDocument(data: model) { (err) in
                if err != nil {
                    print("Papito algo funciona mal")
                } else {
                    print("Funcion upload Platillo")
                    print("Model: \(model)")
                }
            }
            
        } catch  {
            print("Invalid Selection.")
        }
    }
    
    func getLikesByPlate(idPlate: String, completionHandler: @escaping (ChefieResult<[LikeMin]>) -> Void) -> Void {
        
        //Coleccion Likes -> idPlato -> coleccion likesPlatos -> documentos(LikeMin)
        let collectionLikes = Firestore.firestore().collection("/Likes/\(idPlate)/likes")
        
        collectionLikes.getDocuments{ (querySnapshot, err) in
            var likes = Array<LikeMin>()
            
            if (querySnapshot?.documents) != nil{
                querySnapshot?.documents.forEach({ (document) in
                    do {
                        
                        //let raw = document.data()
                        let like = LikeMin()
                        like.username = ((document["username"] ?? "nil") as! String)
                        like.idLikeMin = ((document["idUserLike"] ?? "nil") as! String)
                        like.profilePic = ((document["profilePic"] ?? "nil") as! String)
                        
                        likes.append(like)
                        
                        
                        print("********---getLikesByPlate---**********")
                        print("Id -> \(String(describing: like.idLikeMin))")
                        print("Username -> \(String(describing: like.username))")
                        print("ProfilePic -> \(String(describing: like.profilePic))")
                        
                        completionHandler(.success(likes))
                    }
                })
            } else {
                completionHandler(.failure(err as! String))
            }
        }
    }
    
    
    func getDataFromSinglePlate(idPlate: String, completionHandler: @escaping (ChefieResult<Plate>) -> Void ) -> Void {
        
        let plateRef = Firestore.firestore().collection("Platos").document(idPlate)
        plateRef.getDocument(completion: { (document, err) in
            
            if let document = document, document.exists {
                
                do{
                    let dataDescription = document.data()
                    let model = try FirestoreDecoder().decode(Plate.self, from: dataDescription!)
                //    model.id = document.documentID
                    //let idUser = model.idUser
                    
                    print("****---getDataFromSinglePlate---******")
                    print("Id -> \(String(describing: model.id))")
                    print("Multimedia -> \(String(describing: model.multimedia))")
                    print("Likes -> \(String(describing: model.numLikes))")
                    
                    completionHandler(.success(model))
                } catch  {
                    
                    print("Invalid Selection.")
                }
                
            }else {
                
                completionHandler(.failure(err as! String))
                
                print("Document does not exist")
                
            }
            
        })
        
    }
}
