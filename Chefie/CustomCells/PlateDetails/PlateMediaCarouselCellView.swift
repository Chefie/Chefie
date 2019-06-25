//
//  PlateMediaCarouselCellView.swift
//  Chefie
//
//  Created by Nicolae Luchian on 05/06/2019.
//  Copyright © 2019 chefie. All rights reserved.
//

import Foundation
import FSPagerView
import SDWebImage
import Lightbox

class PlateMediaCarousellItemInfo : BaseItemInfo {
    
    override func reuseIdentifier() -> String {
        return "PlateMediaCarousellCellView"
    }
}

class PlateMediaCarousellCellView : BaseCell, ICellDataProtocol, FSPagerViewDataSource,FSPagerViewDelegate {
    
    var model: Plate?

    var multimedia = [Media]()
    
    typealias T = Plate
    
    let pagerView : FSPagerView = {
        
        let view = FSPagerView(maskConstraints: false)
        return view
    }()
    
    override func setModel(model: AnyObject?) {
        self.model = (model as! Plate)
    }
    
    override func getModel() -> AnyObject? {
        return model as AnyObject?
    }
    
    override func getSize() -> CGSize {
        return CGSize(width: parentView.getWidth(), height: parentView.heightPercentageOf(amount: 30))
    }
    
    override func onLayout(size: CGSize!) {
        super.onLayout(size: size)
        
        let size = getSize()
        
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(0)
            maker.edges.equalToSuperview()
            maker.size.equalTo(size)
        }
        
        pagerView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        pagerView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(0)
            maker.size.equalTo(size)
        }
        
        let transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        self.pagerView.itemSize = self.pagerView.frame.size.applying(transform)
        self.pagerView.decelerationDistance = 1
        
        self.showAnimatedGradientSkeleton()
    }
    
    override func onLoadData() {
        super.onLoadData()

       if let mediaList = model?.multimedia {
            
            multimedia.removeAll()
            multimedia.append(contentsOf: mediaList)
        }
        
        pagerView.reloadData()
    }
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return multimedia.count
    }

    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {

        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let mediaInfo = multimedia[index]
        cell.contentView.setCornerRadius(radius: 4)
        cell.contentView.addShadow(radius: 6)
        if mediaInfo.type == ContentType.VideoMP4.rawValue {
            
            cell.imageView?.sd_setImage(with: URL(string: mediaInfo.thumbnail ?? "")){ (image : UIImage?,
                error : Error?, cacheType : SDImageCacheType, url : URL?) in

                self.hideSkeleton()
            }
        }
        else {
            
            cell.imageView?.sd_setImage(with: URL(string: mediaInfo.url ?? "")){ (image : UIImage?,
                error : Error?, cacheType : SDImageCacheType, url : URL?) in
                      self.hideSkeleton()
            }
        }

        cell.imageView?.contentMode = .scaleToFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    @objc func onOpenLightBox() {
        
        if let media = self.model?.multimedia {
            
           let items = media.compactMap({ (media) -> LightboxImage? in
                
                if media.type == ContentType.Jpeg.rawValue {
                    
                    return LightboxImage(imageURL: URL(string: media.url!)!)
                }
                else if (media.type == ContentType.VideoMP4.rawValue){
                    return LightboxImage(imageURL: URL(string: media.thumbnail!)!, text: "", videoURL: URL(string: media.url!))
                }
                
                return LightboxImage(image: UIImage(named: "no_media")!)
            })
            
            let controller = LightboxController(images: items)
            controller.dynamicBackground = true
            
            viewController?.present(controller, animated: true, completion: {
                
            })
        }
    }

    override func onCreateViews() {
        super.onCreateViews()
        
        contentView.addSubview(pagerView)

        self.contentView.setTouch(target: self, selector: #selector(onOpenLightBox))
        self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        self.pagerView.itemSize = FSPagerView.automaticSize
        self.pagerView.transformer = FSPagerViewTransformer(type:.coverFlow)
        
        pagerView.delegate = self
        pagerView.dataSource = self
    }
}
