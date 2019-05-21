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

class UserRepository{
    
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
                            
                            let chefieUser = ChefieUser(email: _email, password: _pass)
                            
                            completionHandler(.success(chefieUser))
                        }
                        else{
                            completionHandler(.failure(err as! String))
                        }
                    })
                }
            }
        }
    }
    
    func getUsersFollowing(id: String){
        
    }
}
