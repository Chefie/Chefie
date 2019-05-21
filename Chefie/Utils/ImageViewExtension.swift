//
//  MediaDownloadExtensions.swift
//  Chefie
//
//  Created by Steven on 28/04/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
        
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func loadFromRemote(url : String){
        let finalUrl = URL(string:url) ?? URL(string: "")
        let provider = LocalFileImageDataProvider(fileURL: finalUrl!)
        
        self.kf.setImage(with: provider)
    }
    
    func roundedImage() {
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    func loadFromRemote(url : String, completionHandler: @escaping (Result<Image, Error>) -> Void) {
        
       // self.kf.indicatorType = .activity
     //   let processor = DownsamplingImageProcessor(size: self.frame.size)
     //       >> RoundCornerImageProcessor(cornerRadius: 0)
        let finalUrl = URL(string:url) ?? URL(string: "")
        let provider = LocalFileImageDataProvider(fileURL: finalUrl!)
  
        self.kf.setImage(with: provider) { (result : Result<RetrieveImageResult, KingfisherError>) in
            
            switch (result) {
                
            case .success(let data):
                self.image = data.image
                
               completionHandler(.success(data.image))
                break
            case .failure(let _):
                
              //  completionHandler(.failure("Failure when loading remote image"))
                  self.kf.indicatorType = .none
                break
            }
        }
    }
}

