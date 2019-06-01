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

class S3Repository {
    
    @objc lazy var transferUtility = {
        AWSS3TransferUtility.default()
    }()
    
     let S3BucketName = "stephendevit-qulqa"
    
    func uploadImage(data : Data) {
           
        
        transferUtility.uploadData(data, key: S3BucketName, contentType: "image/jpeg", expression: nil) { (task : AWSS3TransferUtilityUploadTask, error : Error?) in
            
            
        
        
            
            print("")
        }
    }
}
