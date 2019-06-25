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

public struct RetrieveFollowingInfo{
    
    var currentOffset : Int = 0
    var limit: Int = 5
    var snapShot : QueryDocumentSnapshot?
    var data : [UserMin]?
    
    mutating func update(result : RetrieveFollowingInfo){
        
        if let data = result.data{
            
            self.currentOffset =  self.currentOffset + data.count
        }
    }
}

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
                        //   model.id = document.documentID
                        
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
    
    func getFollowingUsers(idUser: String, request: RetrieveFollowingInfo, completionHandler: @escaping (ChefieResult<RetrieveFollowingInfo>) -> Void ) -> Void {
        
        let collectionFollowings = Firestore.firestore().collection("/Following/\(idUser)/following")
        
        _ = collectionFollowings.limit(to: request.limit).getDocuments { (snapShot, err) in
            
            if (snapShot?.documents) != nil {
                var result = RetrieveFollowingInfo()
                var following = Array<UserMin>()
                
                if !snapShot!.documents.isEmpty {
                    
                    snapShot?.documents.forEach({ (document) in
                        do {
                            
                            let model = try FirestoreDecoder().decode(UserMin.self, from: document.data())
                            following.append(model)
                            
                            print("Model: \(model)")
                        } catch  {
                            print("Could not decode plate")
                        }
                    })
                    
                    result.snapShot = snapShot?.documents.last
                }
                
                result.data = following
                
                completionHandler(.success(result))
            } else {
                completionHandler(.failure(err as! String))
            }
        }
    }
    
    func getAllUsers(community : String, completionHandler: @escaping (Result<[ChefieUser], Error>) -> Void){
        
        let usersRef = Firestore.firestore().collection("Users")
        
        usersRef.whereField("community", isEqualTo: community).getDocuments(completion: { (querySnapshot, err) in
            
            var users = [ChefieUser]()
            
            if (querySnapshot?.documents) != nil {
                
                querySnapshot?.documents.forEach({ (document) in
                    do {
                        
                        let model = try FirestoreDecoder().decode(ChefieUser.self, from: document.data())
                        users.append(model)
                        
                        print("Model: \(model)")
                    } catch  {
                        print("Invalid Selection.")
                    }
                })
                
                completionHandler(.success(users))
            } else {
                // completionHandler(.failure(err?.localizedDescription))
            }
        })
    }
    
    func getUserFollowersCount(userId: String, completionHandler: @escaping (Int) -> Void) -> Void {
        
        let collectionFollowers = Firestore.firestore().collection("/Followers/\(userId)/followers")
        
        collectionFollowers.getDocuments { (snapshot, err) in
            
            completionHandler(snapshot?.count ?? 0)
        }
    }
    
    func getUserFollowingCount(userId: String, completionHandler: @escaping (Int) -> Void) -> Void {
        
        let collectionFollowings = Firestore.firestore().collection("/Following/\(userId)/following")
        
        collectionFollowings.getDocuments { (snapshot, err) in
            
            completionHandler(snapshot?.count ?? 0)
        }
    }
    
    func getProfileData(idUser : String, completionHandler: @escaping (ChefieResult<ChefieUser>) -> Void) -> Void {
        
        let user = Firestore.firestore().collection("Users")
        let query = user.whereField("id", isEqualTo: idUser)
        query.getDocuments { (snapshot, err) in
            
            if let documents = snapshot?.documents  {
                
                if !documents.isEmpty {
                    
                    do{
                        
                        let model = try FirestoreDecoder().decode(ChefieUser.self, from:  documents.first!.data())
                        //  model.id = document.documentID
                        
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
                }
                else {
                    completionHandler(.failure("Failed to get profile data"))
                    print("Failed to get profile data")
                }
            }
        }
    }
    
    func getUserMinByID(idUser: String, completionHandler: @escaping (ChefieResult<UserMin>) -> Void) -> Void {
        
        let userMinRef = Firestore.firestore().collection("Users")
        let query = userMinRef.whereField("id", isEqualTo: idUser)
        
        query.getDocuments(completion: { (querySnapshot, err) in
            
            if (querySnapshot != nil){
                
                do {
                    let doc = querySnapshot!.documents.first
                    let result = try FirebaseDecoder().decode(UserMin.self, from: doc!.data())
                    
                    completionHandler(.success(result))
                }
                catch {
                    
                    let msg = "Couldn't decode User Min from user: " + idUser
                    print(msg)
                    completionHandler(.failure(msg))
                }
            }
            else{
                completionHandler(.failure(err as! String))
            }
        })
    }
    
    func getUserFollowers(idUser: String, completionHandler: @escaping (ChefieResult<[UserMin]>) -> Void) -> Void {
        
        let collectionFollowers = Firestore.firestore().collection("/Followers/\(idUser)/followers")
        collectionFollowers.getDocuments { (querySnapshot, err) in
            
            var followers = Array<UserMin>()
            
            if (querySnapshot?.documents) != nil{
                querySnapshot?.documents.forEach({ (document) in
                    do{
                        
                        let follower = try FirebaseDecoder().decode(UserMin.self, from: document.data())
                        followers.append(follower)
                        
                        print("********---getUserFollowers---**********")
                        print("Id -> \(String(describing: follower.id))")
                        print("Username -> \(String(describing: follower.userName))")
    
                    } catch  {
                        print("Could'nt decode User Follower")
                    }
                })
            }
            
            completionHandler(.success(followers))
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
        
        appContainer.userRepository.getUserMinByID(idUser: idFollower) { (result: (ChefieResult<UserMin>)) in
            switch result {
            case .success(let data):
                
                do {
                    
                    let followerUserMin = try FirestoreEncoder().encode(data)
                    Firestore.firestore().collection("/Followers/\(idUser)/followers")
                        .addDocument(data: followerUserMin) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                
                                completionHandler(.success(true))
                                print("Documento añadido!")
                            }
                            
                    }
                }
                catch {
                    completionHandler(.success(false))
                }
                
                break
            case .failure(_):
                completionHandler(.success(false))
                break
            }
        }
    }
    
    func removeFollower(idUser: String, idFollower: String, completionHandler: @escaping (ChefieResult<Bool>) -> Void) -> Void {
        
        let collectionFollowers = Firestore.firestore().collection("/Followers/\(idUser)/followers")
        let query = collectionFollowers.whereField("id", isEqualTo: idFollower)
        
        query.getDocuments(completion: { (querySnapshot, err) in
            
            if (querySnapshot != nil){
                
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
                
                completionHandler(.success(true))
            }
            else{
                
                print("Error removing document: \(String(describing: err))")
                completionHandler(.success(false))
            }
        })
    }
    
    func checkIfFollowing(idUser: String, idFollower: String, completionHandler: @escaping (ChefieResult<Bool>) -> Void) -> Void {
        var isFollowing: Bool = false
        let collectionFollowers = Firestore.firestore().collection("/Followers/\(idUser)/followers")
        let query = collectionFollowers.whereField("id", isEqualTo: idFollower)
        
        query.getDocuments(completion: { (querySnapshot, err) in
            
            if (err != nil){
                
                completionHandler(.failure(err!.localizedDescription))
                return
            }
            
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
    
    func removeFollowing(follower: String, idTargetUser: String, completionHandler: @escaping (ChefieResult<Bool>) -> Void) -> Void {
        
        let collectionFollowings = Firestore.firestore().collection("/Following/\(follower)/following")
        let query = collectionFollowings.whereField("id", isEqualTo: idTargetUser)
        query.getDocuments(completion: { (querySnapshot, err) in
            
            if (querySnapshot != nil){
                
                let documents = querySnapshot!.documents.compactMap({ (snap) -> [String:Any]? in
                    return snap.data()
                })
                
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
                
                completionHandler(.success(true))
            }
            else{
                print("Error removing document: \(String(describing: err))")
                completionHandler(.success(false))
            }
        })
    }
    
    func addFollowing(follower: UserMin, targetUser: UserMin, completionHandler: @escaping (ChefieResult<Bool>) -> Void) -> Void {
        
        do {
            
            let followerId = follower.id!
            let followTargetData = try FirestoreEncoder().encode(targetUser)
            
            let collectionFollowers = Firestore.firestore().collection("/Following/\(followerId)/following")
                .addDocument(data: followTargetData) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        //                        let attrRef = Firestore.firestore().collection("Following").document("\(followerId)")
                        //                        attrRef.setData([
                        //                            "created_at" : Date().convertDateToString() ])
                        completionHandler(.success(true))
                        print("Documento añadido!")
                    }
            }
        }
        catch {
            
        }
    }
    
    func updateUserImageData(userMin: UserMin, completionHandler: @escaping (ChefieResult<Bool>) -> Void) -> Void {
        
        Firestore.firestore().collection("Users")
            .whereField("id", isEqualTo: userMin.id!)
            .getDocuments { (querySnapshot, err) in
                let document = querySnapshot!.documents.first
                document!.reference.updateData([
                    "profilePic": userMin.profilePic  ?? "",
                    "profileBackgroundPic": userMin.profileBackground  ?? ""
                    ])
                
                completionHandler(.success(true))
        }
    }
    
    func updateUserDataGlobally(userMin: UserMin) -> Void {
        
        let platesQuery = Firestore.firestore().collection("Platos")
            .whereField("idUser", isEqualTo: userMin.id!)
        let dispatchQueue = DispatchQueue(label: "UpdateUserDataGlobally", qos: .background)
        
        var encoded = [String:Any]()
        dispatchQueue.async{
            
            let group = DispatchGroup()
            
            group.enter()
            platesQuery.getDocuments { (snapshot, err) in
                
                group.leave()
                do {
                    
                    encoded = try FirestoreEncoder().encode(userMin)
                    
                    snapshot?.documents.forEach({ (document) in
                        
                        group.enter()
                        document.reference.updateData(["user" : encoded], completion: { (err) in
                            
                            group.leave()
                            print ("Updated My Plates Globally")
                            
                        })
                    })
                }
                catch {
                    
                }
            }
            
            group.wait()
            
            let myFeed = Firestore.firestore().collection("/Feed/\(userMin.id!)/data")
            
            group.enter()
            myFeed.whereField("idUser", isEqualTo: userMin.id!).getDocuments(completion: { (snapshot, err) in
                
                group.leave()
                
                snapshot?.documents.forEach({ (document) in
                    
                    group.enter()
                    document.reference.updateData(["user" : encoded], completion: { (err) in
                        
                        print ("Updated My Feed")
                         EventContainer.shared.HomeSubject.on(.next(EventContainer.HOME_FEED_SHOULD_REFRESH))
                        group.leave()
                    })
                })
            })
            
            group.wait()
            
            group.enter()
            self.getUserFollowers(idUser: userMin.id!, completionHandler: { (result :ChefieResult<[UserMin]>) in
                
                switch result {
                    
                case .success(let data):
                        group.leave()
                    data.forEach({ (user) in
                        
                        group.enter()
                        
                        let collection = Firestore.firestore().collection("/Feed/\(user.id ?? "")/data")
                        
                        collection.whereField("idUser", isEqualTo: userMin.id!).getDocuments {
                            (snapshot, err) in
                            
                            group.leave()
                            snapshot?.documents.forEach({ (document) in
                                
                                group.enter()
                                document.reference.updateData(["user" : encoded], completion: { (err) in
                                    
                                    print ("Updated Other User Feed")
                                    
                                    group.leave()
                                })
                            })
                        }
                    })

                    break
                case .failure(_):
                    break
                }
            })
            
            group.wait()
            
            group.notify(queue: .main, execute: {
                 print("Finished Updated User Globally")
                EventContainer.shared.HomeSubject.on(.next(EventContainer.HOME_FEED_SHOULD_REFRESH))
            })
        }
    }
}



