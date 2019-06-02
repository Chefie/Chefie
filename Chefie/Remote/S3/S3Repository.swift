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

public struct S3MediaUploadResult {
    
    var url : String
    var contentType : String
    
    var errors: [Error]?
    
    init(url : String, contentType : String) {
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

enum ContentType: String {
    case Jpeg = "image/jpeg"
    case VideoMP4 = "video/mp4"
}

class S3Repository {
    
    @objc lazy var transferUtility = {
        AWSS3TransferUtility.default()
    }()
    
    let S3BucketName = "chefiebucket"
    let S3_URL = "https://chefiebucket.s3.amazonaws.com/"

    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }

    func uploadImage(data : Data, completionHandler: @escaping (Result<S3MediaUploadResult, Error>) -> Void ) -> Void {
        
        let path = "Images/" + UniqueIdentifierObject().getUniqueId()
        var completionCallback: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionCallback = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
              
                if error != nil {
                  
                    completionHandler(.failure(error!))
                    return
                }
                
                let result = S3MediaUploadResult(url: self.S3_URL + path, contentType: ContentType.Jpeg.rawValue)
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
    
    func uploadVideo(data: Data, completionHandler: @escaping (Result<MediaUploadResult, Error>) -> Void ) -> Void{
        
        let path = "Multimedia/" + UniqueIdentifierObject().getUniqueId() + ".mp4"
        var completionCallback: AWSS3TransferUtilityMultiPartUploadCompletionHandlerBlock?
        completionCallback = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                
                if error != nil {
                    
                    print("Error")
                }
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

