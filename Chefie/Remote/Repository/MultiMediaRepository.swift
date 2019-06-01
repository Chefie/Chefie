//
//  MediaRepository.swift
//  Chefie
//
//  Created by Nicolae Luchian on 14/04/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

public struct MediaUploadResult {
    
    var url : String
    var contentType : String
    var rootPath : String
    
    var errors: [Error]?
    
    init(url : String, contentType : String, rootPath: String) {
        self.url = url
        self.contentType = contentType
        self.rootPath = rootPath
    }
}

public struct MediaUploadBatchResult {
    
    var result :  [MediaUploadResult]?
    var errors : [Error]?
}

class MultiMediaRepository {
    
    let imageContentType = "image/jpeg"
    let videoContentType = "video/mp4"
    
    let PLATES_PICTURES_ROOT = "plates/pictures/"
    let PLATES_MEDIA_ROOT = "plates/media/"

    func uploadImageBatch(dataArray: Array<Data>, completionHandler: @escaping (Result<MediaUploadBatchResult, Error>) -> Void ) -> Void  {

        let dispatchQueue = DispatchQueue(label: "UploadImageBatch", qos: .background)
        dispatchQueue.async{
         
            var batchCount = dataArray.count
            var resultArray = [MediaUploadResult]()
            var errors  : [Error]?
            while(batchCount != 0 ){
                
                self.uploadImage(data: dataArray [batchCount], completionHandler: { (
                    
                    result: Result<MediaUploadResult, Error>) in
                    
                    switch result {
                    case .success(let data):
                        
                        resultArray.append(data)
                        break
                    case .failure(let error):
                        
                        errors?.append(error)
                        break
                    }
                    
                    batchCount -= 1
                })
            }
            
            let result = MediaUploadBatchResult(result: resultArray, errors: errors)
            
            completionHandler(.success(result))
        }
    }
    
    func uploadImage(data : Data, completionHandler: @escaping (Result<MediaUploadResult, Error>) -> Void ) -> Void  {
        
        let uniqueId = UUID.init().uuidString
        let rootPath = PLATES_PICTURES_ROOT + uniqueId + ".jpg"
        
        let metadata = StorageMetadata()
        metadata.contentType = imageContentType
        
        let storageReference = Storage.storage().reference()
        let imageRef = storageReference.child(rootPath)
 
        _ = imageRef.putData(data, metadata: metadata) { (metadata, error) in
   
            imageRef.downloadURL { (url, error) in
                guard url != nil else {
                    completionHandler(.failure(error!))
                    return
                }
                
                completionHandler(.success(MediaUploadResult(url: url?.absoluteString ?? "", contentType: self.imageContentType, rootPath: rootPath)))
            }
        }
    }
}
