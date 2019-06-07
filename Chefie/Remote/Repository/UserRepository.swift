//
//  UserRepository.swift
//  Chefie
//
//  Created by Nicolae Luchian on 07/04/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import FirebaseFirestore
import GoogleSignIn
import Firebase
import CodableFirebase

class UserRepository{
    
    func getUserById(id : String,completionHandler: @escaping (ChefieResult<ChefieUser>) -> Void) -> Void{
    
      let db = Firestore.firestore()
      let query = db.collection("Users").whereField("id", isEqualTo: id)
        
        query.getDocuments { (querySnapshot, err)  in
            
            if let snapshot = querySnapshot {
                
                if !snapshot.isEmpty {

                        do {
                            
                            let document = snapshot.documents.first!
                            let model = try FirestoreDecoder().decode(ChefieUser.self, from: document.data())
                            model.id = document.documentID
                            
                            completionHandler(.success(model))
                            print("GetUserById: \(model)")
                        } catch  {
                    
                            print("GetUserById: Error when decoding user")
                            completionHandler(.failure("GetUserById: Error when decoding user"))
                        }
                }
                else{
                    completionHandler(.failure("GetUserById: Snapshot is empty"))
                }
            }
            else {

                completionHandler(.failure("GetUserById: User with id \(id) not found"))
            }
        }
    }
    
    func login(email: String, password: String, completionHandler: @escaping (ChefieResult<ChefieUser>) -> Void) -> Void{
        
        Auth.auth().signIn(withEmail: email, password: password) {user, error in
            if error == nil && user != nil{
                
                if Auth.auth().currentUser != nil{
                    
                    let usersRef = Firestore.firestore().collection("Users")
                    let query = usersRef.whereField("email", isEqualTo: email)
                    
                    query.getDocuments(completion: { (querySnapshot, err) in
                        
                        if (querySnapshot != nil){
                            let doc = querySnapshot!.documents.first
                            let _email = doc?.data()["email"] as! String
                            let _pass = doc?.data()["password"] as! String
                            
//                            let chefieUser = ChefieUser(email: _email, password: _pass)
//
//                            completionHandler(.success(chefieUser))
                        }
                        else{
                            completionHandler(.failure(err as! String))
                        }
                    })
                }
            }
        }
    }
    
    func getAllUsers(offset : Int, completionHandler: @escaping (Result<[ChefieUser], Error>) -> Void){
      
        let usersRef = Firestore.firestore().collection("Users").limit(to: offset)

        usersRef.getDocuments(completion: { (querySnapshot, err) in
        
            var users = [ChefieUser]()
   
            if (querySnapshot?.documents) != nil {
                
                querySnapshot?.documents.forEach({ (document) in
                    do {
                        
                        let model = try FirestoreDecoder().decode(ChefieUser.self, from: document.data())
                        model.id = document.documentID
                        users.append(model)
                        
                        print("Model: \(model)")
                    } catch  {
                        print("Invalid Selection.")
                    }
                })
          
                completionHandler(.success(users))
            } else {
              //  completionHandler(.failure(err ?? Error))
            }
        })
    }
    
    func getUsersFollowing(id: String){
        
    }
    
    
    func updateUserAtts(user: ChefieUser){
        let sfReference = Firestore.firestore().collection("Users").document(user.id!)
        
        /*  sfReference.runTransaction({ (transaction, errorPointer) -> Any? in
         let sfDocument: DocumentSnapshot
         do {
         try sfDocument = transaction.getDocument(sfReference)
         } catch let fetchError as NSError {
         errorPointer?.pointee = fetchError
         return nil
         }
         
         guard let oldPopulation = sfDocument.data()?["population"] as? Int else {
         let error = NSError(
         domain: "AppErrorDomain",
         code: -1,
         userInfo: [
         NSLocalizedDescriptionKey: "Unable to retrieve population from snapshot \(sfDocument)"
         ]
         )
         errorPointer?.pointee = error
         return nil
         }
         
         transaction.updateData(["population": oldPopulation + 1], forDocument: sfReference)
         return nil
         }) { (object, error) in
         if let error = error {
         print("Transaction failed: \(error)")
         } else {
         print("Transaction successfully committed!")
         }
         }*/
    }
    
    func getProfileData(idUser : String, completionHandler: @escaping (ChefieResult<ChefieUser>) -> Void) -> Void {
        
        let user = Firestore.firestore().collection("Users").document(idUser)
        
        user.getDocument { (document, err) in
            
            if let document = document, document.exists {
                
                do{
                    
                    let dataDescription = document.data()
                    let model = try FirestoreDecoder().decode(ChefieUser.self, from: dataDescription!)
                    model.id = document.documentID
                    
                    print("Id -> \(String(describing: model.id))")
                    print("Username -> \(String(describing: model.userName))")
                    print("Followers -> \(String(describing: model.followers))")
                    print("Following -> \(String(describing: model.following))")
                    print("ProfilePic -> \(String(describing: model.profilePic))")
                    print("BackgroundPic -> \(String(describing: model.profileBackgroundPic))")
                    
                    completionHandler(.success(model))
                    
                } catch  {
                    
                    print("Invalid Selection.")
                    
                }
                
            }else {
                
                completionHandler(.failure(err as! String))
                
                print("Document does not exist")
                
            }
            
        }
        
    }
    
