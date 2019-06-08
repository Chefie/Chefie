//
//  MediaDownloadExtensions.swift
//  Chefie
//
//  Created by Steven on 28/04/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    typealias RectCalculationClosure = (_ parentSize: CGSize, _ newImageSize: CGSize)->(CGRect)
    
    func with(image named: String, rectCalculation: RectCalculationClosure) -> UIImage {
        return with(image: UIImage(named: named), rectCalculation: rectCalculation)
    }
    
    func with(image: UIImage?, rectCalculation: RectCalculationClosure) -> UIImage {
        
        if let image = image {
            UIGraphicsBeginImageContext(size)
            
            draw(in: CGRect(origin: .zero, size: size))
            image.draw(in: rectCalculation(size, image.size))
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
        }
        return self
    }
    
    func rawData() -> Data {
        
        let image = self
        let data = image.jpegData(compressionQuality: 1)
       
        return data ?? Data()
    }
    
    func drawDarkRect() -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        self.draw(at: CGPoint.zero)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(gray: 0, alpha: 0.5)
        context!.move(to: CGPoint(x: 0, y: 0))
        context!.fill(CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        context!.strokePath()
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resultImage!
    }
    
    func drawImageOnTop(image : UIImage) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        self.draw(at: CGPoint.zero)
    
        let context = UIGraphicsGetCurrentContext()
        context!.move(to: CGPoint(x: 0, y: 0))
        image.draw(in: CGRect(x: 0, y: 0, width: 24, height: 24))
       
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result!
    }
}

extension UIImageView {
    enum ImageAddingMode {
        case changeOriginalImage
        case addSubview
    }
    
    func drawOnCurrentImage(anotherImage: UIImage?, mode: ImageAddingMode, rectCalculation: UIImage.RectCalculationClosure) {
        
        guard let image = image else {
            return
        }
        
        switch mode {
        case .changeOriginalImage:
            self.image = image.with(image: anotherImage, rectCalculation: rectCalculation)
            
        case .addSubview:
            let newImageView = UIImageView(frame: rectCalculation(frame.size, image.size))
            newImageView.image = anotherImage
            addSubview(newImageView)
        }
    }
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
//    func tint(with color: UIColor) -> UIImage {
//        var image = UIImageRenderingMode(.alwaysTemplate)
//        UIGraphicsBeginImageContextWithOptions(size, false, scale)
//        color.set()
//        
//        image.draw(in: CGRect(origin: .zero, size: size))
//        image = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        return image
//    }
//    func loadFromRemote(url : String){
//        let finalUrl = URL(string:url) ?? URL(string: "")
//        let provider = LocalFileImageDataProvider(fileURL: finalUrl!)
//        
//        self.kf.setImage(with: provider)
//    }
    
//    func imageWithColor(color1: UIColor) -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, self.scale)
//        color1.setFill()
//
//        let context = UIGraphicsGetCurrentContext()
//        context?.translateBy(x: 0, y: self.frame.size.height)
//        context?.scaleBy(x: 1.0, y: -1.0)
//        context?.setBlendMode(CGBlendMode.normal)
//
//        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
//        context?.clip(to: rect, mask: self.cgImage!)
//        context?.fill(rect)
//
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return newImage!
//    }
    
    func roundedImage() {
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
//    func loadFromRemote(url : String, completionHandler: @escaping (Result<Image, Error>) -> Void) {
//        
//       // self.kf.indicatorType = .activity
//     //   let processor = DownsamplingImageProcessor(size: self.frame.size)
//     //       >> RoundCornerImageProcessor(cornerRadius: 0)
//        let finalUrl = URL(string:url) ?? URL(string: "")
//        let provider = LocalFileImageDataProvider(fileURL: finalUrl!)
//  
//        self.kf.setImage(with: provider) { (result : Result<RetrieveImageResult, KingfisherError>) in
//            
//            switch (result) {
//                
//            case .success(let data):
//                self.image = data.image
//                
//               completionHandler(.success(data.image))
//                break
//            case .failure(let _):
//                
//              //  completionHandler(.failure("Failure when loading remote image"))
//                  self.kf.indicatorType = .none
//                break
//            }
//        }
//    }
}

