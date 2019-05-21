//
//  MutlimediaCell.swift
//  Chefie
//
//  Created by Nicolae Luchian on 05/05/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import RxSwift
import SDWebImage
import VersaPlayer

class MultimediaCell : UITableViewCell, ChefieCellViewProtocol{
   
    typealias T = Media
    
    var onAction: (() -> Void)?
    
    var parentView: UIView!{
        
        didSet{
            
            let size = CGSize(width: self.contentView.getWidth(), height: self.contentView.getHeight())
            
            onLayout(size: size)
        }
    }
    
    var model: Media?{
        
        didSet{

           onLoadData()
        }
    }
    
    let frontImageView : UIImageView = {
        
        let img = UIImageView(frame: CGRect())
        img.contentMode = ContentMode.scaleToFill
        img.isSkeletonable = true
        img.setRounded()
        img.setCornerRadius()
        return img
    }()
    
    let videoView : VersaPlayerView = {
        
        let view = VersaPlayerView()
        return view
    }()
    
    func onLayout(size: CGSize!) {
        
        frontImageView.layer.cornerRadius = 4
        frontImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(10)
            maker.top.equalTo(0)
            maker.width.equalTo(size.width - 20)
            maker.height.equalTo(size.height - 10)
        }
        
        videoView.setCornerRadius()
        videoView.snp.makeConstraints { (maker) in
            maker.left.equalTo(10)
            maker.top.equalTo(0)
            maker.width.equalTo(size.width - 20)
            maker.height.equalTo(size.height - 10)
        }

        
        self.showAnimatedGradientSkeleton()
    }
    
    func onCreateViews() {
        
        self.contentView.addSubview(frontImageView)
        self.contentView.addSubview(videoView)
        contentView.setTouch(target: self, selector: #selector(onTouch))
    }
    
    func onLoadData() {
     self.hideSkeleton()
        if (model?.type == "video"){
            
            frontImageView.isHidden = true
            videoView.isHidden = false
    
            if let url = URL.init(string: model?.url ?? "") {

                let item = VersaPlayerItem(url: url)
                videoView.set(item: item)
               
            }
        }
        else{
            
            frontImageView.isHidden = false
            videoView.isHidden = true
            
            frontImageView.sd_setImage(with: URL(string: model!.url!)) { (image : UIImage?,
                error : Error?, cacheType : SDImageCacheType, url : URL?) in
               // self.frontImageView.sd_cancelCurrentImageLoad()
                self.hideSkeleton()
            }
        }
    }
    
    @objc func onTouch() {
        
        print("Tapped")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        onCreateViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
