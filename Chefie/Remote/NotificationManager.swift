//
//  NotificationManager.swift
//  Chefie
//
//  Created by user155921 on 6/10/19.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftEntryKit
import CodableFirebase

class NotificationManager {
    
    public static let shared = NotificationManager()
    
    func createNotificationEntry() {
        
        let UID = appContainer.getUser().id!
        
        Firestore.firestore().collection("/Notifications/\(UID)/data").getDocuments { (snapShot, err) in
            
            if let snap = snapShot{
                
                if snap.isEmpty{
                    
                    let attrRef = Firestore.firestore().collection("Notifications").document(UID)
                    attrRef.setData([
                        "created_at" : Date().convertDateToString()])
                }
            }
        }
    }
    
    func listenForNotifications(){
        
        createNotificationEntry()
        
        let user = appContainer.getUser()
        let UID = user.id!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        let startTime: Date = formatter.date(from: Date().convertDateToString()) ?? Date(timeIntervalSince1970: 0)
        let startTimestamp: Timestamp = Timestamp(date: startTime)
        
        // Firestore.firestore().collection("/Notifications/\(UID)/data").addDocument(data: ["time":  startTimestamp])
        
        Firestore.firestore().collection("/Notifications/\(UID)/data").whereField("date", isGreaterThanOrEqualTo: startTimestamp)
            .addSnapshotListener { (snapshot, err) in
                
                if err != nil{
                    
                    print("Notification document snapshot failed")
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
                                
                                print("Notification document got : " + snap.documentID)
                                
                                self.parseNotification(doc: snap.data())
                            })
                        }
                    }
                }
        }
    }
    
    func getCurrentTimeStamp() -> Timestamp {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        let time: Date = formatter.date(from: Date().convertDateToString()) ?? Date(timeIntervalSince1970: 0)
        let timeStamp: Timestamp = Timestamp(date: time)
        
        return timeStamp
    }
    
    func sendPostLikeNotification(sender: UserMin, targetUser : UserMin, recipeTitle: String){
        
        do {
            let notification = NotificationSnapshot<NotificationPostLike>()
            notification.type = NotificationPostLike.NOTIFY_IDENTIFIER
            notification.data = NotificationPostLike(recipeTitle: recipeTitle)
            notification.sender = sender
            notification.targetUser = targetUser
            
            var encoded = try FirestoreEncoder().encode(notification)
            encoded["date"] = getCurrentTimeStamp()
            
            sendNotification(targetId: targetUser.id!, data: encoded, completionHandler:  {didSend in
                
                if (didSend){
                    
                }
            })
        }
        catch {
            
        }
    }
    
    func sendPostCommentNotification(sender: UserMin, targetUser : UserMin, title: String, comment : Comment){
        
        do {
            let notification = NotificationSnapshot<NotificationRecipeComment>()
            notification.type = NotificationRecipeComment.NOTIFY_IDENTIFIER
            notification.data = NotificationRecipeComment(comment: comment, recipeTitle: title)
            notification.sender = sender
            notification.targetUser = targetUser
            
            var encoded = try FirestoreEncoder().encode(notification)
            encoded["date"] = getCurrentTimeStamp()
            
            sendNotification(targetId: targetUser.id!, data: encoded, completionHandler:  {didSend in
                
                if (didSend){
                    
                }
            })
        }
        catch {
            
        }
    }
    
    func sendNotification(targetId: String, data : [String:Any], completionHandler: @escaping ((Bool)) -> Void ){
        
        Firestore.firestore().collection("/Notifications/\(targetId)/data").addDocument(data: data){
            err in
            
            if err != nil{
                
                completionHandler(false)
            }
            else{
                
                completionHandler(true)
            }
        }
    }
    
    private func parseNotification(doc : [String:Any]){
        
        do {
            
            let type = doc["type"] as! String
            switch type {
            case NotificationRecipeComment.NOTIFY_IDENTIFIER:
                
                let notificationSnap = try FirestoreDecoder().decode(NotificationSnapshot<NotificationRecipeComment>.self, from: doc)
                let message = "@" + notificationSnap.sender!.userName! + " commented on your recipe: " + notificationSnap.data!.recipeTitle!
                
                showNotification(title: message, text: (notificationSnap.data?.comment!.content)!)
                break
            case NotificationPostLike.NOTIFY_IDENTIFIER:
                
                let notificationSnap = try FirestoreDecoder().decode(NotificationSnapshot<NotificationPostLike>.self, from: doc)
                let message = "@" + notificationSnap.sender!.userName! + " liked your recipe: " + notificationSnap.data!.recipeTitle!
                
                showNotification(title: "Recipe Liked", text: message)
                break
            default:
                break
            }
        }
        catch {
            
        }
    }
    
    func showNotification(title: String = "", text: String = "", iconURL : String = "") {
        
        var attributes = EKAttributes.topToast
        attributes.entryBackground = .color(color: UIColor.white)
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        attributes.statusBar = .dark
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        
        let title = EKProperty.LabelContent(text: title, style: .init(font: DefaultFonts.DefaultTextFont, color: UIColor.orange))
        let description = EKProperty.LabelContent(text: text, style: .init(font: DefaultFonts.DefaultTextFont, color:  Palette.TextDefaultColor))
        let image = EKProperty.ImageContent(image: UIImage(named: "AppIcon")!, size: CGSize(width: 35, height: 35))
        
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}
