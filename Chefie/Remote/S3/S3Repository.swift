//
//  S3Repository.swift
//  Chefie
//
//  Created by DAM on 31/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import AWSS3
import AWSCore

public struct S3MediaUploadBatchResult {
    
    var result : [S3MediaUploadResult]
    var errors : [Error]?
}

public struct S3MediaUploadResult {
    
    var url : String
    var id : String
    var thumbnailUrl : String?
    var contentType : String
    var errors: [Error]?
    
    init(id: String, url : String, contentType : String) {
        self.id = id
        self.url = url
        self.contentType = contentType
    }
}

public struct UniqueIdentifierObject {

    func getCurrentMillis() -> Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    func getUniqueId() -> String {
        
        return String(format: "%ld", getCurrentMillis())
    }
}

public struct GetVideoDataResult {
    
    var thumbnailData : Data?
    var videoData : Data?
}

enum ContentType: String {
    case Jpeg = "image/jpeg"
    case VideoMP4 = "video/mp4"
}

class S3Repository {
    
    @objc lazy var transferUtility = {
        AWSS3TransferUtility.default()
    }()
    
    let S3BucketName = "eu.chefie"
    let S3_URL = "https://s3.eu-west-2.amazonaws.com/eu.chefie/"

    func getCurrentMillis()-> Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    func uploadImageBatch(dataArray : Array<Data>, completionHandler: @escaping (Result<S3MediaUploadBatchResult, Error>) -> Void ) {
        
        let dispatchQueue = DispatchQueue(label: "UploadImageS3Batch", qos: .background)
        dispatchQueue.async{
            
            let group = DispatchGroup()
            var resultArray = [S3MediaUploadResult]()
            var errors  : [Error]?
            
            dataArray.forEach({ (data) in
                group.enter()
                self.uploadImage(data: data, completionHandler: { (result : Result<S3MediaUploadResult, Error>) in
                    
                    switch result {
                    case .success(let data):
                        
                        resultArray.append(data)
                        break
                    case .failure(let error):
                        
                        errors?.append(error)      
                        group.leave()
                        break
                    }
                    
                    group.leave()
                })
            })

            group.wait()
            
            group.notify(queue: DispatchQueue.main) {
                let result = S3MediaUploadBatchResult(result: resultArray, errors: errors)
                completionHandler(.success(result))
            }
        }
    }

    func uploadImage(data : Data, completionHandler: @escaping (Result<S3MediaUploadResult, Error>) -> Void ) -> Void {
        
        let path = "Images/" + UniqueIdentifierObject().getUniqueId() + ".jpg"
        var completionCallback: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionCallback = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
              
                if error != nil {
                  
                    completionHandler(.failure(error!))
                    return
                }
                
                let result = S3MediaUploadResult(id: path,url: self.S3_URL + path, contentType: ContentType.Jpeg.rawValue)
                completionHandler(.success(result))
            })
        }
    
        transferUtility.uploadData(data,
                                   bucket: S3BucketName,
                                   key: path,
                                   contentType: ContentType.Jpeg.rawValue,
                                   expression: nil,
                                   completionHandler: completionCallback).continueWith {
                                    (task) -> AnyObject? in
                                    if let error = task.error {
                                        print("Error: \(error.localizedDescription)")
                                    }
                                    
                                    if let _ = task.result {
                                   
                                    }
                                    return nil;
        }
    }
    
    func uploadVideoBatch(dataArray : Array<GetVideoDataResult>, completionHandler: @escaping (Result<S3MediaUploadBatchResult, Error>) -> Void ) -> Void{
        let dispatchQueue = DispatchQueue(label: "UploadVideoS3Batch", qos: .background)
        dispatchQueue.async{
            
            let group = DispatchGroup()
            var resultArray = [S3MediaUploadResult]()
            var errors  : [Error]?
          
            dataArray.forEach({ (topResult) in
                group.enter()
                self.uploadVideo(data: topResult.videoData!, completionHandler: { (result : Result<S3MediaUploadResult, Error>) in
                    
                    switch result {
                    case .success(var data):
                        
                        self.uploadImage(data: topResult.thumbnailData! , completionHandler: { (result : Result<S3MediaUploadResult, Error>) in
                            
                            switch result {
                                
                            case .success(let thumbnailImage):
                                
                                data.thumbnailUrl = thumbnailImage.url
                                break
                            case .failure(_):
                                
                                group.leave()
                                break
                            }
                            
                            resultArray.append(data)
                            
                            group.leave()
                        })
                        
                        break
                    case .failure(let error):
                        
                        errors?.append(error)
                        
                        group.leave()
                        break
                    }
                })
            })
            
            group.wait()
            
            group.notify(queue: DispatchQueue.main) {
              
                let result = S3MediaUploadBatchResult(result: resultArray, errors: errors)
                completionHandler(.success(result))
            }
        }
    }
    
    func uploadVideo(data: Data, completionHandler: @escaping (Result<S3MediaUploadResult, Error>) -> Void ) -> Void{
        
        let path = "Multimedia/" + UniqueIdentifierObject().getUniqueId() + ".mp4"
        var completionCallback: AWSS3TransferUtilityMultiPartUploadCompletionHandlerBlock?
        completionCallback = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                
                if error != nil {
                    
                    completionHandler(.failure(error!))
                    return
                }
                
                let result = S3MediaUploadResult(id: path,url: self.S3_URL + path, contentType: ContentType.VideoMP4.rawValue)
                completionHandler(.success(result))
         
            })
        }
        
        transferUtility.uploadUsingMultiPart(data: data, bucket: S3BucketName, key: path, contentType: ContentType.VideoMP4.rawValue, expression: nil, completionHandler: completionCallback).continueWith {
            (task) -> AnyObject? in
            if let error = task.error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let _ = task.result {
                
            }
            return nil;
        }
    }
}