    func getUserMinByID(idUser: String, completionHandler: @escaping (ChefieResult<UserMin>) -> Void) -> Void {
        
        let userMinRef = Firestore.firestore().collection("Users")
        let query = userMinRef.whereField("id", isEqualTo: idUser)
        
        query.getDocuments(completion: { (querySnapshot, err) in
            
            if (querySnapshot != nil){
                let doc = querySnapshot!.documents.first
                let _id = doc?.data()["id"] as! String
                let _profilePic = doc?.data()["profilePic"] as! String
                let _username = doc?.data()["userName"] as! String
                
                var userMin = UserMin()
                userMin.id = _id
                userMin.profilePic = _profilePic
                userMin.userName = _username
                
                completionHandler(.success(userMin))
            }
            else{
                completionHandler(.failure(err as! String))
            }
        })
        
        //        userMinRef.getDocument(completion: { (document, err) in
        //
        //            if let document = document, document.exists {
        //
        //                do{
        //
        //                    let dataDescription = document.data()
        //                    let model = try FirestoreDecoder().decode(UserMin.self, from: dataDescription!)
        //                    model.id = document.documentID
        //                    print("********---getUserMinByID---**********")
        //                    print("Id -> \(String(describing: model.id))")
        //                    print("Username -> \(String(describing: model.userName))")
        //                    print("ProfilePic -> \(String(describing: model.profilePic))")
        //
        //                    completionHandler(.success(model))
        //                } catch  {
        //
        //                    print("Invalid Selection.")
        //                }
        //
        //            }else {
        //
        //                completionHandler(.failure(err as! String))
        //
        //                print("Document does not exist")
        //
        //            }
        
        
    }
    
    
    
