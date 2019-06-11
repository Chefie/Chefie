//
//  RouteCellView.swift
//  Chefie
//
//  Created by Alex Lin on 02/06/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import SkeletonView
import SDWebImage
import AACarousel

class RouteCellItemInfo : BaseItemInfo {
    
    override func reuseIdentifier() -> String {
        return "RouteCellView"
    }
}

class RouteCellView : BaseCell, ICellDataProtocol, INestedCell, AACarouselDelegate {
    
    typealias T = Route
    
    var model: Route?
    
    var collectionItemSize: CGSize!
    
    let carousel : AACarousel = {
        
        let view = AACarousel(maskConstraints: false)
        return view
    }()
    
    let routeTitle : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultHeaderTextFont)
        lbl.text = "Ruta Restaurantes Ametlla de Mar"
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        return lbl
    }()
    
    let labelNumLikes : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultHeaderTextLightFont)
        lbl.text = "89"
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        return lbl
    }()
    
    let labelMonth : UILabel = {
        let lbl = UILabel(maskConstraints: false, font: DefaultFonts.DefaultTextBoldFont)
        lbl.text = "FEB"
        lbl.textAlignment = .center
        lbl.textColor = .red
        //lbl.backgroundColor = .black
        return lbl
    }()
    
    let labelDay : UILabel = {
        let lbl = UILabel(maskConstraints: false, font: DefaultFonts.DefaultTextLightFont)
        lbl.text = "03"
        lbl.textAlignment = .center
        lbl.textColor = .black
        //lbl.backgroundColor = .red
        return lbl
    }()
    
    let labelUsername : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultTextLightFont)
        lbl.text = "@joseantonio"
        lbl.numberOfLines = 0
        //lbl.sizeToFit()
        lbl.textAlignment = .left
        //lbl.textColor = .gray
        //lbl.backgroundColor = .red
        return lbl
    }()
    
    let profilePicIcon : UIImageView = {
        let img = UIImageView(maskConstraints: false)
        img.contentMode = ContentMode.scaleToFill
        img.frame = CGRect(x: 0, y: 0, width: 27, height: 0)
        img.layer.borderColor = UIColor.black.cgColor
        img.layer.cornerRadius = img.frame.size.width / 2;
        img.clipsToBounds = true
        img.image = UIImage(named: "user")
        return img
    }()
    
    override func onLoadData() {
        carousel.delegate = self
        
        let arrayStr = model?.multimedia?.map({ (media) -> String in
            return media.url ?? ""
        })
        
        carousel.setCarouselData(paths: arrayStr!, describedTitle: [""], isAutoScroll: true, timer: 5.0, defaultImage: "placeholder")
        
        self.carousel.doFadeIn()
    }
    
    func didSelectCarouselView(_ view: AACarousel, _ index: Int) {
        
    }
    
    func callBackFirstDisplayView(_ imageView: UIImageView, _ url: [String], _ index: Int) {
        
    }
    
    func downloadImages(_ url: String, _ index: Int) {
        let url = URL(string: url)
        
        SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image : UIImage?, data : Data?, error : Error?, cache : SDImageCacheType, result : Bool, url : URL?) in
            
            if let data = image {
                self.carousel.images[index] = data
            }
            
            self.hideSkeleton()
        }
    }
    
    override func onCreateViews() {
        super.onCreateViews()
        
    }
    
    
    
    
}
