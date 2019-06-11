//
//  CommentRepository.swift
//  Chefie
//
//  Created by Nicolae Luchian on 14/04/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import CodableFirebase

class CommentRepository {
    
    func getComments(idRecipe: String,  completionHandler: @escaping (ChefieResult< [Comment]>) -> Void) -> Void {
        
        let reference = Firestore.firestore().collection("/Comments/\(idRecipe)/comments")
        
        reference.getDocuments { (querySnapshot, err) in
            
            if let snapshot = querySnapshot {
                
                if (snapshot.documents.isEmpty){
                    completionHandler(.failure("No Comments Found"))
                    return
                }
                
                var comments = Array<Comment>()
                
                snapshot.documents.forEach({ (document) in
                    
                    do {
                        
                        let model = try FirestoreDecoder().decode(Comment.self, from: document.data())
                        model.id = document.documentID
                        comments.append(model)
                    } catch {
                        
                        print("Invalid document for Comment")
                    }
                })
                
                
                completionHandler(.success(comments))
            }
            else {
                completionHandler(.failure("No Comments Found"))
            }
        }
    }
    
    func addComment(idRecipe : String, comment : Comment, completionHandler: @escaping (ChefieResult<Bool>) -> Void) -> Void {

        do {
            
            let reference = Firestore.firestore().collection("/Comments/\(idRecipe)/comments")
            let commentId = reference.document().documentID
        
            comment.id = commentId
            let model = try FirestoreEncoder().encode(comment)
            
            _ = reference
                .addDocument(data: model) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        
                        let attrRef = Firestore.firestore().collection("Comments").document("\(idRecipe)")
                        attrRef.setData([
                            "created_at" : Date().convertDateToString()])
                        completionHandler(.success(true))
                        print("Documento añadido!")
                    }
            }
        }
        catch {
            completionHandler(.failure("Error when sending comment"))
        }
    }
}
