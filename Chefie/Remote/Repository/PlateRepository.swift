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

public struct UploadRecipeResult {
    
    var timeStamp : Timestamp
    var succeded : Bool
}

class PlateRepository {
    
    func getPlatos(community: String, completionHandler: @escaping (ChefieResult<[Plate]>) -> Void ) -> Void {
        
        let platesRef = Firestore.firestore().collection("Platos")
        
        platesRef.whereField("community.id", isEqualTo: community).getDocuments(completion: { (querySnapshot, err) in
            
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
                
               
                completionHandler(.success(plates))

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
        let query = platesRef.whereField("idUser", isEqualTo: idUser).order(by: "timeStamp", descending: true)
        
        query.getDocuments(completion: { (querySnapshot, err) in
            
            var plates = Array<Plate>()
            
            if (querySnapshot?.documents) != nil {
                
                querySnapshot?.documents.forEach({ (document) in
                    do {
                        
                        let model = try FirestoreDecoder().decode(Plate.self, from: document.data())
                        plates.append(model)
                        
                        print("Model: \(model)")
                    } catch  {
                        print("Could not decode plate")
                    }
                })
                
                completionHandler(.success( plates))
            } else {
                completionHandler(.failure("Error"))
            }
        })
    }
    
    func getPlateLikesCount(idPlate: String, completionHandler: @escaping (Int) -> Void) -> Void {
    
         let collectionFollowings = Firestore.firestore().collection("/Likes/\(idPlate)/likes")
        
         collectionFollowings.getDocuments { (snapshot, err) in
            
            if let count = snapshot?.count {
                
                completionHandler(count)
            }
            else {
                completionHandler(0)
            }
        }
    }
    
    func checkIsLiked(idPlate: String, userId : String, completionHandler: @escaping (ChefieResult<Bool>) -> Void) -> Void {
        
        let likeCollection = Firestore.firestore().collection("/Likes/\(idPlate)/likes")
        let query = likeCollection.whereField("id", isEqualTo: userId)
        
        query.getDocuments(completion: { (querySnapshot, err) in
            
            if (err != nil){
                
                completionHandler(.failure(err!.localizedDescription))
                return
            }
            
            if !querySnapshot!.isEmpty {
                
                completionHandler(.success(true))
            }
            else {
                completionHandler(.success(false))
            }
        })
    }
    
    func insertLike(idPlate: String, user: UserMin, completionHandler: @escaping (ChefieResult<Bool>) -> Void) -> Void {
        
        let likeCollection = Firestore.firestore().collection("/Likes/\(idPlate)/likes")
        do {
            
            let model = try FirestoreEncoder().encode(user)
            likeCollection.addDocument(data: model) { err in
                
                if let err = err {
                    print("Error adding like: \(err)")
                    completionHandler(.success(false))
                } else {
                    completionHandler(.success(true))
                    print("Like añadido!")
                }
            }
        }
        catch {
            completionHandler(.failure("Fatal error when adding like"))
        }
    }
    
    func disLike(idPlate: String, user: UserMin, completionHandler: @escaping (ChefieBiResult<Bool, Bool>) -> Void) -> Void {
        
        let likeCollection = Firestore.firestore().collection("/Likes/\(idPlate)/likes")
        let query = likeCollection.whereField("id", isEqualTo: user.id!)
        
        query.getDocuments { (snapshot, err) in
            
            if let document = snapshot?.documents.first {
                
                document.reference.delete(completion: { (err) in
                    
                })
                
                completionHandler(.success(true))
                
                print("Like removed")
            }
            else {
                completionHandler(.failure(false))
                print("Error removing like")
            }
        }
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
    
    //    func checkIfLiked(idPlate: String, idLike: String, completionHandler: @escaping (ChefieResult<Bool>) -> Void) -> Void {
    //
    //        Firestore.firestore().collection("Plates")
    //            .whereField("idPlate", isEqualTo: idPlate)
    //            .whereField("likes", arrayContains: "\(idLike)").getDocuments { (querySnapshot, err) in
    //                if querySnapshot != nil {
    //                    completionHandler(ChefieResult.success(true))
    //                } else {
    //                    completionHandler(ChefieResult.success(false))
    //                }
    //        }
    //    }
    
    func uploadRecipe(plate : Plate, completionHandler: @escaping (ChefieResult<UploadRecipeResult>) -> Void) -> Void {
        
        do {
            
            let platesRef = Firestore.firestore().collection("Platos")
            let plateRef = platesRef.document()
            let documentId = plateRef.documentID
            
            plate.id = documentId
            var model = try FirestoreEncoder().encode(plate)
            
            let timeStamp = DateUtils.getCurrentTimeStamp()
            model["timeStamp"] = timeStamp
            
            platesRef.document(documentId).setData(model) { (err) in
                if err != nil {
                    print("Papito algo funciona mal")
  
                    completionHandler(.success(UploadRecipeResult(timeStamp: timeStamp, succeded: false)))
                } else {
                    print("Funcion upload Platillo")
                    print("Model: \(model)")
                    
                    Firestore.firestore().collection("Likes").document(documentId)
                        .setData(["PlateId" : documentId, "User" : plate.user!.userName!, "UserId" : plate.user!.id!]) {
                             err in
                            
                            if let err = err {
                                print("Error creating Plate's Likes Entry: \(err)")
                            } else {
                                
                                print("Plate's Like Entry created!")
                            }
                    }

                    completionHandler(.success(UploadRecipeResult(timeStamp: timeStamp, succeded: true)))
                }
            }
        }
        catch {
            completionHandler(.failure("Couldn't encode recipe"))
            print("Couldn't encode recipe")
        }
    }
    
    //    func uploadRecipe(plate: Plate) {
    //        let platesRef = Firestore.firestore().collection("Platos")
    //
    //        let plateRef = platesRef.document()
    //        do {
    //
    //            plate.id = plateRef.documentID
    //            var model = try FirestoreEncoder().encode(plate)
    //            model["timeStamp"] = DateUtils.getCurrentTimeStamp()
    //
    //            //   platesRef.document().setData(["": 1])
    //            //platesRef.document().setData(model)
    //            platesRef.addDocument(data: model) { (err) in
    //                if err != nil {
    //                    print("Papito algo funciona mal")
    //                } else {
    //                    print("Funcion upload Platillo")
    //                    print("Model: \(model)")
    //                }
    //            }
    //
    //        } catch  {
    //            print("Invalid Selection.")
    //        }
    //    }
    
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