    func getUserFollowers(idUser: String, completionHandler: @escaping (ChefieResult<[FollowMin]>) -> Void) -> Void {
        
        //let followerRef = Firestore.firestore().collection("Followers").document("UaD5Xq6t3OtXSNINTMu7")
        
        let collectionFollowers = Firestore.firestore().collection("/Followers/\(idUser)/followers")
        
        collectionFollowers.getDocuments { (querySnapshot, err) in
            
            var followers = Array<FollowMin>()
            
            if (querySnapshot?.documents) != nil{
                querySnapshot?.documents.forEach({ (document) in
                    do{
                        let follower = FollowMin()
                        follower.username = ((document["username"] ?? "nil") as! String)
                        follower.idFollower = ((document["idFollower"] ?? "nil") as! String)
                        follower.profilePic = ((document["profilePic"] ?? "nil") as! String)
                        
                        let model = try FirestoreDecoder().decode(UserMin.self, from: document.data())
                        model.id = document.documentID
                        
                        followers.append(follower)
                        print("********---getUserFollowrs---**********")
                        print("Id -> \(String(describing: follower.idFollower))")
                        print("Username -> \(String(describing: follower.username))")
                        print("ProfilePic -> \(String(describing: follower.profilePic))")
                        
                        completionHandler(.success(followers))
                        
                    } catch  {
                        completionHandler(.failure(err as! String))
                        
                        print("Invalid Selection.")
                        
                    }
                    
                })
            }
            
        }
    }
    
    
    
    
    //TODO: Las variables excepto el idUser van a ser opcionales
    func updateUserProfile(idUser: String, username: String, password: String, bio: String, genero: String, location: String, commmunity: String, profilePic: String, backgroundPic: String, deleteAccount: Bool, completionHandler: @escaping (ChefieResult<Bool>) -> Void) -> Void {
        
        let db = Firestore.firestore()
        let userReference = Firestore.firestore().collection("Users").document(idUser)
        
        if (deleteAccount == true){
            //Codigo para borrar el account
            userReference.delete() { err in
                if err != nil {
                    
                    completionHandler(.success(true))
                } else {
                    completionHandler(.success(false))
                }
            }
        } else {
            db.runTransaction({ (transaction, errorPointer) -> Any? in
                let sfDocument: DocumentSnapshot
                do {
                    
                    try sfDocument = transaction.getDocument(userReference)
                    
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                transaction.updateData(["userName": username], forDocument: userReference)
                transaction.updateData(["password": password], forDocument: userReference)
                transaction.updateData(["bio": bio], forDocument: userReference)
                transaction.updateData(["genero": genero], forDocument: userReference)
                transaction.updateData(["location": location], forDocument: userReference)
                transaction.updateData(["community": commmunity], forDocument: userReference)
                transaction.updateData(["profilePic": profilePic], forDocument: userReference)
                transaction.updateData(["backgroundProfilePic": backgroundPic], forDocument: userReference)
                return true
            }) { (object, error) in
                if let error = error {
                    print("Transaction failed: \(error)")
                } else {
                    print("Transaction successfully committed!")
                }
                
            }
        }
        
    }
    
    
    
    func addFollower(idUser: String, idFollower: String, completionHandler: @escaping (ChefieResult<Bool>) -> Void) -> Void {
        var isFollowing: Bool = false
        //var ref: DocumentReference? = nil
        var followerMin = FollowMin()
        
        
        appContainer.userRepository.getUserMinByID(idUser: idFollower) { (result: (ChefieResult<UserMin>)) in
            switch result {
            case .success(let data):
                followerMin.idFollower = data.id
                followerMin.username = data.userName
                followerMin.profilePic = data.profilePic
                let collectionFollowers = Firestore.firestore().collection("/Followers/\(idUser)/followers")
                    .addDocument(data: [
                        "idFollower": followerMin.idFollower!,
                        "profilePic": followerMin.profilePic!,
                        "username": followerMin.username!
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            isFollowing = true
                            let attrRef = Firestore.firestore().collection("Followers").document("\(idUser)")
                            attrRef.setData([
                                "created_at" : "Chefie.date"])
                            completionHandler(.success(true))
                            print("Documento añadido!")
                        }
                        
                }
                break
            case .failure(_):
                completionHandler(.success(false))
                break
            }
            
        }
    
    }
    
    func removeFollower(idUser: String, idFollower: String, completionHandler: @escaping (ChefieResult<Bool>) -> Void) -> Void {
        var isRemoved: Bool = false
        let collectionFollowers = Firestore.firestore().collection("/Followers/\(idUser)/followers")
        let query = collectionFollowers.whereField("idFollower", isEqualTo: idFollower)
        
        query.getDocuments(completion: { (querySnapshot, err) in
            
            if (querySnapshot != nil){
                
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
                isRemoved = true
                
                completionHandler(.success(true))
                
            }
            else{
                isRemoved = false
                print("Error removing document: \(String(describing: err))")
                completionHandler(.success(false))
            }
        })
    }
    
    
    
    func checkIfFollowing(idUser: String, idFollower: String, completionHandler: @escaping (ChefieResult<Bool>) -> Void) -> Void {
        var isFollowing: Bool = false
        let collectionFollowers = Firestore.firestore().collection("/Followers/\(idUser)/followers")
        let query = collectionFollowers.whereField("idFollower", isEqualTo: idFollower)
        
        query.getDocuments(completion: { (querySnapshot, err) in
            
            
            if querySnapshot!.isEmpty {
                
                isFollowing = false
                completionHandler(.success(isFollowing))
            }
            else {
                isFollowing = true
                completionHandler(.success(isFollowing))
            }

        })
       
    }
    

    
    func removeFollowerFollowing(idUser: String, idFollowing: String, completionHandler: @escaping (ChefieResult<Bool>) -> Void) -> Void {
        var isRemoved: Bool = false
        let collectionFollowers = Firestore.firestore().collection("/Following/\(idUser)/following")
        let query = collectionFollowers.whereField("idUserTarget", isEqualTo: idFollowing)
        query.getDocuments(completion: { (querySnapshot, err) in
            
            if (querySnapshot != nil){
                
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
                isRemoved = true
                
                completionHandler(.success(true))
                
            }
            else{
                isRemoved = false
                print("Error removing document: \(String(describing: err))")
                completionHandler(.success(false))
            }
        })
    }
    
    func addFollowerFollowing(idUser: String, idFollowing: String, completionHandler: @escaping (ChefieResult<Bool>) -> Void) -> Void {
        //var ref: DocumentReference? = nil
        var followerMin = FollowMin()
        
        appContainer.userRepository.getUserMinByID(idUser: idFollowing) { (result: (ChefieResult<UserMin>)) in
            switch result {
            case .success(let data):
                followerMin.idFollower = data.id
                followerMin.username = data.userName
                followerMin.profilePic = data.profilePic
                let collectionFollowers = Firestore.firestore().collection("/Following/\(idUser)/following")
                    .addDocument(data: [
                        "idFollower": followerMin.idFollower!,
                        "profilePic": followerMin.profilePic!,
                        "username": followerMin.username!
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            let attrRef = Firestore.firestore().collection("Following").document("\(idUser)")
                            attrRef.setData([
                                "created_at" : "Chefie.date"])
                            completionHandler(.success(true))
                            print("Documento añadido!")
                        }
                        
                }
                break
            case .failure(_):
                completionHandler(.success(false))
                break
            }
            
        }
        
    }
    
}



