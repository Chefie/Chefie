//
//  ProfileRoutesCellView.swift
//  Chefie
//
//  Created by Alex Lin on 30/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import SkeletonView
import SDWebImage
import AACarousel

class ProfileRouteCellItemInfo : BaseItemInfo {
    override func reuseIdentifier() -> String {
        return "ProfileRouteCellView"
    }
}

class ProfileRouteCellView : BaseCell, ICellDataProtocol, INestedCell, AACarouselDelegate {
    typealias T = Route
    var model: Route?
    var collectionItemSize: CGSize!
    
    let fontImageView : UIImageView = {
        let img = UIImageView(maskConstraints: false)
        img.contentMode = ContentMode.scaleAspectFill
        return img
    }()
    
    let routeTitle : MultilineLabel = {
        let lbl = MultilineLabel(maskConstraints: false, font: DefaultFonts.DefaultTextFont)
        lbl.text = ""
        lbl.numberOfLines = 1
        return lbl
    }()
    
    let carousel : AACarousel = {
        let view = AACarousel(maskConstraints: false)
        return view
    }()
    
    override func setModel(model: AnyObject?) {
        self.model = (model as! Route)
    }
    
    override func getModel() -> AnyObject? {
        return model
    }
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        
        self.contentView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
            maker.left.top.right.bottom.equalTo(0)
            maker.width.equalTo(size.width)
            maker.height.equalTo(collectionItemSize.height)
        }
        
        carousel.snp.makeConstraints { (maker) in
            
            maker.width.equalTo(collectionItemSize.width.minus(amount: 10))
            maker.height.equalTo(collectionItemSize.heightPercentageOf(amount: 88))
                maker.topMargin.equalTo(0)
                maker.bottomMargin.equalTo(10)
            maker.left.equalTo(collectionItemSize.widthPercentageOf(amount: 5))
        }
        
        self.routeTitle.snp.makeConstraints { (maker) in
            maker.width.equalTo(collectionItemSize.width.minus(amount: 20))
            maker.height.equalTo(collectionItemSize.heightPercentageOf(amount: 10))
                maker.bottomMargin.equalToSuperview().offset(4)
                maker.centerX.equalToSuperview()
        }
        
        carousel.setCarouselOpaque(layer: true, describedTitle: true, pageIndicator: false)
        
        self.carousel.setCornerRadius(radius: 8)
        
        routeTitle.displayLines(height: collectionItemSize.heightPercentageOf(amount: 10))

        contentView.showAnimatedGradientSkeleton()
    }
    
    override func onLoadData() {
        
        carousel.delegate = self
        
        let arrayStr = model?.multimedia?.map({ (media) -> String in
            return media.url ?? ""
        })
        
        carousel.setCarouselData(paths: arrayStr!,  describedTitle: [""], isAutoScroll: true, timer: 5.0, defaultImage: "placeholder")
        
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
        self.contentView.addSubview(carousel)
        //self.contentView.addSubview(frontImageView)
        self.contentView.addSubview(routeTitle)
    }
    
    
}
